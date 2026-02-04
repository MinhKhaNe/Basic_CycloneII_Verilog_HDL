module ALU(
	input 	wire	[2:0] 	alufn, 		//ALU_op
	input 	wire	[31:0] 	ra,		//Read_data_1
	input 	wire	[31:0] 	rb_or_imm,	//Read_data_2
	output 	reg 	[31:0] 	aluout,
	output 	wire 		zero
);

	parameter	ALU_OP_ADD		= 3'b010;
	parameter	ALU_OP_SUB		= 3'b110;
	parameter	ALU_OP_AND		= 3'b000;
	parameter	ALU_OP_OR		= 3'b001;
	parameter	ALU_OP_SLT		= 3'b111;
	parameter	ALU_OP_NOR		= 3'b100;

	assign 	zero = (aluout == 32'h0) ? 1'b1 : 1'b0;
	
	always @(*) begin
		case(alufn)
			ALU_OP_ADD: begin
				aluout = ra + rb_or_imm;
			end
			ALU_OP_SUB: begin
				aluout = ra - rb_or_imm;
			end
			ALU_OP_AND: begin
				aluout = ra & rb_or_imm;
			end
			ALU_OP_OR: begin
				aluout = ra | rb_or_imm;
			end
			ALU_OP_NOR: begin 
				aluout = ~ (ra | rb_or_imm);
			end
			ALU_OP_SLT: begin
				aluout = (ra < rb_or_imm) ? 32'h1 : 32'h0;		
			end
		endcase
	end
endmodule