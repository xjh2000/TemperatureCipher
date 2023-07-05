module uart_recv (
    input            sys_clk,    // system clock
    input            sys_rst_n,  // reset sign
    input            uart_rxd,   // uart receive
    output reg       uart_done,  // receive done flog
    output reg       rx_flag,    // receive busy flag
    output reg [3:0] rx_cnt,     // receive count
    output reg [7:0] rxdata,
    output reg [7:0] uart_data
);  // receive data buff

  //parameter define
  parameter CLK_FREQ = 100_000_000;  // system colck
  parameter UART_BPS = 9600;  // bound frequency
  localparam BPS_CNT = CLK_FREQ / UART_BPS;  // one uart receive cycle need how much system cycle

  //reg define
  reg         uart_rxd_d0 = 1;
  reg         uart_rxd_d1 = 1;
  reg  [15:0] clk_cnt;  // system clock count

  //wire define
  wire        start_flag;

  //*****************************************************
  //**                    main code
  //*****************************************************
  // capture falling edge
  assign start_flag = uart_rxd_d1 & (~uart_rxd_d0);

  // delay tow cycle
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      uart_rxd_d0 <= 1'b0;
      uart_rxd_d1 <= 1'b0;
    end else begin
      uart_rxd_d0 <= uart_rxd;
      uart_rxd_d1 <= uart_rxd_d0;
    end
  end

  // data coming , change the rx_flag
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) rx_flag <= 1'b0;
    else begin
      if (start_flag) rx_flag <= 1'b1;
      else if ((rx_cnt == 4'd9) && (clk_cnt == BPS_CNT / 2)) rx_flag <= 1'b0;
      else rx_flag <= rx_flag;
    end
  end

  // handler system colck counter
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) clk_cnt <= 16'd0;
    else if (rx_flag) begin
      if (clk_cnt < BPS_CNT - 1) clk_cnt <= clk_cnt + 1'b1;
      else clk_cnt <= 16'd0;
    end else clk_cnt <= 16'd0;
  end

  // rx_flag is change , change the rx_cnt
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) rx_cnt <= 4'd0;
    else if (rx_flag) begin
      if (clk_cnt == BPS_CNT - 1) rx_cnt <= rx_cnt + 1'b1;
      else rx_cnt <= rx_cnt;
    end else rx_cnt <= 4'd0;
  end

  // storage the data by rx_cnt
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) rxdata <= 8'd0;
    else if (rx_flag)
      if (clk_cnt == BPS_CNT / 2) begin
        case (rx_cnt)
          4'd1: rxdata[0] <= uart_rxd_d1;
          4'd2: rxdata[1] <= uart_rxd_d1;
          4'd3: rxdata[2] <= uart_rxd_d1;
          4'd4: rxdata[3] <= uart_rxd_d1;
          4'd5: rxdata[4] <= uart_rxd_d1;
          4'd6: rxdata[5] <= uart_rxd_d1;
          4'd7: rxdata[6] <= uart_rxd_d1;
          4'd8: rxdata[7] <= uart_rxd_d1;
          default: ;
        endcase
      end else begin
        rxdata <= rxdata;
      end
    else rxdata <= 8'd0;
  end

  // receive over , output the data and change the done flag
  always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
      uart_data <= 8'd0;
      uart_done <= 1'b0;
    end else if (rx_cnt == 4'd9) begin
      uart_data <= rxdata;
      uart_done <= 1'b1;
    end else begin
      uart_data <= 8'd0;
      uart_done <= 1'b0;
    end
  end

endmodule
