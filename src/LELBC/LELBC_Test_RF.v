module LELBC_Test_RF(in,key,cnt,result);
	input [0:63]in;
	input [0:127]key;
	input [0:3]cnt;
	output [0:63]result;
	//output [0:127]key_result;

	reg [0:3] sbox[0:15];
   	initial  begin
     	  sbox[ 0]=4'hC; sbox[ 1]=4'hE; sbox[ 2]=4'h6; sbox[ 3]=4'hA; 
     	  sbox[ 4]=4'h4; sbox[ 5]=4'hF; sbox[ 6]=4'h2; sbox[ 7]=4'h7; 
     	  sbox[ 8]=4'h9; sbox[ 9]=4'h8; sbox[10]=4'h3; sbox[11]=4'hB; 
     	  sbox[12]=4'h0; sbox[13]=4'hD; sbox[14]=4'h1; sbox[15]=4'h5; 
   	end
    	
	//LELBC_Test_UpdateKey ltu(cnt,key,key_result);

	wire [0:63]in1;
	//wire [0:63]in1,in2,in3;
	//1
	assign in1[0:31]=in[0:31]^key[0:31];
	//2
	wire [0:31]temp1;
	assign temp1={in1[5:31],in1[0:4]};
	assign in1[32:63]=temp1[0:31]^in[32:63];
	//3
	wire [0:63]in2;
	assign in2={sbox[ in1[0:3] ],sbox[ in1[4:7] ],sbox[ in1[8:11] ],sbox[ in1[12:15]],sbox[ in1[16:19]],sbox[ in1[20:23]],sbox[ in1[24:27]],sbox[ in1[28:31]],sbox[ in1[32:35] ],sbox[ in1[36:39] ],sbox[ in1[40:43] ],sbox[ in1[44:47]],sbox[ in1[48:51]],sbox[ in1[52:55]],sbox[ in1[56:59]],sbox[ in1[60:63]]}; //subcell
	//4
	wire [0:31]temp2;
	wire [0:63]in3;
	assign temp2={in2[37:63],in2[32:36]};
	assign in3[0:31]=temp2[0:31]^in2[0:31];
	//5
	assign in3[32:63]=in2[32:63]^key[32:63];
	assign result=in3;

endmodule
