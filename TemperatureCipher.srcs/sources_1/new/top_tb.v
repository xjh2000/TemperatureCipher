`timescale 1ns / 1ps
module top_tb;

  reg clk;
  reg UART_TXD_IN;

  wire UART_RXD_OUT;
  wire CA;
  wire CB;
  wire CC;
  wire CD;
  wire CE;
  wire CF;
  wire CG;
  wire DP;
  wire [7:0] AN;

  // simulation init
  initial begin
    clk = 0;
    forever clk = #(0.5) ~clk;
  end

  top #(
      .CLK_FREQUENCY(2000)
  ) top_instan (
      .CLK100MHZ(clk),
      .UART_TXD_IN(UART_TXD_IN),
      .UART_RXD_OUT(UART_RXD_OUT),
      .CA(CA),
      .CB(CB),
      .CC(CC),
      .CD(CD),
      .CE(CE),
      .CF(CF),
      .CG(CG),
      .DP(DP),
      .AN(AN)
  );

endmodule  //top_tb
