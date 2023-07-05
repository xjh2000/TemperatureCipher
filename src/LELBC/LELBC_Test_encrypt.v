

module LELBC_Test_encrypt (
    clk,
    in,
    key,
    result
);
  input clk;
  input [0:63] in;
  input [0:127] key;
  output [0:63] result;
  reg ready;
  reg [0:4] cnt;

  reg [0:63] res;
  reg [0:127] keyres;
  wire [0:63] t_res, result;
  wire [0:127] t_keyres;

  initial begin
    ready = 1;
    cnt   = 5'd0;
    //i   <=8'hff;
  end

  always @(posedge clk) begin
    cnt <= ((cnt ^ 5'd16) > 0) ? cnt + 1 : 5'd0;
    res <= (cnt > 0) ? t_res : in;
    keyres <= ((cnt > 0) ? t_keyres : key);
  end

  LELBC_Test_RF ltr (
      res,
      keyres,
      cnt - 1,
      t_res,
      t_keyres
  );  //GFT_Round(in,key,tweak,i,res,keyres,tweakres);

  // when encrypt end to output result
  assign result = (cnt ^ 5'd16) == 0 ? res : result;

endmodule
