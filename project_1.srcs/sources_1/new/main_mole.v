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
        
         MOLE_HEIGHT = 64,
         MOLE_WIDTH = 32
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
reg  next, delayed,start;
reg [11:0]   xpos_nxt,ypos_nxt;
reg [9:0] random,random_nxt;
reg [30:0]  delay=0, delay_nxt=0; 
reg [30:0] delay_wait, delay_wait_nxt;
reg [30:0] delay_show, delay_show_nxt;
    
reg [2:0]   state = 2'b00, 
            state_nxt = 2'b00;  
            
localparam MOLE1_X = 180,
           MOLE1_Y = HOLE_1_Y  - 44;
           
                
localparam   INIT = 2'b00,
             SHOW = 2'b01,
             WAIT = 2'b10;
  
    

    
        localparam  DELAY_1_MS    = 40_000;
        
        localparam DELAY_SHOW = 30 * DELAY_1_MS;
        
        localparam DELAY_WAIT = 20 * DELAY_1_MS;
        
        localparam DELAY_SHOW_MIN = 800 * DELAY_1_MS;
        
        localparam DELAY_WAIT_MIN = 500 * DELAY_1_MS;
        
        localparam INIT_DELAY = 1500 * DELAY_1_MS;
        
         
    always @(posedge clk) begin
           if(rst) 
              begin 
                 state <= INIT; 
                 delay <= 31'b0;
                 random <=10'b0;
                 xpos_out <= 900;
                 ypos_out <= 800;
                 delay_show <= 2000 * DELAY_1_MS;
                 delay_wait <= 1000 * DELAY_1_MS;
                 result <= 10'b0;
                 end_game <= 1'b0;
                 
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
            INIT:            state_nxt = ( start == 1 )     ?   WAIT: INIT;
            SHOW:            state_nxt = ( next == 1 )      ?   WAIT: SHOW;
            WAIT:            state_nxt = ( delayed == 1  )  ?   SHOW: WAIT;
            default:         state_nxt =                        INIT;  
        endcase
    end
    
    always @* begin
        delay_nxt = delay;
        delayed = 0;
        next = 0;
        start = 0;
        xpos_nxt = xpos_out;
        ypos_nxt =ypos_out;
        random_nxt = random;
        result_nxt=result;
        case (state)
            INIT:
                 begin
                        result_nxt = 0;
                        xpos_nxt = 900;
                        ypos_nxt= 800;
                        end_game_nxt =0;
                        delay_nxt = delay + 1; 
                        delay_wait_nxt = 1000 * DELAY_1_MS;
                        delay_show_nxt = 2000 * DELAY_1_MS;
                        if(delay>=INIT_DELAY)
                               begin
                                  delay_nxt=0;
                                  start =1;
                               end
                 end
            SHOW:  
                 begin
                    delay_nxt = delay + 1; 
                    xpos_nxt = MOLE1_X + (206 * ((random-random%3)/3));
                    ypos_nxt = MOLE1_Y + (152 * (random%3));
                    if(delay>=delay_show)
                      begin
                        delay_nxt=0;
                        end_game_nxt =1;
                      end 
                    else if (left == 1 && (xpos > xpos_out) && (xpos < (xpos_out + MOLE_WIDTH)) && (ypos < ypos_out +MOLE_HEIGHT) &&  (ypos > ypos_out) ) begin
                        delay_nxt = 0;
                        next = 1;
                        result_nxt = (result +1);
                        if (delay_show >= DELAY_SHOW_MIN) delay_show_nxt <= delay_show - DELAY_SHOW;
                        end
                     end    
                                    
             WAIT: 
                begin
                    delay_nxt = delay + 1; 
                    xpos_nxt = 900;
                    ypos_nxt= 800;
                    random_nxt = random_number%9;
                        if(delay>=delay_wait)
                          begin
                            delay_nxt=0;
                            delayed=1;
                            if (delay_wait >= DELAY_WAIT_MIN)delay_wait_nxt <= delay_wait -DELAY_WAIT;
                          end 
                end
             default:
                begin
                    xpos_nxt = 900;
                    ypos_nxt= 800;
                end
        endcase
    end
    
endmodule
