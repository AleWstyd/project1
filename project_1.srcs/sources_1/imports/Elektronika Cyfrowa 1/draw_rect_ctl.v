`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2017 19:27:45
// Design Name: 
// Module Name: draw_rect_ctl
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


module draw_rect_ctl(
    input wire          mouse_left,
    input wire          clk_in,
    input wire  [11:0]  mouse_xpos,
    input wire  [11:0]  mouse_ypos,
    output reg  [11:0]  xpos,
    output reg  [11:0]  ypos
    );
    
reg    bottom, top, stop;
reg [11:0]  xpos_nxt, ypos_nxt;
reg [20:0]  delay=0, delay_nxt=0; 
reg [11:0]  dt=0, dt_nxt=0;
    
reg [2:0]   state = 2'b00, 
            state_nxt = 2'b00;  
                
localparam  IDLE = 2'b00,
            FALL = 2'b01,
            RISE = 2'b10,
            DOWN = 2'b11;
    
    localparam  height   = 64; 
    localparam  delay_value    = 1000000;
    
    always @( posedge clk_in ) begin
        xpos <= xpos_nxt;
        ypos <= ypos_nxt;
        state <= state_nxt;
        delay <= delay_nxt;
        dt <= dt_nxt;
    end
    
    always @* begin
        state_nxt = IDLE;
        case (state)
            IDLE:   state_nxt = ( mouse_left == 1 )     ?   FALL : IDLE;
            FALL:   state_nxt = ( bottom == 1 )      ?   DOWN : FALL;
            RISE:   state_nxt = ( top == 1 )         ?   FALL : RISE;
            DOWN:   state_nxt = ( stop == 1 )           ?   DOWN : RISE;  
        endcase
    end
    
    always @* begin
        dt_nxt  = dt;
        delay_nxt = delay;
        xpos_nxt = xpos;
        ypos_nxt = ypos;
        bottom = 0;
        top = 0; 
        stop = 0;
        
        case (state)
        
            IDLE:       begin
                            xpos_nxt = mouse_xpos;
                            ypos_nxt = mouse_ypos;
                        end                
            FALL:       begin  
                            delay_nxt = delay + 1;     
                            if (delay == delay_value) begin
                                ypos_nxt = ypos + dt;
                                dt_nxt = dt + 1;
                                delay_nxt = 0;
                            end
                            if( ypos >= 598 - height ) begin
                                ypos_nxt = 598 - height;
                                bottom = 1;
                            end
                        end    
                       
            DOWN:    begin
                        ypos_nxt = 598 - height;
              
                        if ( dt <= 10 ) 
                             stop = 1;
                        else
                           
                             dt_nxt = 4* dt/5;
                            
                             
                     end
            
            RISE:    begin  
                        delay_nxt = delay + 1;     
                        if (delay == delay_value) begin
                               ypos_nxt = ypos - dt;
                               dt_nxt = dt - 1;
                               delay_nxt = 0;
                               end
                        if( dt <= 0 ) begin
                                delay_nxt = 0;
                                dt_nxt = 0;
                                top = 1;
                        end  
                     end
        endcase
    end
    
endmodule

