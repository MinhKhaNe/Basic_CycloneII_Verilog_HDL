module Lab1_ex1_2(SW,LEDG,LEDR);
	input[17:0] SW;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	mux21_DF IUT(SW[9],SW[8],LEDG[6]);
endmodule

module mux21_DF(i,sel,y);
	input sel;
	input [1:0] i;
	output y;
	assign y =(i[0]&(~sel))|(i[1]&sel);
endmodule
