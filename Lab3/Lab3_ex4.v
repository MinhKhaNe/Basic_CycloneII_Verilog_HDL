module Lab3_ex4(
	input  [15:0] SW,
    input   [1:0] KEY,
    output	[15:0] LEDR,
    output [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0,
    output [15:0] p
);
    wire [7:0] A_reg, B_reg;
    wire [15:0] p_comb;
    wire clk, clrn;
    
    assign clk = KEY[1], clrn = KEY[0];
    dff8 regA (.d(SW[15:8]), .clk(clk), .clrn(clrn), .q(A_reg));
	dff8 regB (.d(SW[7:0]), .clk(clk), .clrn(clrn), .q(B_reg));
	array_multiplier_8bit DUT (.a(A_reg), .b(B_reg), .p(p_comb));
	dff16 regP (.d(p_comb), .clk(clk), .clrn(clrn), .q(p));

	assign LEDR = p; 

	hex7seg h7(A_reg[7:4], HEX7);
	hex7seg h6(A_reg[3:0], HEX6);
	hex7seg h5(B_reg[7:4], HEX5);
	hex7seg h4(B_reg[3:0], HEX4);
	hex7seg h3(p[15:12], HEX3);
	hex7seg h2(p[11:8], HEX2);
	hex7seg h1(p[7:4], HEX1);
	hex7seg h0(p[3:0], HEX0);

endmodule

module full_adder(
	input 	wire 	a,
	input 	wire 	b,
	input 	wire 	Cin,
	output 	wire	Cout,
	output	wire	Sum
);
	wire sum1;
	wire c1, c2, c3, c4;

	xor(sum1, a, b);
	xor(Sum, sum1, Cin);
	
	and(c1, a, b);
	and(c2, b, Cin);
	and(c3, a, Cin);
	
	or(c4, c1, c2);
	or(Cout, c4, c3);

endmodule

module hex7seg(
    input  wire [3:0] hex,
    output reg  [6:0] seg
);
    always @(*) begin
        case (hex)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111; 
        endcase
    end
endmodule
    

module dff8(
    input  wire [7:0] d,
    input  wire        clk,
    input  wire        clrn,
    output reg  [7:0] q
);
    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            q <= 8'h0;
        else
            q <= d;
    end
endmodule

module dff16(
    input  wire [15:0] d,
    input  wire        clk,
    input  wire        clrn,
    output reg  [15:0] q
);
    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            q <= 16'h0;
        else
            q <= d;
    end
endmodule

module array_multiplier_4bit (
    input  [3:0] a, b,
    output [7:0] p
);
	wire [3:0] pp0, pp1, pp2, pp3;

    assign pp0 = a & {4{b[0]}}; 
    assign pp1 = a & {4{b[1]}};
    assign pp2 = a & {4{b[2]}}; 
    assign pp3 = a & {4{b[3]}}; 

    wire [3:0] s1, c1; 
    wire [3:0] s2, c2;
    wire [3:0] s3;
    wire [2:0] c3;

    assign p[0] = pp0[0];

    wire c_ha1;
    half_adder ha1(pp0[1], pp1[0], c_ha1, p[1]); 

    full_adder fa11(pp0[2], pp1[1], c_ha1, c1[0], s1[0]);
    full_adder fa12(pp0[3], pp1[2], c1[0], c1[1], s1[1]);
    full_adder fa13(1'b0, pp1[3], c1[1], c1[2], s1[2]);

    assign s1[3] = c1[2]; 

    full_adder fa21(s1[0], pp2[0], 1'b0, c2[0], p[2]);
    full_adder fa22(s1[1], pp2[1], c2[0], c2[1], s2[0]);
    full_adder fa23(s1[2], pp2[2], c2[1], c2[2], s2[1]);
    full_adder fa24(s1[3], pp2[3], c2[2], c2[3], s2[2]);
    assign s2[3] = c2[3];

    full_adder fa31(s2[0], pp3[0], 1'b0, c3[0], p[3]); 
    full_adder fa32(s2[1], pp3[1], c3[0], c3[1], p[4]);
    full_adder fa33(s2[2], pp3[2], c3[1], c3[2], p[5]);
    full_adder fa34(s2[3], pp3[3], c3[2], p[7], p[6]); 

endmodule

module half_adder (input a, b, output cout, sum);
    assign sum  = a ^ b;
    assign cout = a & b;
endmodule

module ripple_carry_adder_16bit (
    input  [15:0] a, b,
    output [15:0] sum
);
    wire [15:0] carry;
    full_adder fa [15:0] (
        .a(a), 
        .b(b), 
        .cin({carry[14:0], 1'b0}),
        .cout(carry), 
        .sum(sum)
    );
endmodule

module array_multiplier_8bit (
    input  [7:0] a, b,
    output [15:0] p
);
    wire [3:0] a_h, a_l, b_h, b_l;
    assign a_h = a[7:4];
    assign a_l = a[3:0];
    assign b_h = b[7:4];
    assign b_l = b[3:0];

    wire [7:0] p_ll, p_lh, p_hl, p_hh;

    array_multiplier_4bit inst_ll (.a(a_l), .b(b_l), .p(p_ll));
    array_multiplier_4bit inst_lh (.a(a_l), .b(b_h), .p(p_lh));
    array_multiplier_4bit inst_hl (.a(a_h), .b(b_l), .p(p_hl));
    array_multiplier_4bit inst_hh (.a(a_h), .b(b_h), .p(p_hh));

    wire [15:0] term_ll, term_lh, term_hl, term_hh;

    assign term_ll = {{8{1'b0}}, p_ll};
    assign term_lh = {{4{1'b0}}, p_lh, {4{1'b0}}};
    assign term_hl = {{4{1'b0}}, p_hl, {4{1'b0}}};
    assign term_hh = {p_hh, {8{1'b0}}};

    wire [15:0] sum1, sum2;

    ripple_carry_adder_16bit rca1 (.a(term_ll), .b(term_lh), .sum(sum1));
    ripple_carry_adder_16bit rca2 (.a(sum1), .b(term_hl), .sum(sum2));
    ripple_carry_adder_16bit rca3 (.a(sum2), .b(term_hh), .sum(p));
endmodule
