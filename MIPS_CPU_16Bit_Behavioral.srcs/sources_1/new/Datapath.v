`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Arthur J. Miller
// Create Date: 02/05/2016 04:11:32 PM
// UPDATE: AJM 02/06/2016 : Finish wiring datapath
// Module Name: Datapath
// Purpose: 16bit MIPS Cpu w/ Behavioarl design (exact copy of ECE425L)
//////////////////////////////////////////////////////////////////////////////////


module Datapath(Clk,Reset);
    input Clk;
    input Reset;
    wire [15:0] PC,PC_Next;
    wire [15:0] Inst,Aout,BoutALU_Out,Data_Out,Offset;
    wire BNE_Flag;
    wire [3:0] Control;
    
    // 4 bit Control Unit
    ControlUnit                 CU_UUT      (
                                             .OPCODE(Inst[15:12]),
                                             .Control(Control)
                                             );
    // CPU DATAPATH
    //****  Program Counter
    ProgramCounter              PC_UUT      (
                                             .Clk(Clk),
                                             .Reset(Reset),
                                             .PC(PC),
                                             .PC_Next(PC_Next)
                                             );
    //****  Instruction Memory
    InstructionMemory           IM_UUT      (
                                             .Clk(Clk),
                                             .Addr(PC_Next),
                                             .Data_Out(Inst)
                                             );
    //Mux4bit_2to1            RegDst_MUX   (1'b1,Control[0],Ins[3:0],Ins[7:4],Caddr);
    always @(Control[0] or Inst[3:0] or Inst[7:4])
    begin
        case(Control[0]) 
            0: Caddr = Inst[7:4];
            1: Caddr = Inst[3:0]; 
        endcase
    end
    //****  Register File
    RegisterFile                RF_UUT      (
                                             .Clk(Clk),
                                             .Clear(Reset),
                                             .Write(Control[9]),
                                             .Aaddr(Inst[11:8]),
                                             .Baddr(Inst[7:4]),
                                             .Caddr(Caddr),
                                             .DataIn(MemToReg_Out),
                                             .Aout(Aout),
                                             .Bout(Bout)
                                             );
    //**** Sign Extend
    SignExtend                SE_UUT      (
                                             .Data_In(Inst[3:0]),
                                             .Data_Out(Offset)
                                             );
    
    //Mux16bit_2to1           ALUsrc_MUX   (1'b1,Control[8],Offset,B,ALUsrc_Out);
    always @(Control[8] or Offset or Bout)
    begin
        case(Control[8]) 
            0: ALUsrc_Out = Bout;
            1: ALUsrc_Out = Offset; 
        endcase
    end
    //****  ALU
    ALU                         ALU_UUT     (
                                             .Opcode(Control[6:4]),
                                             .InputA(Aout),
                                             .InputB(ALUsrc_Out),
                                             .BNE_Flag(BNE_Flag),
                                             .Output(ALU_Out)
                                             );
    //****  Data Memory
    DataMemory                  DM_UUT      (
                                             .Clk(Clk),
                                             .Addr(ALU_Out),
                                             .Write(Control[2]),
                                             .Data_In(Bout),
                                             .Data_Out(Data_Out)
                                             );
    //Mux16bit_2to1           MemToReg_MUX   (1'b1,Control[3],Mem_Out,ALU_Out,MemToReg_Out);
    always @(Control[3] or Data_Out or ALU_Out)
    begin
        case(Control[3]) 
            0: MemToReg_Out = ALU_Out;
            1: MemToReg_Out = Data_Out; 
        endcase
    end
    //**** Branch
    // Add offset and PC+1
    // and branch flag with control[1]
    //                                   (Enable,Select,Input1[16b],Input0[16b],Output[16b])
    //Mux16bit_2to1           Branch_MUX   (1'b1,BranchSelect,PC_PlusOnePlusOFFSET_Out,PC_PlusONE_Out,PC_Branch_Out);
    always @(Control[1])
    begin
        case(Control[1] & BNE_Flag) 
            0: PC_Branch_Out = PC_Next+1;
            1: PC_Branch_Out = PC_Next+1+Offset; 
        endcase
    end
    
    //*** Jump
    // Mux output of PC_MUX and Jump address. Select control 1: jump & 0:PC_MUX output 
    //                                 (Enable,Select,Input1[16],Input0[16],Output[16]
    //Mux16bit_2to1           Jump_MUX   (1'b1,Control[10],Ins,PC_Branch_Out,PC_Next);
    always @(Control[10])
    begin
        case(Control[10]) 
            0: PC = PC_Branch_Out;
            1: PC = Inst; 
        endcase
    end    

endmodule
