module ALU_control(
	input 	wire	[5:0]	funct,
	output	reg	[2:0]	ALU_op
);
	parameter	ADD 	= 6'b100000;
	parameter	SUB 	= 6'b100010;
	parameter	AND 	= 6'b100100;
	parameter	OR 	= 6'b100101;
	parameter	SLT	= 6'b101010;

	always @(*) begin
		case(funct)
			ADD:	ALU_op = 3'b010;
			SUB: 	ALU_op = 3'b110;
			AND:	ALU_op = 3'b000;
			OR: 	ALU_op = 3'b001;
			SLT: 	ALU_op = 3'b111;
		endcase
	end

endmodule