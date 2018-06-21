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

    output wire [9:0] result_out,
    output wire end_game,
    output wire [10:0] hcount_out,
    output wire hs,
    output wire hblnk_out,
    output wire [10:0] vcount_out,   
    output wire vs,
    output wire vblnk_out,
    output wire [11:0] rgb_out
    

    );


// LOCAL PARAMETERS
    

    localparam  HOLE_SIZE = 38;
    localparam  HOLE_1_Y = 135;  
    localparam  HOLE_1_X = 170;
        
    localparam HOLE_2_Y = 285;
    localparam HOLE_2_X = 376;
        
    localparam HOLE_3_Y = 435;
    localparam HOLE_3_X = 582;
        
    localparam MOLE_HEIGHT = 64;
    localparam MOLE_WIDTH = 32;
    
    localparam DELAY_1MS = 40_000;  // equals 40000  clock cycles, so for a 40MHz clock is a 1 ms delay
    
    localparam    DELAY_SHOW_DECREASE = 40 * DELAY_1MS,     // time in ms 
                  DELAY_WAIT_DECREASE = 40 * DELAY_1MS,
                  DELAY_WAIT = 1500 * DELAY_1MS,            
                  DELAY_SHOW = 2000 * DELAY_1MS,            // delay vaules for mole 1
                  DELAY_SHOW_MIN = 750 * DELAY_1MS, 
                  DELAY_WAIT_MIN = 400 * DELAY_1MS,
                  INIT_DELAY = 1500 * DELAY_1MS;
    
    
    localparam    DELAY_SHOW_DECREASE1 = 40 * DELAY_1MS,     // time in ms 
                  DELAY_WAIT_DECREASE1 = 40 * DELAY_1MS,
                  DELAY_WAIT1 = 2000 * DELAY_1MS,            
                  DELAY_SHOW1 = 2500 * DELAY_1MS,            // delay vaules for mole 2
                  DELAY_SHOW_MIN1 = 700 * DELAY_1MS, 
                  DELAY_WAIT_MIN1 = 500 * DELAY_1MS,
                  INIT_DELAY1 = 3000 * DELAY_1MS;
                  
    localparam    DELAY_SHOW_DECREASE2 = 0 * DELAY_1MS,     // time in ms 
                  DELAY_WAIT_DECREASE2 = 0 * DELAY_1MS,
                  DELAY_WAIT2 = 10000 * DELAY_1MS,            
                  DELAY_SHOW2 = 700 * DELAY_1MS,            // delay vaules for golden mole 
                  DELAY_SHOW_MIN2 = 500 * DELAY_1MS, 
                  DELAY_WAIT_MIN2 = 400 * DELAY_1MS,
                  INIT_DELAY2 = 100 * DELAY_1MS;
    

////////////////////////////////////////////////////////////
//////////       wires and regs             ///////////////
///////////////////////////////////////////////////////////

  wire [10:0] vcount_out_b, hcount_out_b, vcount_out_c, hcount_out_c, vcount_out_d, hcount_out_d;
  wire vsync_out_b, hsync_out_b, vsync_out_c, hsync_out_c, vsync_out_d, hsync_out_d;
  wire vblnk_out_b, hblnk_out_b, vblnk_out_c, hblnk_out_c, vblnk_out_d, hblnk_out_d;
  wire [11:0] rgb_out_b, rgb_out_c, rgb_out_d;
  
  wire [11:0] xpos_m2,ypos_m2,xpos_m3,ypos_m3;
  wire [20:0] address1,address2;  
  wire [11:0] rgb_pixel1,rgb_pixel2;      
  wire [9:0] result1,result2;    
  
  wire [10:0] vcount_out_m1, hcount_out_m1;
  wire  vsync_out_m1, hsync_out_m1;
  wire  vblnk_out_m1, hblnk_out_m1;
  wire [11:0] rgb_out_m1;
  
  wire [10:0] vcount_out_m2, hcount_out_m2;
  wire  vsync_out_m2, hsync_out_m2;
  wire  vblnk_out_m2, hblnk_out_m2;
  wire [11:0] rgb_out_m2;
    
  wire [3:0] missed1, missed2; 
  
  //////////////////////////////
  
  assign end_game = (missed1 + missed2 == 3) ;                // how many missed moles to end the game
  
  //////////////////////////
  
////////////////////////////////////////////////////////////
//////////       draws hole frame            ///////////////
///////////////////////////////////////////////////////////
  
    draw_holes # (
          .HOLE_CLR(12'h000),
          .HOLE_SIZE(HOLE_SIZE),
          .HOLE_1_Y(HOLE_1_Y),
          .HOLE_1_X(HOLE_1_X),
         
          .HOLE_2_Y (HOLE_2_Y),
          .HOLE_2_X (HOLE_2_X),
         
          .HOLE_3_Y (HOLE_3_Y),
          .HOLE_3_X (HOLE_3_X)
         )
      my_hole_frame (
    .rgb_in(12'h0a0),
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
  
    
 ////////////////////////////////////////////////////////////
  //////////       draws hole filling            ///////////////
  ///////////////////////////////////////////////////////////
   
   wire [10:0] vcount_out_b1, hcount_out_b1;
   wire  vsync_out_b1, hsync_out_b1;
   wire  vblnk_out_b1, hblnk_out_b1;
   wire [11:0] rgb_out_b1;
    
    draw_holes # (
            .HOLE_CLR(12'h840),
            .HOLE_SIZE(HOLE_SIZE-4),
            .HOLE_1_Y(HOLE_1_Y+2),
            .HOLE_1_X(HOLE_1_X+2),
           
            .HOLE_2_Y (HOLE_2_Y+2),
            .HOLE_2_X (HOLE_2_X+2),
           
            .HOLE_3_Y (HOLE_3_Y+2),
            .HOLE_3_X (HOLE_3_X+2)
           )
        my_hole_filling (
      .rgb_in(rgb_out_b),
      .vcount_in(vcount_out_b),
      .vsync_in(vsync_out_b),
      .vblnk_in(vblnk_out_b),
      .hcount_in(hcount_out_b),
      .hsync_in(hsync_out_b),
      .hblnk_in(hblnk_out_b),
      .pclk(clk40),
      .rst(rst),
      
      .hcount_out(hcount_out_b1),
      .hsync_out(hsync_out_b1),
      .hblnk_out(hblnk_out_b1),
      .vcount_out(vcount_out_b1),
      .vsync_out(vsync_out_b1),
      .vblnk_out(vblnk_out_b1),
      .rgb_out(rgb_out_b1)
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
         .Y_UP_LEFT_CORNER(1),
         .X_RECT_SIZE(128),
         .Y_RECT_SIZE (32)
         )
       my_draw_rect_char(
         .pclk(clk40),
         .hcount_in(hcount_out_m2),
         .hsync_in(hsync_out_m2),
         .hblnk_in(hblnk_out_m2),
         .vcount_in(vcount_out_m2),
         .vsync_in(vsync_out_m2),
         .vblnk_in(vblnk_out_m2),
         .rgb_in(rgb_out_m2),
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
         .result(result+result1+result2*10),
         .missed(missed1 + missed2),
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
       
    wire [11:0] xpos_m1,ypos_m1;
    wire [20:0] address;  
    wire [11:0] rgb_pixel;
             
 ////////////////////////////////////////////////////////
/////////           mole1 image rom        ///////////////
////////////////////////////////////////////////////////
          
                      
      image_rom # (
              .FILE_PATH("C:/Users/Mikolaj/Desktop/obrazki/dicklett.data"),
              .X_WIDTH(5),
              .Y_WIDTH(6)
            )
           mole1_rom(     
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
         draw_mole1(
        .clk(clk40),
        .hcount_in(hcount_out_b1),
        .hsync_in(hsync_out_b1),
        .hblnk_in(hblnk_out_b1),
        .vcount_in(vcount_out_b1),
        .vsync_in(vsync_out_b1),
        .vblnk_in(vblnk_out_b1),
        .rgb_in(rgb_out_b1),
        .rst(rst),
        .rgb_pixel(rgb_pixel),
        .xpos(xpos_m1),
        .ypos(ypos_m1),
        
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
    
    mole_control my_random_number (
            .clk(clk40),
            .random_number(random_number)
         );
   
   
   
////////////////////////////////////////////////////////
//////////       mole1 control module    ///////////////
////////////////////////////////////////////////////////   

         main_mole  # (
                     .DELAY_SHOW_DECREASE(DELAY_SHOW_DECREASE),
                     .DELAY_WAIT_DECREASE(DELAY_WAIT_DECREASE),
                     .DELAY_WAIT(DELAY_WAIT),
                     .DELAY_SHOW(DELAY_SHOW),
                     .DELAY_SHOW_MIN(DELAY_SHOW_MIN), 
                     .DELAY_WAIT_MIN(DELAY_WAIT_MIN),
                     .INIT_DELAY(INIT_DELAY),
                     .HOLE_1_Y (HOLE_1_Y),
                     .HOLE_1_X (HOLE_1_X),
                     
                     .MOLE_HEIGHT(MOLE_HEIGHT), 
                     .MOLE_WIDTH(MOLE_WIDTH)
                   
                     )
                  my_mole1(
                  
                 .clk(clk40),
                 .rst(rst),
                 .xpos(xpos),
                 .ypos(ypos),
                 .left(left),
                 .random_number(random_number),
                 
                 .missed(missed1),
                 .xpos_out(xpos_m1),
                 .ypos_out(ypos_m1),
                 .result(result)
                  );
        
        
        
 ////////////////////////////////////////////////////////
 //////////       result latch            ///////////////
 ////////////////////////////////////////////////////////   
 
 result_latch my_latch(
        .clk(clk40),
        .rst(rst),
        .result_in(result+result1+result2*10),
        
        .result_out(result_out)
        );
            
////////////////////////////////////////////////////////
/////////           mole2 image rom        ///////////////
////////////////////////////////////////////////////////
     
       
                              
              image_rom # (
                      .FILE_PATH("C:/Users/Mikolaj/Desktop/obrazki/dicklett.data"),
                      .X_WIDTH(5),
                      .Y_WIDTH(6)
                    )
                   mole2_rom(     
                 .clk(clk40),
                 .address(address1),
                 .rgb(rgb_pixel1)
                 );
          
 ////////////////////////////////////////////////////////
 //////////           draw mole           ///////////////
 ////////////////////////////////////////////////////////
                       
                       
                          
           draw_moles  # (
                     .X_WIDTH(5),
                     .Y_WIDTH(6)
                    )
                 draw_mole2(
                .clk(clk40),
                .hcount_in(hcount_out_d),
                .hsync_in(hsync_out_d),
                .hblnk_in(hblnk_out_d),
                .vcount_in(vcount_out_d),
                .vsync_in(vsync_out_d),
                .vblnk_in(vblnk_out_d),
                .rgb_in(rgb_out_d),
                .rst(rst),
                .rgb_pixel(rgb_pixel1),
                .xpos(xpos_m2),
                .ypos(ypos_m2),
                
                .pixel_addr(address1),
                .hcount_out(hcount_out_m1),
                .hsync_out(hsync_out_m1),
                .hblnk_out(hblnk_out_m1),
                .vcount_out(vcount_out_m1),
                .vsync_out(vsync_out_m1),
                .vblnk_out(vblnk_out_m1),
                .rgb_out(rgb_out_m1)
            
                );
                
////////////////////////////////////////////////////////
//////////       mole1 control module    ///////////////
////////////////////////////////////////////////////////   
                
  main_mole  # (
              .DELAY_SHOW_DECREASE(DELAY_SHOW_DECREASE1),
              .DELAY_WAIT_DECREASE(DELAY_WAIT_DECREASE1),
              .DELAY_WAIT(DELAY_WAIT1),
              .DELAY_SHOW(DELAY_SHOW1),
              .DELAY_SHOW_MIN(DELAY_SHOW_MIN1), 
              .DELAY_WAIT_MIN(DELAY_WAIT_MIN1),
              .INIT_DELAY(INIT_DELAY1),
              .HOLE_1_Y (HOLE_1_Y),
              .HOLE_1_X (HOLE_1_X),
                                     
              .MOLE_HEIGHT(MOLE_HEIGHT), 
              .MOLE_WIDTH(MOLE_WIDTH)
                                   
                                     )
                                  my_mole2(
                                  
                                 .clk(clk40),
                                 .rst(rst),
                                 .xpos(xpos),
                                 .ypos(ypos),
                                 .left(left),
                                 .random_number(random_number),
                                 
                                 .missed(missed2),
                                 .xpos_out(xpos_m2),
                                 .ypos_out(ypos_m2),
                                 .result(result1)
                                  );
                                    
                                    
                                    
                                    
////////////////////////////////////////////////////////
/////////           mole2 image rom        ///////////////
////////////////////////////////////////////////////////
                                       
                                         
                                                                
                    image_rom # (
                           .FILE_PATH("C:/Users/Mikolaj/Desktop/obrazki/golden.data"),
                               .X_WIDTH(5),
                               .Y_WIDTH(6)
                                 )
                                 mole_gold_rom(     
                                   .clk(clk40),
                                   .address(address2),
                                   .rgb(rgb_pixel2)
                                  );
                                            
////////////////////////////////////////////////////////
//////////           draw mole           ///////////////
////////////////////////////////////////////////////////
                                                         
                                                         
                                                            
               draw_moles  # (
                         .X_WIDTH(5),
                         .Y_WIDTH(6)
                        )
                        draw_mole_golden(
                           .clk(clk40),
                           .hcount_in(hcount_out_m1),
                           .hsync_in(hsync_out_m1),
                           .hblnk_in(hblnk_out_m1),
                           .vcount_in(vcount_out_m1),
                           .vsync_in(vsync_out_m1),
                           .vblnk_in(vblnk_out_m1),
                           .rgb_in(rgb_out_m1),
                           .rst(rst),
                           .rgb_pixel(rgb_pixel2),
                           .xpos(xpos_m3),
                           .ypos(ypos_m3),
                                                  
                           .pixel_addr(address2),
                           .hcount_out(hcount_out_m2),
                           .hsync_out(hsync_out_m2),
                           .hblnk_out(hblnk_out_m2),
                           .vcount_out(vcount_out_m2),
                           .vsync_out(vsync_out_m2),
                           .vblnk_out(vblnk_out_m2),
                           .rgb_out(rgb_out_m2)
                                              
                         );
                                                  
////////////////////////////////////////////////////////
//////////       mole1 control module    ///////////////
////////////////////////////////////////////////////////   
                                                  
             main_mole  # (
                   .DELAY_SHOW_DECREASE(DELAY_SHOW_DECREASE2),
                   .DELAY_WAIT_DECREASE(DELAY_WAIT_DECREASE2),
                   .DELAY_WAIT(DELAY_WAIT2),
                   .DELAY_SHOW(DELAY_SHOW2),
                   .DELAY_SHOW_MIN(DELAY_SHOW_MIN2), 
                   .DELAY_WAIT_MIN(DELAY_WAIT_MIN2),
                   .INIT_DELAY(INIT_DELAY2),
                   .HOLE_1_Y (HOLE_1_Y),
                   .HOLE_1_X (HOLE_1_X),
                                                                       
                   .MOLE_HEIGHT(MOLE_HEIGHT), 
                   .MOLE_WIDTH(MOLE_WIDTH)
                                                                     
                    )
                     my_mole_golden(
                                                                    
                          .clk(clk40),
                          .rst(rst),
                          .xpos(xpos),
                          .ypos(ypos),
                          .left(left),
                          .random_number(random_number),
                                                                   
                          .missed(),
                          .xpos_out(xpos_m3),
                          .ypos_out(ypos_m3),
                          .result(result2)
                          );
                                                                                                             
                                 
endmodule