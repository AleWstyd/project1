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


module vga_module(
    input wire clk40,  
	input wire rst,  
	input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire left, 

    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b,
    output wire vs,
    output wire hs

    );


    localparam  HOLE_SIZE = 40;
    localparam  HOLE_1_Y = 135;
    localparam  HOLE_1_X = 185;
        
    localparam HOLE_2_Y = 285;
    localparam HOLE_2_X = 385;
        
    localparam HOLE_3_Y = 435;
    localparam HOLE_3_X = 585;
        
    localparam MOLE_HEIGHT = 60;
    localparam MOLE_WIDTH = 30;
    localparam MOLE_COLOUR = 12'h6_2_0;
    
    
////////////////////////////////////////////////////////
  //////////       timing module           ///////////////
  ////////////////////////////////////////////////////////

  wire [10:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;

  vga_timing my_timing (
    .clk(clk40),
    .rst(rst),
    
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk)
    
  );

////////////////////////////////////////////////////////////
//////////       background module           ///////////////
///////////////////////////////////////////////////////////

  wire [10:0] vcount_out_b, hcount_out_b, vcount_out_c, hcount_out_c;
  wire vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c;
  wire vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c;
  wire [11:0] rgb_out_b, rgb_out_c;

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
    
    .hcount_out(hcount_out_b),
    .hsync_out(hsync_out_b),
    .hblnk_out(hblnk_out_b),
    .vcount_out(vcount_out_b),
    .vsync_out(vsync_out_b),
    .vblnk_out(vblnk_out_b),
    .rgb_out(rgb_out_b)
  );
  
//////////////////////////////////////////////////////////////
//////////       draw rect module           ///////////////
///////////////////////////////////////////////////////////
  
    wire [11:0] xpos_in, ypos_in;  
    wire [10:0] vcount_out, hcount_out;
    wire vsync_out, hsync_out;
    wire vblnk_out, hblnk_out;
    wire [11:0] rgb_out;
    wire [11:0] address, rgb_pixel; 
    
    draw_rect draw_rect (
        .vcount_in(vcount_out_b),
        .vsync_in(vsync_out_b),
        .vblnk_in(vblnk_out_b),
        .hcount_in(hcount_out_b),
        .hsync_in(hsync_out_b),
        .hblnk_in(hblnk_out_b),
        .rgb_in(rgb_out_b),
        .pclk(clk40),
        .xpos(xpos_in),
        .ypos(ypos_in),
        
        .rgb_pixel(rgb_pixel),
        
        .hcount_out(hcount_out),
        .hsync_out(hsync_out),
        .hblnk_out(hblnk_out),
        .vcount_out(vcount_out),
        .vsync_out(vsync_out),
        .vblnk_out(vblnk_out),
        .pixel_addr(address),
        .rgb_out(rgb_out)
      );
  
 ////////////////////////////////////////////////////////
      //////////       mouse display           ///////////////
      ////////////////////////////////////////////////////////
      
      wire [11:0] xpos_buff,ypos_buff;
      wire [0:3] green_out_m, red_out_m, blue_out_m; 
      
      MouseDisplay mouse_display(
      
          .xpos(xpos_buff),
          .ypos(ypos_buff),
          .pixel_clk(clk40),
          .red_in(rgb_out_c[11:8]),
          .green_in(rgb_out_c[7:4]),
          .blue_in(rgb_out_c[3:0]),
          .blank(hblnk_out_c || vblnk_out_c),
          .hcount({1'b0,hcount_out_c+1}),
          .vcount({1'b0,vcount_out_c}),
          
          
          .red_out(r),
          .green_out(g),
          .blue_out(b)
      );
      
      ////////////////////////////////////////////////////////
      //////////       buffer module           ///////////////
      ////////////////////////////////////////////////////////
      
      wire mouseleft_out;
      
      buffer_module buffer_module(
          .xpos_in(xpos),
          .ypos_in(ypos),
          .mouseleft_in(left),
          .clk(clk40),
          
          .xpos_out(xpos_buff),
          .ypos_out(ypos_buff),
          .mouseleft_out(mouseleft_out)
      );
      
      ////////////////////////////////////////////////////////
      //////////          rom module           ///////////////
      ////////////////////////////////////////////////////////
      
      image_rom my_rom(
       
              .clk(clk40),
              .address(address),
              .rgb(rgb_pixel)
              );
      
       
      ////////////////////////////////////////////////////////
      //////////           ctl module          ///////////////
      //////////////////////////////////////////////////////// 
              
              draw_rect_ctl my_ctl(
                  .mouse_left(left),
                  .clk_in(clk40),
                  .mouse_xpos(xpos_buff),
                  .mouse_ypos(ypos_buff),
                  .xpos(xpos_in),
                  .ypos(ypos_in)
                         
              );     
              
      ////////////////////////////////////////////////////////
      //////////           rectangle char      ///////////////
      ////////////////////////////////////////////////////////
      
/*       wire [7:0] char_pixels, char_xy;
       wire [3:0] char_line;
       wire [6:0] char_code;
       wire [10:0] addr;
       
       draw_rect_char # (
         .X_UP_LEFT_CORNER(0),
         .Y_UP_LEFT_CORNER(0)
         )
       my_draw_rect_char(
         .pclk(clk40),
         .hcount_in(hcount_out),
         .hsync_in(hsync_out),
         .hblnk_in(hblnk_out),
         .vcount_in(vcount_out),
         .vsync_in(vsync_out),
         .vblnk_in(vblnk_out),
         .rgb_in(rgb_out),
         .char_pixels(char_pixels),
         
         .hcount_out(hcount_out_c),
         .hsync_out(hs),
         .hblnk_out(hblnk_out_c),
         .vcount_out(vcount_out_c),
         .vsync_out(vs),
         .vblnk_out(vblnk_out_c),
         .rgb_out(rgb_out_c),
         .char_xy(char_xy),
         .char_line(char_line)
       ); 
      
       char_rom_16x16 my_char_rom_16x16(
         .char_xy(char_xy),
         .char_code(char_code)
       );
       
       assign addr = {char_code, char_line};
       
       font_rom my_font_rom(
         .clk(clk40),
         .addr(addr),
         .char_line_pixels(char_pixels)
       );  
    */    
    wire [11:0] xpos_k,ypos_k;
    
   draw_moles  # (
            
            .MOLE_HEIGHT(MOLE_HEIGHT), 
            .MOLE_WIDTH(MOLE_WIDTH),
            .MOLE_COLOUR(MOLE_COLOUR)
            )
         my_moles(
        .clk(clk40),
        .hcount_in(hcount_out),
        .hsync_in(hsync_out),
        .hblnk_in(hblnk_out),
        .vcount_in(vcount_out),
        .vsync_in(vsync_out),
        .vblnk_in(vblnk_out),
        .rgb_in(rgb_out),
        .rst(rst),
        .xpos(xpos_k),
        .ypos(ypos_k),
        
        
        .hcount_out(hcount_out_c),
        .hsync_out(hs),
        .hblnk_out(hblnk_out_c),
        .vcount_out(vcount_out_c),
        .vsync_out(vs),
        .vblnk_out(vblnk_out_c),
        .rgb_out(rgb_out_c)
    
        );
        
        
    wire enable;
    wire [9:0] random_number;
    
    mole_control my_moles_control (
    
            .clk(clk40),

            
            .random_number(random_number)
         );
   
   
   
   
         main_mole  # (
                     .HOLE_SIZE(HOLE_SIZE),
                     .HOLE_1_Y (HOLE_1_Y),
                     .HOLE_1_X (HOLE_1_X),
                        
                     .HOLE_2_Y (HOLE_2_Y),
                     .HOLE_2_X(HOLE_2_X),
                        
                     .HOLE_3_Y(HOLE_3_Y),
                     .HOLE_3_X(HOLE_3_X),
                     
                     .MOLE_HEIGHT(MOLE_HEIGHT), 
                     .MOLE_WIDTH(MOLE_WIDTH)
                   
                     )
                  my_main_moles(
                  
                 .clk(clk40),
                 .rst(rst),
                 .xpos(xpos),
                 .ypos(ypos),
                 .left(left),
                 .xpos_out(xpos_k),
                 .ypos_out(ypos_k),
                 .random_number(random_number)
                 

               
                 );
                 
               
                 
                 
                 
                 
endmodule