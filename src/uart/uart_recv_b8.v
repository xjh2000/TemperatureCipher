
module uart_recv_b8 (
    input              sys_clk,    // system clock
    input              sys_rst_n,  // reset sign
    input              uart_rxd,   // uart receive
    output reg         uart_done,  // receive done flog
    output reg         rx_flag,    // receive busy flag
    output reg  [ 3:0] rx_cnt,     // receive count
    output wire [ 7:0] rxdata,
    output reg  [63:0] uart_data
);

  //parameter define
  parameter CLK_FREQ = 100_000_000;  // system colck
  parameter UART_BPS = 9600;  // bound frequency
  localparam BPS_CNT = CLK_FREQ / UART_BPS;  // one uart receive cycle need how much system cycle

  wire        uart_recv_done;
  reg  [15:0] clk_cnt;  // system clock count
  reg  [63:0] tp_uart_data;  /*synthesis syn_preserve = 1*/
  // reg define
  reg         recv_done_d0;
  reg         recv_done_d1;

  // capture up edge
  assign start_flag = (~recv_done_d1) & recv_done_d0;


  // delay two clock
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      recv_done_d0 <= 1'b0;
      recv_done_d1 <= 1'b0;
    end else begin
      recv_done_d0 <= uart_recv_done;
      recv_done_d1 <= recv_done_d0;
    end
  end

  // rx_flag represent on cycle receiver
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) rx_flag <= 1'b0;
    else begin
      if (start_flag) rx_flag <= 1'b1;
      else if ((rx_cnt == 4'd8)) rx_flag <= 1'b0;
      else rx_flag <= rx_flag;
    end
  end

  // start_flag is change , change the rx_cnt
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) rx_cnt <= 4'd0;
    else if (start_flag) rx_cnt <= rx_cnt + 1'b1;
    else if (~rx_flag) begin
      rx_cnt <= 4'b0;
    end else rx_cnt <= rx_cnt;
  end

  // storage the data by rx_cnt
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      tp_uart_data <= 64'd0;
    end else begin
      case (rx_cnt)
        4'd0: tp_uart_data[7:0] <= rxdata;
        4'd1: tp_uart_data[15:8] <= rxdata;
        4'd2: tp_uart_data[23:16] <= rxdata;
        4'd3: tp_uart_data[31:24] <= rxdata;
        4'd4: tp_uart_data[39:32] <= rxdata;
        4'd5: tp_uart_data[47:40] <= rxdata;
        4'd6: tp_uart_data[55:48] <= rxdata;
        4'd7: tp_uart_data[63:56] <= rxdata;
        default: ;
      endcase
    end
  end

  // receive over , output the data and change the done flag
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      uart_data <= 64'd0;
      uart_done <= 1'b0;
    end else if (rx_cnt == 4'd8) begin
      uart_data <= tp_uart_data;
      uart_done <= 1'b1;
    end else begin
      uart_done <= 1'b0;
    end
  end

  uart_recv #(
      .CLK_FREQ(CLK_FREQ),
      .UART_BPS(UART_BPS)
  ) uart_recv_inst (
      .sys_clk  (sys_clk),
      .sys_rst_n(sys_rst_n),

      .uart_rxd (uart_rxd),
      .uart_done(uart_recv_done),
      .uart_data(rxdata)
  );

endmodule  //uart_recv_p
