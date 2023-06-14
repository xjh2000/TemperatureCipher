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
      .UART_RXD_OUT(UART_RXD_OUT),
      .UART_TXD_IN(UART_TXD_IN),
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

  uart_recv #(
      .CLK_FREQ(1000),
      .UART_BPS(1000)
  ) uart_recv_instan (
      .sys_clk(clk),
      .uart_rxd(UART_TXD_IN),
      .uart_done(uart_done),
      .rx_flag(rx_flag),
      .rx_cnt(rx_cnt),
      .rxdata(rxdata),
      .uart_data(uart_data)
  );

  initial begin

    #1 UART_TXD_IN = 1'b0;  // start bit
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;  // end bit

    #5 #1 UART_TXD_IN = 1'b0;  // start bit
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;
    #1 UART_TXD_IN = 1'b0;
    #1 UART_TXD_IN = 1'b1;  // end bit
  end

endmodule  //top_tb
