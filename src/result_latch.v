`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2018 03:11:18 PM
// Design Name: 
// Module Name: result_latch
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


module result_latch(
    input wire clk,
    input wire rst,
    input wire [9:0] result_in,
    
    output reg [9:0] result_out

    );
    
reg [9:0] result_nxt;


always @(posedge clk)
          result_out <= result_nxt;
    
always @*
        if (rst)
           result_nxt <= result_out;
        else
           result_nxt <= result_in;
    
          
    
    
    
endmodule
