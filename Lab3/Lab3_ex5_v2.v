module Lab3_ex5_v2 (
    input  [17:0] SW,
    input  [1:0]  KEY,
    output [8:0]  LEDG,
    output [17:0] LEDR,
    output [6:0]  HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
    wire clk = KEY[1], clrn = KEY[0], we = SW[17], sel = SW[16];
    wire [7:0] A, B;
    wire [15:0] P1, P2, Sum;
    wire cout;
    
    assign LEDR = SW;

    wire [7:0] inA = SW[15:8];
    wire [7:0] inB = SW[7:0];

    dff8_we regA (.d(inA), .clk(clk), .we(we), .clrn(clrn), .q(A));
    dff8_we regB (.d(inB), .clk(clk), .we(we), .clrn(clrn), .q(B));

    array_multiplier_8bit mul1 (.a(A), .b(B), .clk(clk), .clrn(clrn), .p(P1));
    array_multiplier_8bit mul2 (.a(A), .b(B), .clk(clk), .clrn(clrn), .p(P2)); 

    carry_adder_subtqractor_16bit adder16 (.a(P1), .b(P2), .sub(sel), .sum(Sum), .cout(cout));

    wire [3:0] hex0 = Sum[3:0];
    wire [3:0] hex1 = Sum[7:4];
    wire [3:0] hex2 = Sum[11:8];
    wire [3:0] hex3 = Sum[15:12];

    hex7seg h0(hex0, HEX0);
    hex7seg h1(hex1, HEX1);
    hex7seg h2(hex2, HEX2);
    hex7seg h3(hex3, HEX3);
	hex7seg h4(SW[3:0], HEX4);
    hex7seg h5(SW[7:4], HEX5);
    hex7seg h6(SW[11:8], HEX6);
    hex7seg h7(SW[15:12], HEX7);
    
    assign LEDG[8] = cout;
endmodule

module full_adder(
    input  a,
    input  b,
    input  Cin,
    output Cout,
    output Sum
);
    assign Sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (b & Cin) | (a & Cin);
endmodule


module hex7seg(
    input  [3:0] hex,
    output reg [6:0] seg
);
    always @(*) begin
        case(hex)
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


// 8-bit registered multiplier
module array_multiplier_8bit (
    input [7:0] a, b,
    input clk, clrn,
    output reg [15:0] p
);
    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            p <= 16'h0;
        else
            p <= a * b;
    end
endmodule


// 8-bit register with write enable
module dff8_we(
    input [7:0] d,
    input clk,
    input we,
    input clrn,
    output reg [7:0] q
);
    always @(posedge clk or negedge clrn) begin
        if (!clrn)
            q <= 8'h0;
        else if (we)
            q <= d;
    end
endmodule


// 16-bit adder/subtractor using 8-bit full adders
module carry_adder_subtractor_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input  sub,
    output [15:0] sum,
    output cout
);
    wire [15:0] b_sub = b ^ {16{sub}};
    wire [15:0] C;

    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin: adder
            if (i == 0)
                full_adder fa(.a(a[i]), .b(b_sub[i]), .Cin(sub), .Sum(sum[i]), .Cout(C[i]));
            else if (i == 15)
                full_adder fa(.a(a[i]), .b(b_sub[i]), .Cin(C[i-1]), .Sum(sum[i]), .Cout(cout));
            else
                full_adder fa(.a(a[i]), .b(b_sub[i]), .Cin(C[i-1]), .Sum(sum[i]), .Cout(C[i]));
        end
    endgenerate
endmodule
