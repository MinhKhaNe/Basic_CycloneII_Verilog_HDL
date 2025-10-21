module Lab1_ex1_2(SW,LEDG,LEDR);
	input[17:0] SW;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	four_bit_adder_DF XUT(SW[7],SW[6],SW[5],LEDG[5],LEDG[4]);
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
