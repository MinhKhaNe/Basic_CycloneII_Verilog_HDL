module Registers (
	input 	wire		clk, 
	input	wire		reset,
	input	wire		RegWrite,
	input 	wire	[4:0] 	Read_register_1, 
	input 	wire	[4:0]	Read_register_2, 
	input 	wire	[4:0]	Write_register,
	input 	wire	[31:0] 	Write_data,
	output 	wire	[31:0] 	Read_data_1, 
	output 	wire	[31:0]	Read_data_2
);

	reg [31:0] Regfile [1024:0];
	integer k;
	
	assign Read_data_1 = Regfile[Read_register_1];
    	assign Read_data_2 = Regfile[Read_register_2];

	always @(posedge clk or posedge reset) begin
		if (reset==1'b1)begin
			for (k=0; k<8; k=k+1) begin
				Regfile[k] = 8'b0;
			end
		end 
		else if (RegWrite == 1'b1) begin
			Regfile[Write_register] = Write_data; 
		end
	end


endmodule