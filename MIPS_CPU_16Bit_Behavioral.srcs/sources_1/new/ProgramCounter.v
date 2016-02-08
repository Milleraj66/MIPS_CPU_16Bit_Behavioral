`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2016 04:16:27 PM
// Design Name: 
// Module Name: ProgramCounter
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


module ProgramCounter(Clk,Reset,PC,PC_Next);
    input Clk;
    input Reset;
    input [15:0] PC;
    output reg [15:0] PC_Next;
    
    always @ (posedge Clk)
    begin
        if(Reset)
        begin
           PC_Next = 0;
        end
        
        else
        begin
            PC_Next = PC + 1;
        end
    end
endmodule
