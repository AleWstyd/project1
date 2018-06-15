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


clk_wiz_0   clk_main 
 (
  // Clock out ports
  .clk100MHz(clk100),
  .clk40Mhz(clk40),
  // Status and control signals
  //.reset(rst),
  //.locked(locked),
 // Clock in ports
  .clk(clk)
 );
 

////////////////////////////////////////////////////////
//////////       mouse module           ///////////////
////////////////////////////////////////////////////////

wire left;
wire [11:0] xpos, ypos;

mouse_module my_mouse(
    .clk100(clk100),
    .clk40(clk40),
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
wire [10:0] vcount_out_g, hcount_out_g, vcount_out_c, hcount_out_c, vcount_out_d, hcount_out_d;
  wire vsync_out_g, hsync_out_g, vsync_out_c, hsync_out_c, vsync_out_d, hsync_out_d;
  wire vblnk_out_g, hblnk_out_g, vblnk_out_c, hblnk_out_c, vblnk_out_d, hblnk_out_d;
  wire [11:0] rgb_out_g, rgb_out_c, rgb_out_d;
  
  
game_module my_game ( 
    .clk40(clk40),  
	.rst(rst),  
	.xpos(xpos),
    .ypos(ypos),
    .left(left), 

    .hcount_out(hcount_out_g),
    .hblnk_out(hblnk_out_g),
    .vcount_out(vcount_out_g),
    .vblnk_out(vblnk_out_g),
    .rgb_out(rgb_out_g),
    .vs(vs),
    .hs(hs)
 );

////////////////////////////////////////////////////////
      //////////       mouse display           ///////////////
      ////////////////////////////////////////////////////////
      
      wire [11:0] xpos_buff,ypos_buff;
      wire [0:3] green_out_m, red_out_m, blue_out_m; 
      
      MouseDisplay mouse_display(
      
          .xpos(xpos),
          .ypos(ypos),
          .pixel_clk(clk40),
          .red_in(rgb_out_g[11:8]),
          .green_in(rgb_out_g[7:4]),
          .blue_in(rgb_out_g[3:0]),
          .blank(hblnk_out_g || vblnk_out_g),
          .hcount({1'b0,hcount_out_g+1}),
          .vcount({1'b0,vcount_out_g}),
          
          
          .red_out(r),
          .green_out(g),
          .blue_out(b)
      );
      
      
      
endmodule
