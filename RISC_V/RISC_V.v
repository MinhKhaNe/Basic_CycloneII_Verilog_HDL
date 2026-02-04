module Risc_V(
	input	wire		clk,
	input	wire		reset,
	output wire [4:0] dbg_rd,
    output wire [31:0] dbg_wdata,
    output wire dbg_regwrite,
    output wire [31:0] dbg_instruction,
    output	wire	[31:0]	dbg_result
	
);

	wire			RegWrite, RegWrite_ID, MemRead, MemWrite, Zero, RegDst, Branch, MemtoReg, ALUSrc, Jump, Flush, Flush_ID, Flush_EX;			//IF_ID
	wire			RegWrite_out, MemRead_out, MemWrite_out, RegDst_out, Branch_out, MemtoReg_out, ALUSrc_out, Jump_out, Hazard;			//ID_EX
	wire			RegWrite_out_1, MemRead_out_1, MemWrite_out_1, RegDst_out_1, Branch_out_1, MemtoReg_out_1, ALUSrc_out_1, Jump_out_1, Zero_1;	//EX_MEM
	wire	[7:0]	Read_address, Address_out, out1, ALU_result1;
	wire	[31:0]	Instruction, Instruction_out, Read_data_1, Read_data_2, Read_data_1_out, Read_data_2_out,Read_data_22, Write_data, Sign_out, ALU_result, ALU_result_1, Read_data, ALU_2_1;
	wire	[4:0]	Write_register, Rs, Rt, Rd, Rs_out, Rt_out, Rd_out, Rd_out_1;
	wire	[2:0]	ALU_op, ALU_op_out;
	wire	[1:0]	Forwarding_A, Forwarding_B;	
	wire 	[31:0] 	PC;
	wire 	[31:0] 	PC_plus4;
	wire 	[31:0] 	PC_plus4_out;
	wire 	[31:0] 	PC_next;
	wire 	[31:0] 	PC_IDEX;
	wire 	[31:0] 	PC_branch_EX;
	wire 	[31:0] 	PC_branch_MEM;
	wire 	[31:0] 	PC_jump;
	wire        	PCSrc;
	wire 			RegWrite_WB, MemtoReg_WB;
	wire 	[31:0] 	Read_data_WB, ALU_result_WB;
	wire 	[4:0]  	Rd_out_WB, Rd_EX;
	wire 	[31:0] 	Immediate, Immediate_out;
	wire 	[31:0] 	ALU_2_final;
	wire	[5:0]	funct_out;

	reg	[31:0]	ALU_1, ALU_2;
	
	assign ALU_2_final 	= ALUSrc_out ? Immediate_out : ALU_2;
	assign PC_plus4 	= PC + 32'h0000_0004;
	assign PC_branch_EX 	= PC_IDEX + (Immediate_out << 2);
	assign PCSrc 		= Branch_out_1 & Zero_1;
	assign PC_next 		= Jump_out  ? PC_jump :
                 		  PCSrc ? PC_branch_MEM :
                 		  PC_plus4;
	assign Write_register 	= Rd_out_WB; 
	assign Write_data 	= MemtoReg_WB ? Read_data_WB : ALU_result_WB;
	assign RegWrite       	= RegWrite_WB;
	assign Immediate	= Sign_out;
	assign Rd_EX		= RegDst_out ? Rd_out : Rt_out;
	assign Flush_ID 	= Jump;
	assign Flush_EX 	= PCSrc;
	assign Flush 		= Flush_ID | Flush_EX;
	assign PC_jump 		= {PC_plus4_out[31:28], Instruction_out[25:0], 2'b00};
	assign Rs 		= Instruction_out[25:21];
	assign Rt 		= Instruction_out[20:16];
	assign Rd 		= Instruction_out[15:11];

	Instruction_memory IM0 (.Read_address(PC[9:2]), .Instruction(Instruction));

	IF_ID IF0 (.clk(clk), .Flush(Flush), .Hazard(Hazard), .Instruction(Instruction), .Address(PC_plus4), .Instruction_out(Instruction_out), .Address_out(PC_plus4_out));

	Control_unit CU0 (.Instruction(Instruction_out), .RegWrite(RegWrite_ID), .MemRead(MemRead), .MemWrite(MemWrite), .RegDst(RegDst), .Branch(Branch), .MemtoReg(MemtoReg), .ALUSrc(ALUSrc), .Jump(Jump));

	Hazard_detection_unit HDU0 (.ID_EX_MemRead(MemRead_out), .ID_EX_Rt(Rt_out), .IF_ID_Rs(Instruction_out[25:21]), .IF_ID_Rt(Instruction_out[20:16]), .Hazard(Hazard));

	Registers R0 (.Read_register_1(Instruction_out[25:21]), .Read_register_2(Instruction_out[20:16]), .Write_register(Write_register), .Read_data_1(Read_data_1), .Read_data_2(Read_data_2), .Write_data(Write_data), .RegWrite(RegWrite_WB), .clk(clk), .reset(reset));	
	
	ALU_control AC0 (.funct(funct_out), .ALU_op(ALU_op));

	ID_EX ID0 (.clk(clk), .Flush_EX(Flush_EX), .Hazard(Hazard) ,.RegDst(RegDst) , .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite_ID), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .Jump(Jump), .Read_data_1(Read_data_1), .Read_data_2(Read_data_2), .Immediate(Immediate), .Rs(Rs) , .Rt(Rt), .Rd(Rd), .PC_in(PC_plus4_out), .funct_in(Instruction_out[5:0]), .ALUOp(ALU_op), .ALUOp_out(ALU_op_out), .funct_out(funct_out), .RegDst_out(RegDst_out) , .ALUSrc_out(ALUSrc_out), .MemtoReg_out(MemtoReg_out), .RegWrite_out(RegWrite_out), .MemRead_out(MemRead_out), .MemWrite_out(MemWrite_out), .Branch_out(Branch_out), .Jump_out(Jump_out), .Read_data_1_out(Read_data_1_out), .Read_data_2_out(Read_data_2_out), .Immediate_out(Immediate_out), .Rs_out(Rs_out) , .Rt_out(Rt_out), .Rd_out(Rd_out), .PC_out(PC_IDEX));

	Sign_extend SE0 (.sign_in(Instruction_out[15:0]), .sign_out(Sign_out));
	
	Forwarding_unit FU0 (.EX_MEM_RegWrite(RegWrite_out_1), .EX_MEM_Rd(Rd_out_1), .MEM_WB_RegWrite(RegWrite_WB), .MEM_WB_Rd(Rd_out_WB), .ID_EX_Rs(Rs_out), .ID_EX_Rt(Rt_out), .Forwarding_A(Forwarding_A), .Forwarding_B(Forwarding_B));	

	ALU A0 (.alufn(ALU_op_out), .ra(ALU_1), .rb_or_imm(ALU_2_final), .aluout(ALU_result), .zero(Zero));

	EX_MEM EM0 (.clk(clk), .RegWrite(RegWrite_out), .MemRead(MemRead_out), .MemWrite(MemWrite_out), .MemtoReg(MemtoReg_out), .Branch(Branch_out), .ALU_result(ALU_result), .Mux2(ALU_2), .Zero(Zero), .Pc_branch(PC_branch_EX) , .Rd(Rd_EX), .RegWrite_out(RegWrite_out_1), .MemRead_out(MemRead_out_1), .MemWrite_out(MemWrite_out_1), .MemtoReg_out(MemtoReg_out_1), .Branch_out(Branch_out_1), .ALU_result_out(ALU_result_1), .Mux2_out(ALU_2_1), .Zero_out(Zero_1), .Pc_branch_out(PC_branch_MEM) , .Rd_out(Rd_out_1));	

	Data_memory(.clk(clk), .reset(reset), .MemRead(MemRead_out_1), .MemWrite(MemWrite_out_1), .Address(ALU_result_1), .Write_data(ALU_2_1), .Read_data(Read_data));	

	MEM_WB MW0 (.clk(clk), .RegWrite(RegWrite_out_1), .MemtoReg(MemtoReg_out_1), .Read_data(Read_data), .ALU_result(ALU_result_1), .Rd(Rd_out_1), .RegWrite_out(RegWrite_WB), .MemtoReg_out(MemtoReg_WB), .Read_data_out(Read_data_WB),.ALU_result_out(ALU_result_WB), .Rd_out(Rd_out_WB));

	PC PC0 (.clk(clk), .reset(reset), .enable(~Hazard), .PC_in(PC_next), .PC_out(PC));

	//Add ADD0 (.input1(Address_out), .input2(8'b0000_0001), .out(out1));

	//Add ADD1 (.input1(out1), .input2((Sign_out << 2)), .out(ALU_result1));
	
	//Mux1 Before ALU
	always @(*) begin
		if(Forwarding_A == 2'b01)
			ALU_1 = ALU_result_1;
		else if(Forwarding_A == 2'b10)
			ALU_1 = Write_data;
		else
			ALU_1 = Read_data_1_out;
	end

	//Mux2 Before ALU
	always @(*) begin
		if(Forwarding_B == 2'b01)  
			ALU_2 = ALU_result_1;
		else if(Forwarding_B == 2'b10)  
			ALU_2 = Write_data;
		else
			ALU_2 = Read_data_2_out;

	end

endmodule
