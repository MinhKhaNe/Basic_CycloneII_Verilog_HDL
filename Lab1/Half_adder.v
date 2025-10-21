module Lab1_ex1_2(SW,LEDG,LEDR);
	input[17:0] SW;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	half_adder_DF DUT(SW[1],SW[0],LEDG[1],LEDG[0]);
endmodule

module half_adder_DF( a, b,  S, Cout);
  input a,b;
  output S,Cout;	

  assign S = a ^ b;
  assign Cout = a & b;
endmodule
