module Lab3_ex2(
	input  [17:0] SW,
    input  [1:0]  KEY,
    output [17:0]  LEDR,
    output [8:0]  LEDG,
    output [6:0]  HEX7, HEX6, HEX5, HEX4, HEX1, HEX0
);
    wire clk = KEY[1], reset_n = KEY[0], sub = SW[16];
    wire [7:0] A_reg, B_reg, S_reg;
    wire cout, overflow;

    dff8 regA (.d(SW[15:8]), .clk(clk), .clrn(reset_n), .q(A_reg));	//SW[15:8] : input a
    dff8 regB (.d(SW[7:0]),  .clk(clk), .clrn(reset_n), .q(B_reg)); //SW[7:0] : input b

    carry_adder_subtractor_8bit DUT (.a(A_reg), .b(B_reg), .SUB(sub), .Carry(cout), .overflow(overflow), .Sum(S_reg));

    dff8 regS (.d(S_reg), .clk(clk), .clrn(reset_n), .q(LEDR[7:0])); 
    
    assign LEDG[8] = overflow;
    assign LEDR[16] = sub;
    
    hex7seg h7(SW[15:12], HEX7); hex7seg h6(SW[11:8], HEX6);
    hex7seg h5(SW[7:4],   HEX5); hex7seg h4(SW[3:0],  HEX4);
    //hex7seg h3(LEDR[7:6], HEX3); hex7seg h2(LEDR[5:4], HEX2);
    hex7seg h1(LEDR[7:4], HEX1); hex7seg h0(LEDR[3:0], HEX0);
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

module carry_adder_subtractor_8bit(
	input 	wire	[7:0]	a,
	input	wire	[7:0]	b,
	input	wire			SUB,
	output	wire			Carry,
	output 	wire			overflow,
	output	wire	[7:0]	Sum
);

	wire [7:0] C;
	wire [7:0] b_sub;
	
	assign b_sub	= b ^ {8{SUB}};

	full_adder fa0(.a(a[0]),.b(b_sub[0]),.Cin(SUB),.Cout(C[0]),.Sum(Sum[0]));
	full_adder fa1(.a(a[1]),.b(b_sub[1]),.Cin(C[0]),.Cout(C[1]),.Sum(Sum[1]));
	full_adder fa2(.a(a[2]),.b(b_sub[2]),.Cin(C[1]),.Cout(C[2]),.Sum(Sum[2]));
	full_adder fa3(.a(a[3]),.b(b_sub[3]),.Cin(C[2]),.Cout(C[3]),.Sum(Sum[3]));
	full_adder fa4(.a(a[4]),.b(b_sub[4]),.Cin(C[3]),.Cout(C[4]),.Sum(Sum[4]));
	full_adder fa5(.a(a[5]),.b(b_sub[5]),.Cin(C[4]),.Cout(C[5]),.Sum(Sum[5]));
	full_adder fa6(.a(a[6]),.b(b_sub[6]),.Cin(C[5]),.Cout(C[6]),.Sum(Sum[6]));
	full_adder fa7(.a(a[7]),.b(b_sub[7]),.Cin(C[6]),.Cout(Carry),.Sum(Sum[7]));
	
	assign overflow = (a[7] & b_sub[7] & ~Sum[7]) | (~a[7] & ~b_sub[7] & Sum[7]); 

endmodule

module dff8(
    input  wire [7:0] d,
    input  wire       clk,
    input  wire       clrn,
    output reg  [7:0] q
);
    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            q <= 8'h0;       
        else
            q <= d;         
    end
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

