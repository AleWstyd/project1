`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2018 08:57:47
// Design Name: 
// Module Name: draw_background
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


module draw_background
  # ( parameter
         HOLE_SIZE = 0,
         HOLE_1_Y = 135,
         HOLE_1_X = 185,
        
         HOLE_2_Y = 285,
         HOLE_2_X = 385,
        
         HOLE_3_Y = 435,
         HOLE_3_X = 585
      )
      (
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire pclk,
    input wire rst,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,  
    output reg [11:0] rgb_out
    );
    

reg [11:0] rgb_nxt;


always @(posedge pclk) begin
       if(rst) 
          begin 
             hcount_out <= 11'b0;
             hsync_out <= 1'b0;
             hblnk_out <=  1'b0; 
             vcount_out <=  11'b0;
             vsync_out <= 1'b0;
             vblnk_out <= 1'b0;
             rgb_out <=  11'b0;
          end
        else
          begin
            hcount_out <= hcount_in;
            hsync_out <= hsync_in;
            hblnk_out <=  hblnk_in; 
            vcount_out <=  vcount_in;
            vsync_out <= vsync_in;
            vblnk_out <= vblnk_in;
            rgb_out <=  rgb_nxt;
         end
        end
    
always @*
      begin
        // During blanking, make it it black.
        if (vblnk_in || hblnk_in) rgb_nxt <= 12'h0_0_0; 
        else
         begin
                 // Active display, top edge, make a yellow line.
                 if (vcount_in == 0) rgb_nxt <= 12'hf_f_0;
                 // Active display, bottom edge, make a red line.
                 else if (vcount_in == 599) rgb_nxt <= 12'hf_0_0;
                 // Active display, left edge, make a green line.
                 else if (hcount_in == 0) rgb_nxt <= 12'h0_f_0;
                 // Active display, right edge, make a blue line.
                 else if (hcount_in == 799) rgb_nxt <= 12'h0_0_f;
                 // Active display, interior, fill with gray.
                 
                 else if (hcount_in > HOLE_1_X && hcount_in < HOLE_1_X + HOLE_SIZE && vcount_in > HOLE_1_Y && vcount_in < HOLE_1_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 else if (hcount_in > HOLE_2_X && hcount_in < HOLE_2_X + HOLE_SIZE && vcount_in > HOLE_1_Y && vcount_in < HOLE_1_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 else if (hcount_in > HOLE_3_X && hcount_in < HOLE_3_X + HOLE_SIZE && vcount_in > HOLE_1_Y && vcount_in < HOLE_1_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 
                 else if (hcount_in > HOLE_1_X && hcount_in < HOLE_1_X + HOLE_SIZE && vcount_in > HOLE_2_Y && vcount_in < HOLE_2_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 else if (hcount_in > HOLE_2_X && hcount_in < HOLE_2_X + HOLE_SIZE && vcount_in > HOLE_2_Y && vcount_in < HOLE_2_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 else if (hcount_in > HOLE_3_X && hcount_in < HOLE_3_X + HOLE_SIZE && vcount_in > HOLE_2_Y && vcount_in < HOLE_2_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 
                 else if (hcount_in > HOLE_1_X && hcount_in < HOLE_1_X + HOLE_SIZE && vcount_in > HOLE_3_Y && vcount_in < HOLE_3_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 else if (hcount_in > HOLE_2_X && hcount_in < HOLE_2_X + HOLE_SIZE && vcount_in > HOLE_3_Y && vcount_in < HOLE_3_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 else if (hcount_in > HOLE_3_X && hcount_in < HOLE_3_X + HOLE_SIZE && vcount_in > HOLE_3_Y && vcount_in < HOLE_3_Y + HOLE_SIZE) rgb_nxt <= 12'h8_4_0;
                 
                 
                 else rgb_nxt <= 12'h0_a_0;    
               end
             end
       endmodule