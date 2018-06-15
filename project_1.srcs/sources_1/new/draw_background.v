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
    BACKGROUND_COLOR = 12'h0_8_f
    )(
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    
    input wire clk,
    input wire rst,
    
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    
    output reg [11:0] rgb_out
    );
    
 reg [11:0] rgb_out_nxt;
 

	always @(posedge clk) begin 
		if(rst) begin 
			hsync_out <= 1'b0;
            vsync_out <= 1'b0;
            hblnk_out <= 1'b0;
            vblnk_out <= 1'b0;
            vcount_out <= 11'b0;
            hcount_out <= 11'b0;
            rgb_out <= 12'b0;
		end
		else begin
			hsync_out <= hsync_in;
            vsync_out <= vsync_in;
            hblnk_out <= hblnk_in;
            vblnk_out <= vblnk_in;
            vcount_out <= vcount_in;
            hcount_out <= hcount_in;
            rgb_out <= rgb_out_nxt;
		end
	end
     
always @*
    begin     
     if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0; 
     else 
      rgb_out_nxt = BACKGROUND_COLOR;    
    end
 
 endmodule