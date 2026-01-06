module Lab3_ex3(
    input  [11:0] SW,
    output [7:0] LEDG,
    output [11:0] LEDR,
    output [6:0]  HEX6, HEX4, HEX1, HEX0
);
    wire [7:0] p;
    
    assign LEDR[11:8] = SW[11:8];
    assign LEDR[3:0] = SW[3:0];
    
    assign LEDG = p;

    array_multiplier_4bit DUT (.a(SW[11:8]), .b(SW[3:0]), .p(p));

    hex7seg h6(SW[11:8], HEX6); //hex7seg h6(SW[9:8], HEX5);
    hex7seg h4(SW[3:0], HEX4); //hex7seg h6(SW[1:0], HEX5);
    hex7seg h1(p[7:4], HEX1);   hex7seg h0(p[3:0], HEX0);
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
