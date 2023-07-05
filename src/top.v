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
    inout JA,
    inout [2:1] JD,
    inout [2:1] JB,
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
  localparam MAX_COUNTER = CLK_FREQUENCY;  // 1000ms needs number of counter  

  reg  [31:0] counter;  // counter for 100ms


  // wire define
  wire        uart_recv_done;  // receive done flag

  wire [63:0] uart_recv_data;  // receive data buff

  reg         uart_send_en;  // send start flag


  wire [63:0] uart_send_data;  // send data buff

  wire        uart_tx_busy;  // when send is busy

  wire [31:0] data;
  wire        en;
  assign en = 1'b1;

  wire [63:0] ciphertext;
  wire [63:0] plaintext;
  reg [63:0] tempOut;
  wire [127:0] key = 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;

  wire decrypt;
  assign decrypt = 1'b0;

  assign ciphertext = uart_recv_data;


  always @(posedge CLK100MHZ or negedge CPU_RESETN) begin
    // when recive data the uart_send_en flag cloud be delete
    if (!CPU_RESETN) begin
      counter <= 32'b0;
      uart_send_en <= 1'b0;
    end else if (counter < MAX_COUNTER - 1) begin
      counter <= counter + 1'b1;
      uart_send_en <= 1'b0;
    end else begin
      counter <= 32'b0;
      uart_send_en <= 1'b1;
      tempOut <= plaintext;
    end
  end

  led #(
      .CLK_FREQUENCY(CLK_FREQUENCY)
  ) led_inst (
      .clk (CLK100MHZ),
      .en  (en),
      .data(tempOut[31:0]),
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

  LELBC_Test_decrypt LELBC_Test_decrypt_inst (
      .clk(CLK100MHZ),
      .in(ciphertext),
      .key(key),
      .result(plaintext)
  );

  // des des_inst (
  //     .ciphertext(ciphertext),
  //     .plaintext (plaintext),
  //     .key   (key),
  //     .decrypt(decrypt),
  //     .clk   (CLK100MHZ)
  // );

  // ds18b20_dri ds18b20_dri_inst (
  //     .clk      (CLK100MHZ),
  //     .rst_n    (CPU_RESETN),
  //     .dq       (JA),
  //     .temp_data(plaintext[19:0])
  // );

  // uart receive module
  uart_recv_b8 #(
      .CLK_FREQ(CLK_FREQ),
      .UART_BPS(UART_BPS)
  ) uart_recv_b8_inst (
      .sys_clk  (CLK100MHZ),
      .sys_rst_n(CPU_RESETN),

      .uart_rxd (JB[1]),
      .uart_done(uart_recv_done),
      .uart_data(uart_recv_data)
  );

  // uart send module
  // uart_send_b8 #(
  //     .CLK_FREQ(CLK_FREQ),
  //     .UART_BPS(UART_BPS)
  // ) uart_send_b8_inst (
  //     .sys_clk  (CLK100MHZ),
  //     .sys_rst_n(CPU_RESETN),

  //     .uart_en     (uart_send_en),
  //     .uart_din    (uart_send_data),
  //     .uart_tx_busy(uart_tx_busy),
  //     .uart_txd    (JD[2])
  // );

  // uart loop module
  //   uart_loop uart_loop_inst (
  //       .sys_clk  (CLK100MHZ),
  //       .sys_rst_n(CPU_RESETN),

  //       .recv_done(uart_recv_done),
  //       .recv_data(uart_recv_data),

  //       .tx_busy  (uart_tx_busy),
  //       .send_en  (uart_send_en),
  //       .send_data(uart_send_data)
  //   );

endmodule  //top
