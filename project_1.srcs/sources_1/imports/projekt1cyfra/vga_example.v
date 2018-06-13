// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,
  
  output wire  vs,
  output wire  hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  
  inout wire ps2_clk,
  inout wire ps2_data
  
  );



///////////////////////////////////////////////////////////////
////////////       main clock module           ///////////////
/////////////////////////////////////////////////////////////

wire clk100;
wire clk40;
wire locked;


clk_wiz_0   clk_main 
 (
  // Clock out ports
  .clk100MHz(clk100),
  .clk40Mhz(clk40),
  // Status and control signals
  .reset(rst),
  .locked(locked),
 // Clock in ports
  .clk(clk)
 );
 

////////////////////////////////////////////////////////
//////////       mouse module           ///////////////
////////////////////////////////////////////////////////

wire left;
wire [11:0] xpos, ypos;

MouseCtl mouse_module (
    .clk(clk100),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .rst(rst),
    .xpos(xpos),
    .ypos(ypos),
    .left(left)
    
);

////////////////////////////////////////////////////////
//////////       vga   module           ///////////////
////////////////////////////////////////////////////////

vga_module my_vga ( 
    .clk40(clk40),  
	.rst(rst),  
	.xpos(xpos),
    .ypos(ypos),
    .left(left), 

    .r(r),
    .g(g),
    .b(b),
    .vs(vs),
    .hs(hs)
 );

endmodule
