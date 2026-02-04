module Data_memory (
	input	wire		clk, 
	input	wire		reset, 
	input	wire		MemRead,
	input	wire		MemWrite,
	input 	wire	[31:0] 	Address,
	input 	wire	[31:0] 	Write_data,
	output 	wire	[31:0] 	Read_data
);

	reg [31:0] DMemory [1024:0];
	integer k;
	
	assign Read_data = (MemRead) ? DMemory[Address] : 32'bx;

	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			for (k=0; k<32; k=k+1) begin
			        DMemory[k] = 32'b0;
			end
		end
		else begin
			if (MemWrite) DMemory[Address] = Write_data;
		end
	end
endmodule