`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2018 11:58:14
// Design Name: 
// Module Name: draw_rect
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


module draw_rect(
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    
    input wire [11:0] rgb_in,
    input wire pclk,    
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire [11:0] rgb_pixel,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    
    output reg [11:0] rgb_out,
    output reg [11:0] pixel_addr

    );


reg [10:0]  hcount_nxt1=0, vcount_nxt1=0,hcount_nxt2=0, vcount_nxt2=0;
reg         hsync_nxt1=0, hblnk_nxt1=0, vsync_nxt1=0, vblnk_nxt1=0, 
            hsync_nxt2=0, hblnk_nxt2=0, vsync_nxt2=0, vblnk_nxt2=0;
            
reg [11:0]  rgb_out_nxt = 0, rgb_in_nxt1 = 0, rgb_in_nxt = 0;
reg [5:0]   addr_X, addr_Y;
                
localparam  WIDTH = 48;
localparam  HEIGHT = 64;
		

 always @(posedge pclk) 
    begin
        hcount_nxt1  <= hcount_in;
        vcount_nxt1  <= vcount_in;      
        hsync_nxt1   <= hsync_in;
        vsync_nxt1   <= vsync_in;
        hblnk_nxt1   <= hblnk_in;
        vblnk_nxt1   <= vblnk_in;
        
        hcount_nxt2  <= hcount_nxt1;
        vcount_nxt2  <= vcount_nxt1;      
        hsync_nxt2   <= hsync_nxt1;        // delay by 2 clock cycles 
        vsync_nxt2   <= vsync_nxt1;
        hblnk_nxt2   <= hblnk_nxt1;
        vblnk_nxt2   <= vblnk_nxt1;
        
        hcount_out  <= hcount_nxt2;
        vcount_out  <= vcount_nxt2;      
        hsync_out   <= hsync_nxt2;
        vsync_out   <= vsync_nxt2;
        hblnk_out   <= hblnk_nxt2;
        vblnk_out   <= vblnk_nxt2;
        
        rgb_out     <= rgb_out_nxt;
    
        rgb_in_nxt1 <= rgb_in_nxt;
        rgb_in_nxt  <= rgb_in;
        pixel_addr  <= {addr_Y,addr_X};
    end
    
    
  always @* 
    begin
        addr_X = hcount_in - xpos;
        addr_Y = vcount_in - ypos;
        rgb_out_nxt = rgb_in_nxt1;
        
        if( hcount_nxt2 >= xpos && hcount_nxt2 < xpos + WIDTH && vcount_nxt2 >= ypos && vcount_nxt2 < ypos + HEIGHT && !(vblnk_nxt2 || hblnk_nxt2) ) 
            rgb_out_nxt = rgb_pixel;
        
    end   
     
endmodule

