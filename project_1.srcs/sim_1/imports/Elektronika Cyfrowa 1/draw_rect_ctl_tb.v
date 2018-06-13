`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 22:22:50
// Design Name: 
// Module Name: draw_rect_ctl_tb
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


module draw_rect_ctl_tb(
    output reg mouse_left,
    output reg [11:0] mouse_xpos,
    output reg [11:0] mouse_ypos
    );



initial 
    begin
        mouse_xpos <= 0;
        mouse_ypos <= 0;
        mouse_left <= 0;
        #10;
        mouse_left <= 1'b1;
    end
    
    
endmodule