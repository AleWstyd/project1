`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2018 11:44:31 AM
// Design Name: 
// Module Name: draw_image
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


module draw_end(
    input wire clk40,  
	input wire rst,  
    
    input wire [10:0] vcount,
    input wire [10:0] hcount,
    input wire vsync, 
    input wire hsync,
    input wire vblnk, 
    input wire hblnk,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire left,

    output wire restart,
    output wire [10:0] hcount_out,
    output wire hs,
    output wire hblnk_out,
    output wire [10:0] vcount_out,   
    output wire vs,
    output wire vblnk_out,
    output wire [11:0] rgb_out
    );
    
   
   
    wire [20:0] address;  
    wire [11:0] rgb_pixel; 
    wire [10:0] vcount_out_d, hcount_out_d;
    wire  vsync_out_d, hsync_out_d;
    wire  vblnk_out_d, hblnk_out_d;
    wire [11:0] rgb_out_d;
    
    
////////////////////////////////////////////////////////
/////////      backrgound image rom      ///////////////
////////////////////////////////////////////////////////
              
                          
          image_rom # (
                  .FILE_PATH("C:/Users/Mikolaj/Desktop/obrazki/test.data"),
                  .X_WIDTH(6),
                  .Y_WIDTH(5)
                )
               end_rom(     
             .clk(clk40),
             .address(address),
             .rgb(rgb_pixel)
             );
      
     ////////////////////////////////////////////////////////
     //////////     draw background image     ///////////////
     ////////////////////////////////////////////////////////
                   
                   
                      
       draw_moles  # (
                
                .HEIGHT(200), 
                .WIDTH(100),
                 .X_WIDTH(6),
                 .Y_WIDTH(5)
                )
             my_end_screen(
            .clk(clk40),
            .hcount_in(hcount),
            .hsync_in(hsync),
            .hblnk_in(hblnk),
            .vcount_in(vcount),
            .vsync_in(vsync),
            .vblnk_in(vblnk),
            .rgb_in(12'b0),
            .rst(rst),
            .rgb_pixel(rgb_pixel),
            .xpos('d160),
            .ypos('d100),
            
            .pixel_addr(address),
            .hcount_out(hcount_out_d),
            .hsync_out(hsync_out_d),
            .hblnk_out(hblnk_out_d),
            .vcount_out(vcount_out_d),
            .vsync_out(vsync_out_d),
            .vblnk_out(vblnk_out_d),
            .rgb_out(rgb_out_d)
        
            );  
    
    
 ////////////////////////////////////////////////////////
 //////////           rectangle char      ///////////////
 ////////////////////////////////////////////////////////
                  
                   wire [7:0] char_pixels, char_xy;
                   wire [3:0] char_line;
                   wire [6:0] char_code;
                   wire [10:0] addr;
                   wire [9:0] result;
                   
                   draw_rect_char # (
                     .X_UP_LEFT_CORNER(680),
                     .Y_UP_LEFT_CORNER(1)
                     )
                   my_draw_rect_char(
                     .pclk(clk40),
                     .hcount_in(hcount_out_d),
                     .hsync_in(hsync_out_d),
                     .hblnk_in(hblnk_out_d),
                     .vcount_in(vcount_out_d),
                     .vsync_in(vsync_out_d),
                     .vblnk_in(vblnk_out_d),
                     .rgb_in(rgb_out_d),
                     .char_pixels(char_pixels),
                     .rst(rst),
                     
                     .hcount_out(hcount_out),
                     .hsync_out(hs),
                     .hblnk_out(hblnk_out),
                     .vcount_out(vcount_out),
                     .vsync_out(vs),
                     .vblnk_out(vblnk_out),
                     .rgb_out(rgb_out),
                     .char_xy(char_xy),
                     .char_line(char_line)
                   ); 
             
   ////////////////////////////////////////////////////////
   //////////           char rom       ///////////////
  ////////////////////////////////////////////////////////       
                  
                   char_rom_16x16 my_char_rom_16x16(
                     .char_xy(char_xy),
                     .result(result),
                     .clk(clk40),
                     .rst(rst),
                     .char_code(char_code)
                   );
                   
                   assign addr = {char_code, char_line};
                   
  ////////////////////////////////////////////////////////
  /////////           font rom           ///////////////
  ////////////////////////////////////////////////////////
            
                   
                   font_rom my_font_rom(
                     .clk(clk40),
                     .addr(addr),
                     .char_line_pixels(char_pixels)
                   );  
                   
  ////////////////////////////////////////////////////////
  /////////           click check          ///////////////
  ////////////////////////////////////////////////////////  
  
  click_check #
            (.X_UP_BOX (300),
             .Y_UP_BOX(300),
             .BOX_WIDTH (200),
             .BOX_HEIGHT (100)
              )
          my_end_click (
          .left(left),
          .clk(clk40),
          .rst(rst),
          .xpos(xpos),
          .ypos(ypos),
          
          .clicked(restart)
          );
    
endmodule
