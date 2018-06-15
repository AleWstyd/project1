`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2018 03:40:35 PM
// Design Name: 
// Module Name: main_mole
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


module main_mole
        # ( parameter
         HOLE_SIZE = 40,
         HOLE_1_Y = 135,
         HOLE_1_X = 185,
        
         HOLE_2_Y = 285,
         HOLE_2_X = 385,
        
         HOLE_3_Y = 435,
         HOLE_3_X = 585,
        
         MOLE_HEIGHT = 60,
         MOLE_WIDTH = 30
    )
    (
    input wire rst,
    input wire clk,
    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire left,
    input wire [9:0] random_number,
    
    output reg end_game,
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out,
    output reg [9:0] result
    );

reg end_game_nxt = 0;
reg [9:0] result_nxt = 0;  
reg     next, delayed;
reg  [11:0]   xpos_nxt,ypos_nxt;
reg [9:0] random,random_nxt;
reg [30:0]  delay=0, delay_nxt=0; 
reg [30:0] delay_wait, delay_wait_nxt;
reg [30:0] delay_show, delay_show_nxt;
    
reg [2:0]   state = 1'b0, 
            state_nxt = 1'b0;  
            
localparam MOLE1_X = HOLE_1_X + ((HOLE_SIZE - MOLE_WIDTH)/2),
           MOLE1_Y = HOLE_1_Y  + 25;
           
                
localparam   SHOW = 1'b1,
             WAIT = 1'b0;
  
    

    
        localparam  DELAY_1_MS    = 40_000;
        
        localparam DELAY_SHOW = 30 * DELAY_1_MS;
        
        localparam DELAY_WAIT = 20 * DELAY_1_MS;
        
        localparam DELAY_SHOW_MIN = 800 * DELAY_1_MS;
        
        localparam DELAY_WAIT_MIN = 500 * DELAY_1_MS;
        
        
   initial 
            begin
              delay_wait = 1000 * DELAY_1_MS;
              delay_wait_nxt = 1000 * DELAY_1_MS;
              delay_show = 2000 * DELAY_1_MS;
              delay_show_nxt = 1500 * DELAY_1_MS;
            end     
         
    always @(posedge clk) begin
           if(rst) 
              begin 
                 state <= 2'b00; 
                 delay <= 0;
                 random <=0;
                 xpos_out <= 900;
                 ypos_out <= 800;
                 delay_show <= 0;
                 delay_wait <= 0;
                 result <= 0;
                 end_game <= 0;
                 
              end
            else
              begin
                delay <= delay_nxt;
                state <= state_nxt;
                random <=random_nxt;
                xpos_out <= xpos_nxt;
                ypos_out <= ypos_nxt;
                delay_show <= delay_show_nxt;
                delay_wait <= delay_wait_nxt;
                result <= result_nxt;
                end_game <= end_game_nxt;
                                 
             end
            end
    
    always @* begin
    
        case (state)
            SHOW:            state_nxt = ( next == 1 )  ?   WAIT: SHOW;
            WAIT:            state_nxt = ( delayed == 1  )  ?   SHOW: WAIT;  
        endcase
    end
    
    always @* begin
        delay_nxt = delay;
        delayed = 0;
        next = 0;
        xpos_nxt = xpos_out;
        ypos_nxt =ypos_out;
        random_nxt = random;
        
        case (state)
        
            SHOW:  begin
                    delay_nxt = delay + 1; 
                    xpos_nxt = MOLE1_X + (200 * ((random-random%3)/3));
                    ypos_nxt = MOLE1_Y + (150 * (random%3));
                    if(delay>=delay_show)begin
                        delay_nxt=0;
                        end_game_nxt =0;
                        
                    end 
                    else if (left == 1 && (xpos > xpos_out) && (xpos < (xpos_out + MOLE_WIDTH)) && (ypos < ypos_out) &&  (ypos > (ypos_out - MOLE_HEIGHT))) begin
                        delay_nxt = 0;
                        next = 1;
                        result_nxt = (result +1);
                        if (delay_show >= DELAY_SHOW_MIN) delay_show_nxt <= delay_show - DELAY_SHOW;
                        end
                     end    
                                    
             WAIT: begin
             delay_nxt = delay + 1; 
             xpos_nxt = 900;
             ypos_nxt= 800;
             random_nxt = random_number%9;
                if(delay>=delay_wait)begin
                delay_nxt=0;
                delayed=1;
                if (delay_wait >= DELAY_WAIT_MIN)delay_wait_nxt <= delay_wait -DELAY_WAIT;
                end 
                    end
            
        endcase
    end
    
endmodule
