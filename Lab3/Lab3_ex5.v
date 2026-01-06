module Lab3_ex5 (
    input  [17:0] SW,
    input  [1:0]  KEY,
    output [8:0]  LEDG,
    output [6:0]  HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
    wire clk = KEY[1], clrn = KEY[0], we = SW[17], sel = SW[16];
    wire [7:0] A, B, C, D, inA, inB;
    wire [15:0] P1, P2, Sum;
    wire cout;

    assign inA = sel ? SW[15:8] : SW[15:8];
    assign inB = sel ? SW[7:0]  : SW[7:0];

    dff8_we regA (.d(inA), .clk(clk), .we(we), .clrn(clrn), .q(A));
    dff8_we regB (.d(inB), .clk(clk), .we(we), .clrn(clrn), .q(B));

    array_multiplier_8bit mul1 (.a(A), .b(B), .clk(clk), .clrn(clrn), .p(P1));
    array_multiplier_8bit mul2 (.a(C), .b(D), .clk(clk), .clrn(clrn), .p(P2));

    carry_adder_subtractor_8bit adder16 (.a(P1), .b(P2), .sub(1'b0), .sum(Sum), .cout(cout));

    dff16 regSum (.d(Sum), .clk(clk), .clrn(clrn), .q({HEX3,HEX2,HEX1,HEX0}));
    assign LEDG[8] = cout;
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

module array_multiplier_8bit (
    input  [7:0] a, b,
    input        clk, clrn,
    output reg [15:0] p
);
    wire [15:0] p_comb;

    assign p_comb = a * b;  

    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            p <= 16'h0;
        else
            p <= p_comb;
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

module dff8_we(
    input  wire [7:0] d,
    input  wire        clk,
    input  wire        we,
    input  wire        clrn,
    output reg  [7:0] q
);
    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            q <= 8'h0;
        else if(we)
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

module carry_adder_subtractor_8bit(
	input 	wire	[7:0]	a,
	input	wire	[7:0]	b,
	input	wire			sub,
	output	wire	[7:0]	sum,
	output	wire			cout
);

	wire [7:0] C;
	wire [7:0] b_sub;
	
	assign b_sub	= b ^ {8{sub}};

	full_adder fa0(.a(a[0]),.b(b_sub[0]),.Cin(sub),.Sum(sum[0]),.Cout(C[0]));
	full_adder fa1(.a(a[1]),.b(b_sub[1]),.Cin(C[0]),.Sum(sum[1]),.Cout(C[1]));
	full_adder fa2(.a(a[2]),.b(b_sub[2]),.Cin(C[1]),.Sum(sum[2]),.Cout(C[2]));
	full_adder fa3(.a(a[3]),.b(b_sub[3]),.Cin(C[2]),.Sum(sum[3]),.Cout(C[3]));
	full_adder fa4(.a(a[4]),.b(b_sub[4]),.Cin(C[3]),.Sum(sum[4]),.Cout(C[4]));
	full_adder fa5(.a(a[5]),.b(b_sub[5]),.Cin(C[4]),.Sum(sum[5]),.Cout(C[5]));
	full_adder fa6(.a(a[6]),.b(b_sub[6]),.Cin(C[5]),.Sum(sum[6]),.Cout(C[6]));
	full_adder fa7(.a(a[7]),.b(b_sub[7]),.Cin(C[6]),.Sum(sum[7]),.Cout(cout));

endmodule
