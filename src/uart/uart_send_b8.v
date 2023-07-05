module uart_send_b8 (
    input             sys_clk,       // system clock
    input             sys_rst_n,     // reset sign
    input             uart_en,       // uart start sign
    input      [63:0] uart_din,      // uart will sended data
    output            uart_tx_busy,  // uart send busy
    output            en_flag,
    output reg        tx_flag,       // sending flag
    output reg [ 7:0] tx_data,       // sending data
    output reg [ 3:0] tx_cnt,        // send bit count
    output            uart_txd
);  // uart send

  //parameter define
  parameter CLK_FREQ = 100_000_000;  // system clock
  parameter UART_BPS = 9600;  // bound frequency


  //reg define
  reg  uart_en_d0;
  reg  uart_en_d1;

  reg  uart_send_en;  // send start flag

  reg  busy_d0;
  reg  busy_d1;

  wire busy;


  assign uart_tx_busy = tx_flag;

  assign send_end = busy_d1 & (~busy_d0);

  // capture up edge
  assign en_flag = (~uart_en_d1) & uart_en_d0;

  // delay two clock
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      uart_en_d0 <= 1'b0;
      uart_en_d1 <= 1'b0;
      busy_d0    <= 1'b0;
      busy_d1    <= 1'b0;
    end else begin
      uart_en_d0 <= uart_en;
      uart_en_d1 <= uart_en_d0;
      busy_d0    <= busy;
      busy_d1    <= busy_d0;
    end
  end

  // en_flag to open tx_flag, start first send
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      tx_flag <= 1'b0;
    end else if (en_flag) begin
      tx_flag <= 1'b1;
    end else if ((tx_cnt == 4'd7)) begin
      tx_flag <= 1'b0;
    end else begin
      tx_flag <= tx_flag;
    end
  end

  // uart_send_en
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      uart_send_en <= 1'b0;
    end else begin
      if (en_flag) begin
        uart_send_en <= 1'b1;
      end else if (tx_flag && send_end) uart_send_en <= 1'b1;
      else if (~busy) uart_send_en <= 1'b0;

    end
  end

  // start_flag is change , change the tx_cnt
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) tx_cnt <= 4'd0;
    else begin
      if (~tx_flag) begin
        tx_cnt <= 4'b0;
      end else if (en_flag || send_end) tx_cnt <= tx_cnt + 1'b1;
      else tx_cnt <= tx_cnt;

    end

  end

  // tx_data
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      tx_data <= 8'd0;
    end else begin
      case (tx_cnt)
        4'd0: tx_data <= uart_din[7:0];
        4'd1: tx_data <= uart_din[15:8];
        4'd2: tx_data <= uart_din[23:16];
        4'd3: tx_data <= uart_din[31:24];
        4'd4: tx_data <= uart_din[39:32];
        4'd5: tx_data <= uart_din[47:40];
        4'd6: tx_data <= uart_din[55:48];
        4'd7: tx_data <= uart_din[63:56];
        default: ;
      endcase
    end
  end

  // uart send module
  uart_send #(
      .CLK_FREQ(CLK_FREQ),
      .UART_BPS(UART_BPS)
  ) uart_send_inst (
      .sys_clk  (sys_clk),
      .sys_rst_n(sys_rst_n),

      .uart_en     (uart_send_en),
      .uart_din    (tx_data),
      .uart_tx_busy(busy),
      .uart_txd    (uart_txd)
  );


endmodule  //p_uart_send
