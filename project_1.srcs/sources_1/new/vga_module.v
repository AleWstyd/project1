`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2018 01:10:08 PM
// Design Name: 
// Module Name: vga_module
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


module game_module(
    input wire clk40,  
	input wire rst,  
	input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire left, 
    
    input wire [10:0] vcount,
    input wire [10:0] hcount,
    input wire vsync, 
    input wire hsync,
    input wire vblnk, 
    input wire hblnk,

    output wire end_game,
    output wire [10:0] hcount_out,
    output wire hs,
    output wire hblnk_out,
    output wire [10:0] vcount_out,   
    output wire vs,
    output wire vblnk_out,
    output wire [11:0] rgb_out
    

    );


    localparam  HOLE_SIZE = 48;
    localparam  HOLE_1_Y = 128;  
    localparam  HOLE_1_X = 170;
        
    localparam HOLE_2_Y = 285;
    localparam HOLE_2_X = 376;
        
    localparam HOLE_3_Y = 435;
    localparam HOLE_3_X = 582;
        
    localparam MOLE_HEIGHT = 64;
    localparam MOLE_WIDTH = 32;
    localparam MOLE_COLOUR = 12'h6_2_0;
    
    

////////////////////////////////////////////////////////////
//////////       background module           ///////////////
///////////////////////////////////////////////////////////

  wire [10:0] vcount_out_b, hcount_out_b, vcount_out_c, hcount_out_c, vcount_out_d, hcount_out_d;
  wire vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c, vsync_out_d, hsync_out_d;
  wire vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c, vblnk_out_d, hblnk_out_d;
  wire [11:0] rgb_out_b, rgb_out_c, rgb_out_d;

    draw_background # (
         .HOLE_SIZE(HOLE_SIZE),
         .HOLE_1_Y (HOLE_1_Y),
         .HOLE_1_X (HOLE_1_X),
            
         .HOLE_2_Y (HOLE_2_Y),
         .HOLE_2_X(HOLE_2_X),
            
          .HOLE_3_Y(HOLE_3_Y),
          .HOLE_3_X(HOLE_3_X)
         )
      my_background (
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),
    .pclk(clk40),
    .rst(rst),
    
    .hcount_out(hcount_out_b),
    .hsync_out(hsync_out_b),
    .hblnk_out(hblnk_out_b),
    .vcount_out(vcount_out_b),
    .vsync_out(vsync_out_b),
    .vblnk_out(vblnk_out_b),
    .rgb_out(rgb_out_b)
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
       
    wire [11:0] xpos_k,ypos_k;
    wire [20:0] address;  
    wire [11:0] rgb_pixel;
             
 ////////////////////////////////////////////////////////
/////////           mole image rom        ///////////////
////////////////////////////////////////////////////////
          
                      
      image_rom # (
              .FILE_PATH("C:/Users/Mikolaj/Desktop/obrazki/test.data"),
              .X_WIDTH(5),
              .Y_WIDTH(6)
            )
           mole_rom(     
         .clk(clk40),
         .address(address),
         .rgb(rgb_pixel)
         );
  
 ////////////////////////////////////////////////////////
 //////////           draw mole           ///////////////
 ////////////////////////////////////////////////////////
               
               
                  
   draw_moles  # (
             .X_WIDTH(5),
             .Y_WIDTH(6)
            )
         my_moles(
        .clk(clk40),
        .hcount_in(hcount_out_b),
        .hsync_in(hsync_out_b),
        .hblnk_in(hblnk_out_b),
        .vcount_in(vcount_out_b),
        .vsync_in(vsync_out_b),
        .vblnk_in(vblnk_out_b),
        .rgb_in(rgb_out_b),
        .rst(rst),
        .rgb_pixel(rgb_pixel),
        .xpos(xpos_k),
        .ypos(ypos_k),
        
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
 //////////     random number generator    ///////////////
  ////////////////////////////////////////////////////////
    wire [9:0] random_number;
    
    mole_control my_moles_control (
            .clk(clk40),
            .random_number(random_number)
         );
   
   
   
////////////////////////////////////////////////////////
//////////           main mole module    ///////////////
////////////////////////////////////////////////////////   

         main_mole  # (
                     .HOLE_SIZE(HOLE_SIZE),
                     .HOLE_1_Y (HOLE_1_Y),
                     .HOLE_1_X (HOLE_1_X),
                     
                     .MOLE_HEIGHT(MOLE_HEIGHT), 
                     .MOLE_WIDTH(MOLE_WIDTH)
                   
                     )
                  my_main_moles(
                  
                 .clk(clk40),
                 .rst(rst),
                 .xpos(xpos),
                 .ypos(ypos),
                 .left(left),
                 .random_number(random_number),
                 
                 .end_game(end_game),
                 .xpos_out(xpos_k),
                 .ypos_out(ypos_k),
                 .result(result)
                  );
             
                 
endmodule