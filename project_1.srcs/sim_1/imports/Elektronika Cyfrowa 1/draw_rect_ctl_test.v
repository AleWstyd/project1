`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.03.2018 20:47:04
// Design Name: 
// Module Name: draw_rect_ctl_test
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


module draw_rect_ctl_test;

reg clk;
wire mouse_left;
wire [11:0] mouse_xpos, mouse_ypos;
wire [11:0] xpos,ypos;

draw_rect_ctl_tb my_rect_tb(
    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos)

);
   
draw_rect_ctl my_rect(   
    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos),
    
    .x_pos(xpos),
    .y_pos(ypos),
    .pclk(clk)
);


always
 begin
   clk = 1'b0;
   #2;
   clk = 1'b1;
   #2;
end
  
initial
  begin
    $display("Draw_rect_ctl simulation start");
    wait (mouse_left == 1'b1);
    $display("Mouse left click, rectangle starts falling");
    wait (ypos == 600);
    $stop;
  end  

   
   
endmodule
