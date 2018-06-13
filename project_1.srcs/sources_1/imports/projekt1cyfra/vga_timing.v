// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.
 
// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).
 
`timescale 1 ns / 1 ps
 
// Declare the module and its ports. This is
// using Verilog-2001 syntax.
 
module vga_timing (
  output wire [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output wire [10:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire rst,
  input wire clk
  
  );
 
  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
 
 
  reg[10:0] hc = 0;
  reg[10:0] vc = 0;
 
 
  wire hb_nxt;
  wire hs_nxt;
  wire vb_nxt;
  wire vs_nxt;
  reg[10:0] hc_nxt;
  reg[10:0] vc_nxt;
  
  assign vcount = vc;
  assign hcount = hc;
 
  assign hb_nxt = (hc_nxt >= 800 && hc_nxt <= 1055) ? 1 : 0;
  assign hs_nxt = (hc_nxt >= 840 && hc_nxt <= 968) ? 1 : 0;
  assign vb_nxt = (vc_nxt >= 600 && vc_nxt <= 627) ? 1 : 0;
  assign vs_nxt = (vc_nxt >= 601 && vc_nxt <= 604) ? 1 : 0;
 
  always @* begin
    if(hc == 1055) hc_nxt = 0;
    else hc_nxt = hc + 1;
   
    if(vc == 627) begin
        vc_nxt = 0;
        hc_nxt = 0;
    end
    else vc_nxt = vc + (hc == 1055 ? 1 : 0);
  end
 
  always @(posedge clk) 
     begin
       if (rst)
        begin
          vc <= 1'b0;
          hc <= 1'b0;
          vsync <= 11'b0;
          vblnk <= 11'b0;
          hsync <= 1'b0;
          hblnk <= 1'b0;
         end
        else 
            begin
    vc <= vc_nxt;
    hc <= hc_nxt;
    vsync <= vs_nxt;
    vblnk <= vb_nxt;
    hsync <= hs_nxt;
    hblnk <= hb_nxt;
    end
  end
 

  

 
 
endmodule