`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2018 10:06:58 AM
// Design Name: 
// Module Name: mouse_module
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


module mouse_module(
      input wire clk40,
      input wire clk100,
      
      inout wire ps2_clk,
      inout wire ps2_data,
      input wire rst,
      
      output wire [11:0] xpos,
      output wire [11:0] ypos,
      output wire left
    );
    
    
    
wire left_out;
wire [11:0] xpos_out, ypos_out;
    
    MouseCtl mouse_module (
        .clk(clk100),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .rst(rst),
        .xpos(xpos_out),
        .ypos(ypos_out),
        .left(left_out)
        
    );    
    
 ////////////////////////////////////////////////////////
 //////////       buffer module           ///////////////
 ////////////////////////////////////////////////////////
          
          
          buffer_module buffer_module(
              .xpos_in(xpos_out),
              .ypos_in(ypos_out),
              .mouseleft_in(left_out),
              .clk(clk40),
              .rst(rst),
              
              .xpos_out(xpos),
              .ypos_out(ypos),
              .mouseleft_out(left)
          );
          
              
    
    
    
    
endmodule
