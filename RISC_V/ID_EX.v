module ID_EX(
	input	wire		clk,
	input	wire		Flush_EX,
	input	wire		Hazard,
    	input  	wire        	RegDst,
    	input  	wire        	ALUSrc,
    	input  	wire        	MemtoReg,
    	input  	wire        	RegWrite,
    	input  	wire        	MemRead,
    	input  	wire        	MemWrite,
    	input  	wire        	Branch,
	input  	wire        	Jump,
    	input  	wire 	[31:0] 	Read_data_1,
    	input  	wire 	[31:0] 	Read_data_2,
    	input  	wire 	[31:0] 	Immediate,
    	input  	wire 	[4:0]  	Rs,
    	input  	wire 	[4:0]  	Rt,
    	input  	wire 	[4:0]  	Rd,
	input  	wire 	[31:0] 	PC_in,
	input  	wire 	[5:0] 	funct_in,
	input	wire		ALUOp,

	output	reg		ALUOp_out,
	output 	reg  	[5:0] 	funct_out,
    	output 	reg         	RegDst_out,
    	output 	reg         	ALUSrc_out,
    	output 	reg         	MemtoReg_out,
    	output 	reg         	RegWrite_out,
    	output 	reg         	MemRead_out,
    	output 	reg         	MemWrite_out,
    	output 	reg         	Branch_out,
		output 	reg         	Jump_out,
    	output 	reg 	[31:0]  Read_data_1_out,
    	output 	reg 	[31:0]  Read_data_2_out,
    	output 	reg 	[31:0]  Immediate_out,
    	output 	reg 	[4:0]   Rs_out,
    	output 	reg 	[4:0]   Rt_out,
    	output 	reg 	[4:0]   Rd_out,
	output 	reg  	[31:0] 	PC_out
);
	
	always @(posedge clk) begin
		if(Hazard || Flush_EX) begin
			RegDst_out 	<= 1'b0;
			ALUSrc_out	<= 1'b0;
			MemtoReg_out	<= 1'b0;
			RegWrite_out	<= 1'b0;
			MemRead_out	<= 1'b0;
			Branch_out	<= 1'b0;
			Jump_out	<= 1'b0;
			Read_data_1_out	<= 32'b0;
			Read_data_2_out	<= 32'b0;
			Immediate_out	<= 32'b0;
			Rs_out		<= 5'b0;
			Rt_out		<= 5'b0;
			Rd_out		<= 5'b0;
			funct_out	<= 6'b0;
			ALUOp_out		<= 3'b0;
		end
		else begin
			RegDst_out 	<= RegDst;
			ALUSrc_out	<= ALUSrc;
			MemtoReg_out	<= MemtoReg;
			RegWrite_out	<= RegWrite;
			MemRead_out	<= MemRead;
			Branch_out	<= Branch;
			Jump_out	<= Jump;
			Read_data_1_out	<= Read_data_1;
			Read_data_2_out	<= Read_data_2;
			Immediate_out	<= Immediate;
			Rs_out		<= Rs;
			Rt_out		<= Rt;
			Rd_out		<= Rd;
			funct_out	<= funct_in;
			ALUOp_out	<= ALUOp;
		end
	end

endmodule