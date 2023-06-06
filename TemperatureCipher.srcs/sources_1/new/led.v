`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2023 04:01:17 PM
// Design Name: 
// Module Name: led
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

module led (
    input clk,
    input [31:0] data,
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
  parameter CLK_FREQUENCY = 100_000_000;
  localparam MAX_COUNTER = CLK_FREQUENCY / 1000;  // 1ms needs number of counter  

  reg [31:0] counter;  // counter for 1ms

  // use counter to creat 1ms delay signl
  always @(posedge clk) begin
    if (counter < MAX_COUNTER - 1) begin
      counter <= counter + 1'b1;
    end else begin
      counter <= 32'b0;
    end
  end

    
endmodule
