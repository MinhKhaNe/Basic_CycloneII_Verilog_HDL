module Lab1_ex1_2(SW,LEDG,LEDR);
	input[17:0] SW;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	full_adder_DF UUT(SW[4],SW[3],SW[2],LEDG[3],LEDG[2]);
endmodule

module full_adder_DF(a, b, cin,s, cout);
  input a,b,cin;
  output s, cout;
	assign s = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
