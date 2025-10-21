module Lab1_ex1_2(SW,LEDG,LEDR);
	input[17:0] SW;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	half_adder_DF DUT(SW[1],SW[0],LEDG[1],LEDG[0]);
	full_adder_DF UUT(SW[4],SW[3],SW[2],LEDG[3],LEDG[2]);
	four_bit_adder_DF XUT(SW[7],SW[6],SW[5],LEDG[5],LEDG[4]);
	mux21_DF IUT(SW[9],SW[8],LEDG[6]);
	mux41_df NUT(SW[15],SW[14],SW[13],SW[12],SW[11],SW[10],LEDG[7]);
endmodule

module half_adder_DF( a, b,  S, Cout);
  input a,b;
  output S,Cout;	

  assign S = a ^ b;
  assign Cout = a & b;
endmodule

module full_adder_DF(a, b, cin,s, cout);
  input a,b,cin;
  output s, cout;
	assign s = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module four_bit_adder_DF(a,b,cin,s,cout);
    input [3:0] a, b;
    input cin;
    output [3:0] s;
    output cout;

    wire [3:0] carry;

    assign carry[0] = (a[0] & b[0]) | (b[0] & cin) | (cin & a[0]);
    assign carry[1] = (a[1] & b[1]) | (b[1] & carry[0]) | (carry[0] & a[1]);
    assign carry[2] = (a[2] & b[2]) | (b[2] & carry[1]) | (carry[1] & a[2]);
    assign carry[3] = (a[3] & b[3]) | (b[3] & carry[2]) | (carry[2] & a[3]);

    assign s[0] = a[0] ^ b[0] ^ cin;
    assign s[1] = a[1] ^ b[1] ^ carry[0];
    assign s[2] = a[2] ^ b[2] ^ carry[1];
    assign s[3] = a[3] ^ b[3] ^ carry[2];

    assign cout = carry[3];
endmodule

module mux21_DF(i,sel,y);
	input sel;
	input [1:0] i;
	output y;
	assign y =(i[0]&(~sel))|(i[1]&sel);
endmodule

module mux41_df (i0,i1,i2,i3,s0,s1,y);
	input i0,i1,i2,i3,s0,s1;
	output y;
	assign y= i0&(~s1)&(~s0) | i1 &(~s1)&s0  | i2&s1&(~s0) | i3&s1&s0;
endmodule

