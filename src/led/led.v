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
    input en,
    input [31:0] data,
    output reg CA,
    output reg CB,
    output reg CC,
    output reg CD,
    output reg CE,
    output reg CF,
    output reg CG,
    output reg DP,
    output reg [7:0] AN
);
  parameter CLK_FREQUENCY = 100_000_000;
  localparam MAX_COUNTER = CLK_FREQUENCY / 1000;  // 1ms needs number of counter  

  reg [31:0] counter;  // counter for 1ms
  reg        one_ms;  // 1ms one_ms
  reg [ 7:0] counter_AN;  // counter for AN enable , counter 0-15 for 8 AN
  reg [ 5:0] number_display;  // display number

  // assign DP = 1'b1;

  // use counter to creat 1ms delay signl
  always @(posedge clk) begin
    if (counter < MAX_COUNTER - 1) begin
      counter <= counter + 1'b1;
      one_ms  <= 1'b0;
    end else begin
      counter <= 32'b0;
      one_ms  <= 1'b1;
    end
  end

  // change counter_AN for one_ms
  always @(posedge clk) begin
    if (one_ms) begin
      if (counter_AN < 8'd15) counter_AN <= counter_AN + 1'b1;
      else counter_AN <= 8'b0;
    end
  end

  // change AN and number_display driver by one_ms (1ms)
  always @(posedge clk) begin
    if (en) begin
      case (counter_AN)
        // 0 index
        8'd0: begin
          AN <= 8'b01111111;
          DP <= 1'b1;
          number_display <= {1'b0, data[31:28]};
        end
        8'd1: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 1 index
        8'd2: begin
          AN <= 8'b10111111;
          DP <= 1'b1;
          number_display <= {1'b0, data[27:24]};
        end
        8'd3: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 2 index
        8'd4: begin
          AN <= 8'b11011111;
          DP <= 1'b1;
          number_display <= {1'b0, data[23:20]};
        end
        8'd5: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 3 index
        8'd6: begin
          AN <= 8'b11101111;
          number_display <= {1'b0, data[19:16]};
        end
        8'd7: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 4 index
        8'd8: begin
          AN <= 8'b11110111;
          number_display <= {1'b0, data[15:12]};
        end
        8'd9: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 5 index
        8'd10: begin
          AN <= 8'b11111011;
          DP <= 1'b0;
          number_display <= {1'b0, data[11:8]};
        end
        8'd11: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 6 index
        8'd12: begin
          AN <= 8'b11111101;
          DP <= 1'b1;
          number_display <= {1'b0, data[7:4]};
        end
        8'd13: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
        // 7 index
        8'd14: begin
          AN <= 8'b11111110;
          number_display <= {1'b0, data[3:0]};
        end
        8'd15: begin
          AN <= 8'b11111111;
          number_display <= 5'd16;
        end
      endcase

    end else begin
      AN <= 8'b11111111;
      number_display <= 5'd16;
    end
  end

  always @(posedge clk) begin
    case (number_display)
      5'd0: begin
        // b1000000
        CG <= 1'b1;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b0;

      end
      5'd1: begin
        // b1111001
        CG <= 1'b1;
        CF <= 1'b1;
        CE <= 1'b1;
        CD <= 1'b1;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b1;
      end
      5'd2: begin
        // b0100100
        CG <= 1'b0;
        CF <= 1'b1;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b1;
        CB <= 1'b0;
        CA <= 1'b0;
      end
      5'd3: begin
        // b0110000
        CG <= 1'b0;
        CF <= 1'b1;
        CE <= 1'b1;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b0;

      end
      5'd4: begin
        // b0011001
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b1;
        CD <= 1'b1;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b1;
      end
      5'd5: begin
        // b0010010
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b1;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b1;
        CA <= 1'b0;
      end
      5'd6: begin
        // b0000010
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b1;
        CA <= 1'b0;

      end
      5'd7: begin
        // b1111000
        CG <= 1'b1;
        CF <= 1'b1;
        CE <= 1'b1;
        CD <= 1'b1;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b0;
      end
      5'd8: begin
        // b0000000
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b0;
      end
      5'd9: begin
        // b0010000
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b1;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b0;

      end
      5'd10: begin
        // b0001000
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b1;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b0;
      end
      5'd11: begin
        // b0000011
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b1;
        CA <= 1'b1;
      end
      5'd12: begin
        // b1000110
        CG <= 1'b1;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b1;
        CB <= 1'b1;
        CA <= 1'b0;
      end
      5'd13: begin
        // b0100001
        CG <= 1'b0;
        CF <= 1'b1;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b0;
        CB <= 1'b0;
        CA <= 1'b1;

      end
      5'd14: begin
        // b0000110
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b0;
        CC <= 1'b1;
        CB <= 1'b1;
        CA <= 1'b0;
      end
      5'd15: begin
        // b0001110
        CG <= 1'b0;
        CF <= 1'b0;
        CE <= 1'b0;
        CD <= 1'b1;
        CC <= 1'b1;
        CB <= 1'b1;
        CA <= 1'b0;
      end
      5'd16: begin
        // b1111111
        CG <= 1'b1;
        CF <= 1'b1;
        CE <= 1'b1;
        CD <= 1'b1;
        CC <= 1'b1;
        CB <= 1'b1;
        CA <= 1'b1;
      end
    endcase
  end

endmodule
