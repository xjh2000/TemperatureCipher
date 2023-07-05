

module LELBC_Test_decrypt (
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
  wire [0:127]keyres1,keyres2,keyres3,keyres4,keyres5,keyres6,keyres7,keyres8,keyres9,keyres10,keyres11,keyres12,keyres13,keyres14,keyres15,keyres16;

  assign keyres1=128'h5BFB_9B3B_DB7B_1BBB_C595_E5B5_85D5_A5F5;//0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;//FFFF_FFFF_FFFF_FFFF_FFFF;//0123_4567_89AB_CDEF_00FF;//0000_0000_0000_0000_0000;
  assign keyres2 = 128'h4BEB_8B2B_CB6B_0BAB_DDAD_FDCD_9DED_BDFF;
  assign keyres3 = 128'h7BFF_BB5B_FB9B_3BDB_D5A5_F5C5_95E5_B5FF;
  assign keyres4 = 128'h6BFF_AB4B_EB8B_2BCB_EDBD_FFDD_ADFD_CDFF;
  assign keyres5 = 128'h9BFF_DB7B_FFBB_5BFB_E5B5_FFD5_A5F5_C5FF;
  assign keyres6 = 128'h8BFF_CB6B_FFAB_4BEB_FDCD_FFED_BDFF_DDFF;
  assign keyres7 = 128'hBBFF_FB9B_FFDB_7BFF_F5C5_FFE5_B5FF_D5FF;
  assign keyres8 = 128'hABFF_EB8B_FFCB_6BFF_FFDD_FFFD_CDFF_EDFF;
  assign keyres9 = 128'hDBFF_FFBB_FFFB_9BFF_FFD5_FFF5_C5FF_E5FF;
  assign keyres10 = 128'hCBFF_FFAB_FFEB_8BFF_FFED_FFFF_DDFF_FDFF;
  assign keyres11 = 128'hFBFF_FFDB_FFFF_BBFF_FFE5_FFFF_D5FF_F5FF;
  assign keyres12 = 128'hEBFF_FFCB_FFFF_ABFF_FFFD_FFFF_EDFF_FFFF;
  assign keyres13 = 128'hFFFF_FFFB_FFFF_DBFF_FFF5_FFFF_E5FF_FFFF;
  assign keyres14 = 128'hFFFF_FFEB_FFFF_CBFF_FFFF_FFFF_FDFF_FFFF;
  assign keyres15 = 128'hFFFF_FFFF_FFFF_FBFF_FFFF_FFFF_F5FF_FFFF;
  assign keyres16 = 128'hFFFF_FFFF_FFFF_EBFF_FFFF_FFFF_FFFF_FFFF;

  wire [0:63] in1;
  assign in1 = {in[32:63], in[0:31]};

  initial begin
    ready = 1;
    cnt <= 5'h00;
    //i   <=8'hff;
  end

  always @(posedge clk) begin
    cnt <= ((cnt ^ 5'd16) != 0) ? cnt + 1 : 5'd0;
    res <= (cnt != 0) ? t_res : in1;
    //keyres <=(ready)?((cnt)?t_keyres:key):keyres;
    keyres <= (cnt==0)?keyres1:((cnt==1)?keyres2:((cnt==2)?keyres3:((cnt==3)?keyres4:((cnt==4)?keyres5:((cnt==5)?keyres6:((cnt==6)?keyres7:((cnt==7)?keyres8:((cnt==8)?keyres9:((cnt==9)?keyres10:((cnt==10)?keyres11:((cnt==11)?keyres12:((cnt==12)?keyres13:((cnt==13)?keyres14:((cnt==14)?keyres15:keyres16))))))))))))));
  end

  LELBC_Test_RF_decrypt ltr1 (
      res,
      keyres,
      (16 - cnt),
      t_res
  );  //GFT_Round(in,key,tweak,i,res,keyres,tweakres);

  assign result = (cnt ^ 5'd16) == 0 ? {res[32:63], res[0:31]} : result;
endmodule
