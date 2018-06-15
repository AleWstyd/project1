`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2018 12:25:54 PM
// Design Name: 
// Module Name: draw_moles
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


module draw_moles
    # ( parameter

         MOLE_HEIGHT = 60,
         MOLE_WIDTH = 30,
         MOLE_COLOUR = 12'h6_2_0,
         
         X_WIDTH = 6,
         Y_WIDTH = 6 
    )
    (
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire clk,
    input wire rst,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel,
    
    input wire [11:0] xpos,
    input wire [11:0] ypos,

    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,  
    output reg [X_WIDTH+Y_WIDTH-1:0] pixel_addr,
    output reg [11:0] rgb_out

    );

reg [11:0] rgb_nxt;

reg [X_WIDTH-1:0]   addr_X;
reg [Y_WIDTH-1:0]   addr_Y;


always @(posedge clk) begin
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
              addr_X = hcount_in - xpos;
              addr_Y = vcount_in - ypos;
               if (hcount_in > xpos && hcount_in < xpos + MOLE_WIDTH && vcount_in > ypos - MOLE_HEIGHT && vcount_in < ypos ) rgb_nxt <= rgb_pixel;
               else   rgb_nxt <= rgb_in; 
                                 
 
             end
 endmodule
