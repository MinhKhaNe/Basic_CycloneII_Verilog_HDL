module Lab1_ex1_2(SW,LEDG,LEDR);
	input[17:0] SW;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	mux41_df NUT(SW[15],SW[14],SW[13],SW[12],SW[11],SW[10],LEDG[7]);
endmodule

module mux41_df (i0,i1,i2,i3,s0,s1,y);
	input i0,i1,i2,i3,s0,s1;
	output y;
	assign y= i0&(~s1)&(~s0) | i1 &(~s1)&s0  | i2&s1&(~s0) | i3&s1&s0;
endmodule
