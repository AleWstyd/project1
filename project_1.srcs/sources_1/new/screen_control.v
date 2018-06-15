`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2018 01:01:16 PM
// Design Name: 
// Module Name: screen_control
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


module screen_control(
    input wire clk40,
    input wire rst,
    input wire start,
    input wire restart,
    input wire end_game,
    
    input wire [10:0] vcount_in_start,
    input wire [10:0] hcount_in_start,
    input wire vsync_in_start, 
    input wire hsync_in_start,
    input wire vblnk_in_start, 
    input wire hblnk_in_start,
    input wire [11:0] rgb_in_start,
    
    input wire [10:0] vcount_in_game,
    input wire [10:0] hcount_in_game,
    input wire vsync_in_game, 
    input wire hsync_in_game,
    input wire vblnk_in_game, 
    input wire hblnk_in_game,
    input wire [11:0] rgb_in_game,
        
    input wire [10:0] vcount_in_end,
    input wire [10:0] hcount_in_end,
    input wire vsync_in_end, 
    input wire hsync_in_end,
    input wire vblnk_in_end, 
    input wire hblnk_in_end,
    input wire [11:0] rgb_in_end,
  
  
    output reg [11:0] hcount_out,
    output reg [11:0] vcount_out,
    output reg hblnk_out,
    output reg vblnk_out,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out,
    
    output reg game_enable
    );
    
localparam    START = 2'b00,
              GAME = 2'b01,
              END = 2'b10;



reg game_enable_nxt = 0;
    
reg [1:0] state;
reg [1:0] state_nxt;

reg [11:0] hcount_out_nxt, vcount_out_nxt;
reg hblnk_out_nxt,vblnk_out_nxt;
reg hsync_out_nxt,vsync_out_nxt;
reg [11:0] rgb_out_nxt;

always @(posedge clk40) begin
    if(rst) 
        begin
   hcount_out <= 11'b0;
   vcount_out <= 11'b0;     
   hblnk_out <= 1'b0;
   vblnk_out <= 1'b0;   
   hsync_out <= 1'b0;
   vsync_out <= 1'b0;
   rgb_out <=  12'b0;
   state <= START;
   game_enable <= 0;
         end 

    else

    begin
       hcount_out <= hcount_out_nxt;
       vcount_out <= vcount_out_nxt;     
       hblnk_out <= hblnk_out_nxt;
       vblnk_out <= vblnk_out_nxt;   
       hsync_out <= hsync_out_nxt;
       vsync_out <= vsync_out_nxt;
       rgb_out <=  rgb_out_nxt;
       state <= state_nxt;
       game_enable <= game_enable_nxt;
     end   
 end        
 
 
 
always @* begin 
    case(state)
        START:       state_nxt = (start == 1)       ? GAME : START;
        GAME:        state_nxt = (end_game == 1)    ? END : GAME;
        END:         state_nxt = (restart == 1)     ? START : END;
        default:     state_nxt =                    START;
    endcase
end

always @* begin
    case(state_nxt)
        START:
            begin
                hcount_out_nxt <= hcount_in_start;
                vcount_out_nxt <= vcount_in_start;     
                hblnk_out_nxt <= hblnk_in_start ;
                vblnk_out_nxt <= vblnk_in_start ;   
                hsync_out_nxt <= hsync_in_start ;
                vsync_out_nxt <= vsync_in_start ;
                rgb_out_nxt <=  rgb_in_start;
                game_enable_nxt <= 1;
            end
        GAME:
            begin
                hcount_out_nxt <= hcount_in_game;
                vcount_out_nxt <= vcount_in_game;     
                hblnk_out_nxt <= hblnk_in_game  ;
                vblnk_out_nxt <= vblnk_in_game ;   
                hsync_out_nxt <= hsync_in_game ;
                vsync_out_nxt <= vsync_in_game ;
                rgb_out_nxt <=  rgb_in_game;
                game_enable_nxt <= 0;
            end
        END:
            begin
                hcount_out_nxt <= hcount_in_end;
                vcount_out_nxt <= vcount_in_end;     
                hblnk_out_nxt <= hblnk_in_end ;
                vblnk_out_nxt <= vblnk_in_end ;   
                hsync_out_nxt <= hsync_in_end ;
                vsync_out_nxt <= vsync_in_end ;
                rgb_out_nxt <=  rgb_in_end;
                game_enable_nxt <= 1;
            end
        default:
            begin
                hcount_out_nxt <= hcount_in_start;
                vcount_out_nxt <= vcount_in_start;     
                hblnk_out_nxt <= hblnk_in_start ;
                vblnk_out_nxt <= vblnk_in_start ;   
                hsync_out_nxt <= hsync_in_start ;
                vsync_out_nxt <= vsync_in_start ;
                rgb_out_nxt <=  rgb_in_start;
                game_enable_nxt <= 1;
             end 
             
    endcase
end


 

    
    
endmodule