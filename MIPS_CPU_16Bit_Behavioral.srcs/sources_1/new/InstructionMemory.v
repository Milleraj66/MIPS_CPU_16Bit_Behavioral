`timescale 1ns / 1ps

//
//
//	Imem:	The Instruction Memory module
//	Parameter List:
//		clk:		the memory clock (input)
//		address:	the instruction address (input)
//		instruction:	the instruction (output)
//
//	Author:	Nestoras Tzartzanis
//	Date:	1/25/96
//	EE577b: Verilog Example
//
//

// Read only instruction memory
module InstructionMemory (Clk,Addr,Data_Out);
    input Clk;
    input [15:0] Addr;
    output reg [15:0] Data_Out;
    reg [15:0] my_memory [0:63]; // Memory Width: 16bits, Memory Depth: 0 to 2^15-1?

    initial
        begin
            my_memory[0] = 16'b1000_0000_0000_0000;     // LW   $R0,0($R0)              # $R0 initally 0:   $R0 <= 8
            my_memory[1] = 16'b1000_0001_0001_0001;     // LW   $R1,1($R1)              # $R1 initally 0:   $R1 <= 2
            my_memory[2] = 16'b0010_0000_0001_0010;     // ADD  $R0,$R1,$R2             # $R2 = $R1 + $R2:  $R2 <= 10
            my_memory[3] = 16'b1000_0011_0011_0001;     // LW   $R3,1($R3)              # $R3 initially 0:  $R3 <= 2
            my_memory[4] = 16'b1110_0001_0011_0111;     // BNE  $R1,$R3,0               # $R1 = $R3 -> Dont Branch
            my_memory[5] = 16'b0000_0000_0010_0100;     // AND  $R0,$R2,$R4             #                   $R4 <= 8 
            my_memory[6] = 16'b0001_0000_0010_0101;     // OR   $R0,$R2,$R5             #                   $R5 <= 10
            // Loop 5 times
            my_memory[7] = 16'b0010_0001_0011_0011;     // ADD  $R1,$R3,$R3             # +2 until 10
            my_memory[8] = 16'b1110_0011_0010_1110;     // BNE  $R3,$R2,my_memory[7]    # $R1 = $R3 -> Dont Branch
            my_memory[9] = 16'hA616;                     // SW   $R1,6($R6)            # $R3 initially 0:  Mem[6+0] <= 2
            my_memory[10] = 16'hA737;                    // SW   $R3,7($R7)            # $R3 initially 0:  Mem[7+0] <= 10
        end
    
    //*** 1. Read instruction memory at Addr
    always @(posedge Clk) 
    begin 
            Data_Out = my_memory [Addr];
    end

endmodule
