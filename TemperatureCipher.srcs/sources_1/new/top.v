`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2023 03:50:55 PM
// Design Name: 
// Module Name: top
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


module top (
    input CLK100MHZ,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output DP,
    output [7:0] AN
);

  reg [31:0] data = 32'h89abcdef;
  wire en;

  assign en = 1'b1;

  led u_led (
      .clk (CLK100MHZ),
      .en  (en),
      .data(data),
      .CA  (CA),
      .CB  (CB),
      .CC  (CC),
      .CD  (CD),
      .CE  (CE),
      .CF  (CF),
      .CG  (CG),
      .DP  (DP),
      .AN  (AN)
  );
endmodule
