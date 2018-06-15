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
//////////       timing module           ///////////////
////////////////////////////////////////////////////////
 
   wire [10:0] vcount, hcount;
   wire vsync, hsync;
   wire vblnk, hblnk;
 
   vga_timing my_timing (
     .clk(clk40),
     .rst(rst),
     
     .vcount(vcount),
     .vsync(vsync),
     .vblnk(vblnk),
     .hcount(hcount),
     .hsync(hsync),
     .hblnk(hblnk)
     
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
wire [10:0] vcount_out_game, hcount_out_game, vcount_out_end, hcount_out_end, vcount_out_start, hcount_out_start,vcount_out, hcount_out;
wire vsync_out_game, hsync_out_game, vsync_out_end, hsync_out_end, vsync_out_start, hsync_out_start,vsync_out, hsync_out;
wire vblnk_out_game, hblnk_out_game, vblnk_out_end, hblnk_out_end, vblnk_out_start, hblnk_out_start,vblnk_out, hblnk_out;
wire [11:0] rgb_out_game, rgb_out_end, rgb_out_start,rgb_out;
wire start, restart, end_game;
wire game_enable;
  
  
game_module my_game ( 
    .clk40(clk40),  
	.rst(game_enable),  
	.xpos(xpos),
    .ypos(ypos),
    .left(left), 
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),

    .end_game(end_game),
    .hcount_out(hcount_out_game),
    .hblnk_out(hblnk_out_game),
    .vcount_out(vcount_out_game),
    .vblnk_out(vblnk_out_game),
    .rgb_out(rgb_out_game),
    .vs(vsync_out_game),
    .hs(hsync_out_game)
 );

////////////////////////////////////////////////////////
//////////       end   module           ///////////////
////////////////////////////////////////////////////////

draw_end my_end ( 
    .clk40(clk40),  
	.rst(rst),  
	.xpos(xpos),
    .ypos(ypos),
    .left(left), 
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),

    .restart(restart),
    .hcount_out(hcount_out_end),
    .hblnk_out(hblnk_out_end),
    .vcount_out(vcount_out_end),
    .vblnk_out(vblnk_out_end),
    .rgb_out(rgb_out_end),
    .vs(vsync_out_end),
    .hs(hsync_out_end)
 );
 
 
 ////////////////////////////////////////////////////////
 //////////       menu   module           ///////////////
 ////////////////////////////////////////////////////////
 
 draw_menu my_menu ( 
     .clk40(clk40),  
     .rst(rst),  
     .xpos(xpos),
     .ypos(ypos),
     .left(left), 
     .vcount(vcount),
     .vsync(vsync),
     .vblnk(vblnk),
     .hcount(hcount),
     .hsync(hsync),
     .hblnk(hblnk),
 
     .start(start),
     .hcount_out(hcount_out_start),
     .hblnk_out(hblnk_out_start),
     .vcount_out(vcount_out_start),
     .vblnk_out(vblnk_out_start),
     .rgb_out(rgb_out_start),
     .vs(vsync_out_start),
     .hs(hsync_out_start)
  );
  
 ////////////////////////////////////////////////////////
 //////////       screen  control          ///////////////
 ////////////////////////////////////////////////////////
   
 screen_control my_screen_ctl( 
     .clk40(clk40),
     .rst(rst),
     .start(start),
     .restart(restart),
     .end_game(end_game),
     
     .vcount_in_start(vcount_out_start),
     .hcount_in_start(hcount_out_start),
     .vsync_in_start(vsync_out_start), 
     .hsync_in_start(hsync_out_start),
     .vblnk_in_start(vblnk_out_start), 
     .hblnk_in_start(hblnk_out_start),
     .rgb_in_start(rgb_out_start),
     
     .vcount_in_game(vcount_out_game),
     .hcount_in_game(hcount_out_game),
     .vsync_in_game(vsync_out_game), 
     .hsync_in_game(hsync_out_game),
     .vblnk_in_game(vblnk_out_game), 
     .hblnk_in_game(hblnk_out_game),
     .rgb_in_game(rgb_out_game),
         
     .vcount_in_end(vcount_out_end),
     .hcount_in_end(hcount_out_end),
     .vsync_in_end(vsync_out_end), 
     .hsync_in_end(hsync_out_end),
     .vblnk_in_end(vblnk_out_end), 
     .hblnk_in_end(hblnk_out_end),
     .rgb_in_end(rgb_out_end),
   
   
     .hcount_out(hcount_out),
     .vcount_out(vcount_out),
     .hblnk_out(hblnk_out),
     .vblnk_out(vblnk_out),
     .hsync_out(hs),
     .vsync_out(vs),
     .rgb_out(rgb_out),
     
     .game_enable(game_enable)
 
 
 
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
          .red_in(rgb_out [11:8]),
          .green_in(rgb_out[7:4]),
          .blue_in(rgb_out[3:0]),
          .blank(hblnk_out || vblnk_out),
          .hcount({1'b0,hcount_out+1}),
          .vcount({1'b0,vcount_out}),
          
          
          .red_out(r),
          .green_out(g),
          .blue_out(b)
      );
      
      
      
endmodule
