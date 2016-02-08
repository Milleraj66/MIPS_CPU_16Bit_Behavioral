`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2016 04:16:47 PM
// Design Name: 
// Module Name: RegisterFile
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

module RegisterFile(Clk,Clear,Write,Aaddr,Baddr,Caddr,DataIn,Aout,Bout);
    input Clk;
    input Clear;
    input Write;
    input [3:0] Aaddr,Baddr,Caddr;
    input [15:0] DataIn;
    output reg [15:0] Aout,Bout;
    
    // Register File [Width] Reg [Depth]
    reg [15:0] RegFile [15:0];
    
    always @(posedge Clk)
    begin
        //Always read  A and B
        Aout = RegFile[Aaddr];
        Bout = RegFile[Baddr];
        // Clear Registers
        if (Clear) RegFile = 4'h0000;
        // Write to register
        else if (Write) 
        begin
            RegFile[Caddr] = DataIn;
        end
    end
endmodule
