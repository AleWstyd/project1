`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2018 12:33:41 PM
// Design Name: 
// Module Name: click_check
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


module click_check
    # ( parameter
        X_UP_BOX = 0,
        Y_UP_BOX = 0,
        BOX_WIDTH = 50,
        BOX_HEIGHT = 50 
    )(
    input wire clk,
    input wire rst,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire left,
    
    output reg clicked
    
    );

reg clicked_nxt=0;

always @(posedge clk)
    begin
        if (rst) clicked <= 0;
        else clicked <= clicked_nxt;
    end
    
always @*
        if (left == 1 && (xpos > X_UP_BOX) && (xpos < (X_UP_BOX + BOX_WIDTH)) && (ypos > Y_UP_BOX) &&  (ypos < (Y_UP_BOX + BOX_HEIGHT))) clicked_nxt <= 1;
        else clicked_nxt <= 0;



endmodule
