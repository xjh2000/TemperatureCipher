`timescale 1ns / 1ps
module uart_recv_tb;

  reg clk;
  reg UART_TXD_IN;
  wire uart_done;  // receive done flog
  wire rx_flag;  // receive busy flag
  wire [3:0] rx_cnt;  // receive count
  wire [7:0] rxdata;
  wire [7:0] uart_data;

  // simulation init
  initial begin
    #1 UART_TXD_IN = 1'b0;  // start bit
    clk = 0;
    forever clk = #(0.5) ~clk;
  end

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
