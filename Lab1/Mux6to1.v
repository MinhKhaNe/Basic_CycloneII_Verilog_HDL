module Lab1_v2(SW,LEDG,LEDR,KEY);
	input [17:0] SW;
	input [3:0] KEY;
	output [7:0] LEDG;
	output [17:0] LEDR;
	
	assign LEDR = SW;
	assign LEDG[7:4] = KEY;
	
	mux16_1(.i0(KEY[3:0]),.i(SW[11:0]),.s(SW[17:14]),.y(LEDG[0]));
endmodule

module mux41_GL(i,s,y);
	input [3:0] i;
	input [1:0] s;
	output y;
	wire n_s0,n_s1, a0,a1,a2,a3;
	not g0(n_s0,s[0]);
	not g1(n_s1,s[1]);
	and g2(a0,i[0],n_s0,n_s1);
	and g3(a1,i[1],n_s1,s[0]);
	and g4(a2,i[2],s[1],n_s0);
	and g5(a3,i[3],s[1],s[0]);
	or  g6(y,a0,a1,a2,a3);
endmodule

module mux16_1(i0,i,s,y);
	input [3:0] i0;
	input [11:0] i;
	input [3:0] s;
	output y;
	wire [3:0]a;
	
	mux41_GL(i0[3:0],s[1:0],a[0]);
	mux41_GL(i[3:0],s[1:0],a[1]);
	mux41_GL(i[7:4],s[1:0],a[2]);
	mux41_GL(i[11:8],s[1:0],a[3]);
	
	mux41_GL(a[3:0],s[3:2],y);
endmodule
