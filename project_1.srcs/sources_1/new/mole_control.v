`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2018 01:13:49 PM
// Design Name: 
// Module Name: mole_control
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


module mole_control(
    input wire clk,
    output reg [9:0] random_number
    );
    
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------    
    localparam
    OBJECT_WIDTH = 100;

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------  
    reg [9:0] random_number_nxt, random_number_previous;

//------------------------------------------------------------------------------
// output register - without rst, so random number is even more random :)
//------------------------------------------------------------------------------    
    always @(posedge clk) begin
        random_number <= random_number_nxt;
        random_number_previous <= random_number;
    end
       
    always @* begin   
        if(random_number + random_number_previous > 600 - OBJECT_WIDTH)
            random_number_nxt = random_number + random_number_previous - (600 - OBJECT_WIDTH);
        else
            random_number_nxt = random_number + random_number_previous;
        if(random_number_nxt == 0) // to avoid stable position
            random_number_nxt = 1;
    end
    
endmodule
