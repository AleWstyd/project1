`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2018 15:24:00
// Design Name: 
// Module Name: draw_rect_char
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



module draw_rect_char
    # ( parameter
        X_UP_LEFT_CORNER = 0,
        Y_UP_LEFT_CORNER = 0 
    )
    (  
    input wire pclk,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] rgb_in,
    input wire [7:0] char_pixels,
    input wire rst,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,   
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out,
    output reg [7:0] char_xy,
    output reg [3:0] char_line
    );
//            localparam X_UP_LEFT_CORNER = 409;
//            localparam Y_UP_LEFT_CORNER = 0;
    localparam X_RECT_SIZE = 128;
    localparam Y_RECT_SIZE = 16;
    reg [11:0] x_up_left_corner_to_draw=0, y_up_left_corner_to_draw=0;
   // localparam X = 0, Y=0;
    
    reg [10:0] hcount_in_1, hcount_in_2, hcount_in_3;
    reg hsync_in_1, hsync_in_2, hsync_in_3;
    reg hblnk_in_1, hblnk_in_2, hblnk_in_3;
    reg [10:0] vcount_in_1, vcount_in_2, vcount_in_3;
    reg vsync_in_1, vsync_in_2, vsync_in_3;
    reg vblnk_in_1, vblnk_in_2, vblnk_in_3;
    reg [11:0] rgb_in_1, rgb_in_2, rgb_in_3;
    
    reg [11:0] rgb_out_nxt = 12'h0_a_0; //grey background
    reg [7:0] char_xy_nxt;
    reg [3:0] char_line_nxt;
    
always @(posedge pclk)
  begin
    // Just pass these through. 
    hsync_in_1 <= hsync_in;
    vsync_in_1 <= vsync_in;
    hblnk_in_1 <= hblnk_in;
    vblnk_in_1 <= vblnk_in;
    hcount_in_1 <= hcount_in;
    vcount_in_1 <= vcount_in;
    
    rgb_in_1 <= rgb_in;
  end

always @(posedge pclk)
  begin
    // Just pass these through. 
    hsync_in_2 <= hsync_in_1;
    vsync_in_2 <= vsync_in_1;
    hblnk_in_2 <= hblnk_in_1;
    vblnk_in_2 <= vblnk_in_1;
    hcount_in_2 <= hcount_in_1;
    vcount_in_2 <= vcount_in_1;
    
    rgb_in_2 <= rgb_in_1;
  end

    always @(posedge pclk)
    begin  
      if (rst)
       begin
        hsync_out <= 0;
        vsync_out <= 0;
        hblnk_out <= 0;
        vblnk_out <= 0;
        hcount_out <= 0;
        vcount_out <= 0;
        rgb_out <= 0;
        char_xy <= 0;
        char_line <= 0;
         end
      else 
          begin
              hsync_out <= hsync_in_2;
              vsync_out <= vsync_in_2;
              hblnk_out <= hblnk_in_2;
              vblnk_out <= vblnk_in_2;
              hcount_out <= hcount_in_2;
              vcount_out <= vcount_in_2;
              rgb_out <= rgb_out_nxt;
              char_xy <= char_xy_nxt;
              char_line <= char_line_nxt;
           end
    end
    
    always @*
    begin
        x_up_left_corner_to_draw = (X_UP_LEFT_CORNER%8 == 0) ? X_UP_LEFT_CORNER : X_UP_LEFT_CORNER-X_UP_LEFT_CORNER%8;                                                                  // jezeli dzieli sie przez 8 to nic nie zmieniam, a jak sie nie dzieli to zaokraglam w dol do dzielacego sie przez 8
        y_up_left_corner_to_draw = (Y_UP_LEFT_CORNER%16 == 0) ? Y_UP_LEFT_CORNER : Y_UP_LEFT_CORNER-Y_UP_LEFT_CORNER%16; 
              
        if (vcount_in_2 >= y_up_left_corner_to_draw && vcount_in_2 < y_up_left_corner_to_draw+Y_RECT_SIZE)
            if (hcount_in_2 >= x_up_left_corner_to_draw && hcount_in_2 < x_up_left_corner_to_draw+X_RECT_SIZE)                 
                if (hcount_in_2 % 8 == 7 && char_pixels[0]) rgb_out_nxt = 12'hf00;
                else if (hcount_in_2 % 8 == 6 && char_pixels[1]) rgb_out_nxt = 12'hf00;
                else if (hcount_in_2 % 8 == 5 && char_pixels[2]) rgb_out_nxt = 12'hf00; 
                else if (hcount_in_2 % 8 == 4 && char_pixels[3]) rgb_out_nxt = 12'hf00; 
                else if (hcount_in_2 % 8 == 3 && char_pixels[4]) rgb_out_nxt = 12'hf00; 
                else if (hcount_in_2 % 8 == 2 && char_pixels[5]) rgb_out_nxt = 12'hf00;
                else if (hcount_in_2 % 8 == 1 && char_pixels[6]) rgb_out_nxt = 12'hf00; 
                else if (hcount_in_2 % 8 == 0 && char_pixels[7]) rgb_out_nxt = 12'hf00;
                else rgb_out_nxt = 12'h0_a_0;   
            else
                rgb_out_nxt = rgb_in_2;
        else
            rgb_out_nxt = rgb_in_2;
                        
                                                                                                                                                                                          //X_UP_LEFT+CHAR jest przemnazane razy 2
        char_xy_nxt <= {hcount_in[6:3], vcount_in[7:4]- y_up_left_corner_to_draw[7:4] } - x_up_left_corner_to_draw*2;                                                                                                        //tu jest zwyk³e in a nie in_2      char_xy[6:3] - x_position_bits, char_xy[7:4] - y_position_bits i  tu juz jest jakby siatka 16x16 zrobiona z odpwiednimi pozyycjami poczatkow kolejnych znakow do kolejnego modulu
        char_line_nxt <= vcount_in[3:0];         
    end
    
endmodule


