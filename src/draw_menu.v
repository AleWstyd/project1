`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2018 12:47:37 PM
// Design Name: 
// Module Name: draw_menu
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


module draw_menu(
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

    output wire start,
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
    wire [20:0] address_m1;
    wire [7:0] temp_x;
    wire [6:0] temp_y;
   
       
        assign temp_x = (address [8:0] - address [8:0] % 2)/2;
        assign temp_y = (address [16:9] - address [16:9] % 2)/2;
        assign address_m1 = {temp_y,temp_x};
        
////////////////////////////////////////////////////////
/////////      backrgound image rom      ///////////////
////////////////////////////////////////////////////////
                  
                              
              image_rom # (
                      .FILE_PATH("C:/Users/Mikolaj/Desktop/obrazki/menu.data"),
                      .X_WIDTH(8),
                      .Y_WIDTH(7)
                    )
                   start_rom(     
                 .clk(clk40),
                 .address(address_m1),
                 .rgb(rgb_pixel)
                 );
          
  ////////////////////////////////////////////////////////
  //////////     draw background image     ///////////////
  ////////////////////////////////////////////////////////
                       
                       
                          
           draw_moles  # (
                     .X_WIDTH(9),
                     .Y_WIDTH(8)
                    )
                 my_menu_screen(
                .clk(clk40),
                .hcount_in(hcount),
                .hsync_in(hsync),
                .hblnk_in(hblnk),
                .vcount_in(vcount),
                .vsync_in(vsync),
                .vblnk_in(vblnk),
                .rgb_in(12'h0a0),
                .rst(rst),
                .rgb_pixel(rgb_pixel),
                .xpos('d160),
                .ypos('d172),
                
                .pixel_addr(address),
                .hcount_out(hcount_out),
                .hsync_out(hs),
                .hblnk_out(hblnk_out),
                .vcount_out(vcount_out),
                .vsync_out(vs),
                .vblnk_out(vblnk_out),
                .rgb_out(rgb_out)
            
                );  
        
 ////////////////////////////////////////////////////////
 /////////           click check          ///////////////
 ////////////////////////////////////////////////////////  
      
      click_check #
                (.X_UP_BOX (306),
                 .Y_UP_BOX(350),
                 .BOX_WIDTH (150),
                 .BOX_HEIGHT (58)
                  )
              my_start_click (
              .left(left),
              .clk(clk40),
              .rst(rst),
              .xpos(xpos),
              .ypos(ypos),
              
              .clicked(start)
              );   
    
    
    
endmodule
