module uart_send(input	 sys_clk,           // system clock
                 input sys_rst_n,          // reset sign
                 input uart_en,            // uart start sign
                 input [7:0] uart_din,     // uart will sended data
                 output uart_tx_busy,      // uart send busy
                 output en_flag,
                 output reg tx_flag,       // sending flag
                 output reg [7:0] tx_data, // sending data
                 output reg [3:0] tx_cnt,  // send bit count
                 output reg uart_txd);     // uart send

//parameter define
parameter  CLK_FREQ = 100_000_000;             // system clock
parameter  UART_BPS = 9600;                 // bound frequency
localparam  BPS_CNT = CLK_FREQ/UART_BPS;   // one uart receive cycle need how much system cycle

//reg define
reg        uart_en_d0;
reg        uart_en_d1;
reg [15:0] clk_cnt;

//*****************************************************
//**                    main code
//*****************************************************

assign uart_tx_busy = tx_flag;

// capture up edge
assign en_flag = (~uart_en_d1) & uart_en_d0;

// delay two clock
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        uart_en_d0 <= 1'b0;
        uart_en_d1 <= 1'b0;
    end
    else begin
        uart_en_d0 <= uart_en;
        uart_en_d1 <= uart_en_d0;
    end
end

// en_flag to open tx_flag and receive tx_data from uart_din
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        tx_flag <= 1'b0;
        tx_data <= 8'd0;
    end
    else if (en_flag) begin
        tx_flag <= 1'b1;
        tx_data <= uart_din;
    end
        else if ((tx_cnt == 4'd9) && (clk_cnt == BPS_CNT - (BPS_CNT/16))) begin
        tx_flag <= 1'b0;
        tx_data <= 8'd0;
        end
    else begin
        tx_flag <= tx_flag;
        tx_data <= tx_data;
    end
end

// use tx_flag open sys_clk
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        clk_cnt <= 16'd0;
    else if (tx_flag) begin
        if (clk_cnt < BPS_CNT - 1)
            clk_cnt <= clk_cnt + 1'b1;
        else
            clk_cnt <= 16'd0;
    end
    else
        clk_cnt <= 16'd0;
end

// clk_cnt to open tx_cnt
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        tx_cnt <= 4'd0;
    else if (tx_flag) begin
        if (clk_cnt == BPS_CNT - 1)
            tx_cnt <= tx_cnt + 1'b1;
        else
            tx_cnt <= tx_cnt;
    end
    else
        tx_cnt <= 4'd0;
end

// use tx_cnt to send data to uart_txd
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        uart_txd <= 1'b1;
    else if (tx_flag)
        case(tx_cnt)
            4'd0: uart_txd <= 1'b0;
            4'd1: uart_txd <= tx_data[0];
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];
            4'd9: uart_txd <= 1'b1;
            default: ;
        endcase
    else
        uart_txd <= 1'b1;
end

endmodule
