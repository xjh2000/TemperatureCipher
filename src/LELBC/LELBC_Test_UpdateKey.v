module LELBC_Test_UpdateKey(cnt,in,out);
	input [0:4]cnt;
	input [0:127]in;
	output [0:127]out;

	reg [0:3] sbox[0:15];
   	initial  begin
     	  sbox[ 0]=4'hC; sbox[ 1]=4'hE; sbox[ 2]=4'h6; sbox[ 3]=4'hA; 
     	  sbox[ 4]=4'h4; sbox[ 5]=4'hF; sbox[ 6]=4'h2; sbox[ 7]=4'h7; 
     	  sbox[ 8]=4'h9; sbox[ 9]=4'h8; sbox[10]=4'h3; sbox[11]=4'hB; 
     	  sbox[12]=4'h0; sbox[13]=4'hD; sbox[14]=4'h1; sbox[15]=4'h5; 
   	end
	wire [0:127]t1,t2;
	assign t1={in[0:119],in[120:123],sbox[in[124:127]]};//h
	assign t2={t1[0:120],(t1[121:124]^cnt[1:4]),t1[125:127]};//h
	//(b3, b2, b1, b0) to (b0 + b1, b3, b2, b1)
	assign out={t2[73:127],t2[64:72],t2[15:63],t2[0:14]};
//0x0c,0x0e,0x06,0x0a,0x04,0x0f,0x02,0x07,0x09,0x08,0x03,0x0b,0x00,0x0d,0x01,0x05
endmodule 


