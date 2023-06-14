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
    input CPU_RESETN,
    input UART_TXD_IN,
    output UART_RXD_OUT,
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
  // parameter define
  parameter CLK_FREQ = 100_000_000;  // sys clock frequency
  parameter UART_BPS = 115200;  // uart bound frequency

  // wire define
  wire        uart_recv_done;  // receive done flag
  wire [63:0] uart_recv_data;  /*synthesis syn_keep = 1*/  // receive data buff
  wire        uart_send_en;  // send start flag
  wire [63:0] uart_send_data;  // send data buff
  wire        uart_tx_busy;  // when send is busy

  reg  [31:0] data = 32'h12345678;
  wire        en;
  assign en = 1'b1;

  led #(
      .CLK_FREQUENCY(CLK_FREQUENCY)
  ) led_inst (
      .clk (CLK100MHZ),
      .en  (en),
      .data(uart_send_data[31:0]),
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


  // uart receive module
  uart_recv_b8 #(
      .CLK_FREQ(CLK_FREQ),
      .UART_BPS(UART_BPS)
  ) uart_recv_b8_inst (
      .sys_clk  (CLK100MHZ),
      .sys_rst_n(CPU_RESETN),

      .uart_rxd (UART_TXD_IN),
      .uart_done(uart_recv_done),
      .uart_data(uart_recv_data)
  );

  // uart send module
  uart_send_b8 #(
      .CLK_FREQ(CLK_FREQ),
      .UART_BPS(UART_BPS)
  ) uart_send_b8_inst (
      .sys_clk  (CLK100MHZ),
      .sys_rst_n(CPU_RESETN),

      .uart_en     (uart_send_en),
      .uart_din    (uart_send_data),
      .uart_tx_busy(uart_tx_busy),
      .uart_txd    (UART_RXD_OUT)
  );

  // uart loop module
  uart_loop uart_loop_inst (
      .sys_clk  (CLK100MHZ),
      .sys_rst_n(CPU_RESETN),

      .recv_done(uart_recv_done),
      .recv_data(uart_recv_data),

      .tx_busy  (uart_tx_busy),
      .send_en  (uart_send_en),
      .send_data(uart_send_data)
  );

endmodule  //top
