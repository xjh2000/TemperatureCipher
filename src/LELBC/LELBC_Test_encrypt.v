module LELBC_Test_encrypt (
    in,
    result
);

  input [0:63] in;
  output [0:63] result;

  wire [0:127]keyres1,keyres2,keyres3,keyres4,keyres5,keyres6,keyres7,keyres8,keyres9,keyres10,keyres11,keyres12,keyres13,keyres14,keyres15,keyres16;
  wire [0:63] x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;

  assign keyres16 = 128'h5BFB_9B3B_DB7B_1BBB_C595_E5B5_85D5_A5F5;
  assign keyres15 = 128'h4BEB_8B2B_CB6B_0BAB_DDAD_FDCD_9DED_BDFF;
  assign keyres14 = 128'h7BFF_BB5B_FB9B_3BDB_D5A5_F5C5_95E5_B5FF;
  assign keyres13 = 128'h6BFF_AB4B_EB8B_2BCB_EDBD_FFDD_ADFD_CDFF;
  assign keyres12 = 128'h9BFF_DB7B_FFBB_5BFB_E5B5_FFD5_A5F5_C5FF;
  assign keyres11 = 128'h8BFF_CB6B_FFAB_4BEB_FDCD_FFED_BDFF_DDFF;
  assign keyres10 = 128'hBBFF_FB9B_FFDB_7BFF_F5C5_FFE5_B5FF_D5FF;
  assign keyres9  = 128'hABFF_EB8B_FFCB_6BFF_FFDD_FFFD_CDFF_EDFF;
  assign keyres8  = 128'hDBFF_FFBB_FFFB_9BFF_FFD5_FFF5_C5FF_E5FF;
  assign keyres7  = 128'hCBFF_FFAB_FFEB_8BFF_FFED_FFFF_DDFF_FDFF;
  assign keyres6  = 128'hFBFF_FFDB_FFFF_BBFF_FFE5_FFFF_D5FF_F5FF;
  assign keyres5  = 128'hEBFF_FFCB_FFFF_ABFF_FFFD_FFFF_EDFF_FFFF;
  assign keyres4  = 128'hFFFF_FFFB_FFFF_DBFF_FFF5_FFFF_E5FF_FFFF;
  assign keyres3  = 128'hFFFF_FFEB_FFFF_CBFF_FFFF_FFFF_FDFF_FFFF;
  assign keyres2  = 128'hFFFF_FFFF_FFFF_FBFF_FFFF_FFFF_F5FF_FFFF;
  assign keyres1  = 128'hFFFF_FFFF_FFFF_EBFF_FFFF_FFFF_FFFF_FFFF;
  LELBC_Test_RF ltr1 (
      in,
      keyres1,
      4'b0000,
      x1
  );
  LELBC_Test_RF ltr2 (
      x1,
      keyres2,
      4'b0001,
      x2
  );
  LELBC_Test_RF ltr3 (
      x2,
      keyres3,
      4'b0010,
      x3
  );
  LELBC_Test_RF ltr4 (
      x3,
      keyres4,
      4'b0011,
      x4
  );
  LELBC_Test_RF ltr5 (
      x4,
      keyres5,
      4'b0100,
      x5
  );
  LELBC_Test_RF ltr6 (
      x5,
      keyres6,
      4'b0101,
      x6
  );
  LELBC_Test_RF ltr7 (
      x6,
      keyres7,
      4'b0110,
      x7
  );
  LELBC_Test_RF ltr8 (
      x7,
      keyres8,
      4'b0111,
      x8
  );
  LELBC_Test_RF ltr9 (
      x8,
      keyres9,
      4'b1000,
      x9
  );
  LELBC_Test_RF ltr10 (
      x9,
      keyres10,
      4'b1001,
      x10
  );
  LELBC_Test_RF ltr11 (
      x10,
      keyres11,
      4'b1010,
      x11
  );
  LELBC_Test_RF ltr12 (
      x11,
      keyres12,
      4'b1011,
      x12
  );
  LELBC_Test_RF ltr13 (
      x12,
      keyres13,
      4'b1100,
      x13
  );
  LELBC_Test_RF ltr14 (
      x13,
      keyres14,
      4'b1101,
      x14
  );
  LELBC_Test_RF ltr15 (
      x14,
      keyres15,
      4'b1110,
      x15
  );
  LELBC_Test_RF ltr16 (
      x15,
      keyres16,
      4'b1111,
      result
  );
endmodule
