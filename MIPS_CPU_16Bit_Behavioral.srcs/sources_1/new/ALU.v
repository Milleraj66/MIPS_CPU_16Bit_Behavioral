`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2016 04:17:57 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(Opcode,InputA,InputB,BNE_Flag,Output);
    input [2:0] Opcode;
    input [15:0] InputA,InputB;
    input BranchFlag;
    output [15:0] Output;
    
    always @(InputA or InputB or Opcode)
    begin
        case (Opcode)
            // Add
            0 : Output = InputA + InputB;
            // Subtract
            1 : Output = InputA - InputB;
            // Bitwise And
            2 : Output = InputA & InputB;
            // Bitwise Or
            3 : Output = InputA | InputB;
            //4 : 
            // BNE Flag
            5 : 
            begin
                if (InputA - InputB == 0) BNE_Flag = 0;
                else BNE_Flag = 1;
            end
            //6 : 
            //7 :
            //default :
        endcase
    end
endmodule
