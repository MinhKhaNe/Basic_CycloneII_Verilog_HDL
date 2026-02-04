module MEM_WB(
	input  	wire 		clk,
    	input  	wire 		RegWrite,
    	input  	wire 		MemtoReg,
    	input  	wire 	[31:0] 	Read_data,
    	input  	wire 	[31:0] 	ALU_result,
    	input  	wire 	[4:0] 	Rd,

    	output 	reg  		RegWrite_out,
    	output 	reg  		MemtoReg_out,
    	output 	reg  	[31:0] 	Read_data_out,
    	output 	reg  	[31:0] 	ALU_result_out,
    	output 	reg  	[4:0] 	Rd_out
);

	always @(posedge clk) begin
            	RegWrite_out   <= RegWrite;
            	MemtoReg_out   <= MemtoReg;
            	Read_data_out  <= Read_data;
            	ALU_result_out <= ALU_result;
            	Rd_out         <= Rd;
    	end

endmodule