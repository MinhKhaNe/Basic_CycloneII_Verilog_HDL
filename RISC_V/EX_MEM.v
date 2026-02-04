module EX_MEM(
	input  	wire        	clk,
    	input  	wire        	RegWrite,
    	input  	wire        	MemRead,
    	input  	wire        	MemWrite,
    	input  	wire        	MemtoReg,
    	input  	wire        	Branch,
    	input  	wire 	[31:0] 	ALU_result,
    	input  	wire 	[31:0] 	Mux2,
    	input  	wire        	Zero,
    	input  	wire 	[31:0] 	Pc_branch,
    	input  	wire 	[4:0]  	Rd,

    	output 	reg         	RegWrite_out,
    	output 	reg         	MemRead_out,
    	output 	reg         	MemWrite_out,
    	output 	reg         	MemtoReg_out,
    	output 	reg         	Branch_out,
    	output 	reg 	[31:0]  ALU_result_out,
    	output 	reg 	[31:0]  Mux2_out,
    	output 	reg         	Zero_out,
    	output 	reg 	[31:0]  Pc_branch_out,
    	output 	reg 	[4:0]   Rd_out
);

	always @(posedge clk) begin
       		RegWrite_out   	<= RegWrite;
       		MemRead_out    	<= MemRead;
        	MemWrite_out   	<= MemWrite;
        	MemtoReg_out   	<= MemtoReg;
        	Branch_out     	<= Branch;
        	ALU_result_out 	<= ALU_result;
        	Mux2_out   	<= Mux2;
        	Zero_out       	<= Zero;
        	Pc_branch_out  	<= Pc_branch;
        	Rd_out         	<= Rd;
	end

endmodule