module PC(
	input 	wire		clk, 
	input	wire		reset,
	input	wire		enable,
	input 	wire	[7:0] 	PC_in,
	output 	reg		[7:0] 	PC_out
);

	always @ (posedge clk or posedge reset)	begin
		if(reset)
			PC_out <= 8'b0;
		else if (enable)
			PC_out <= PC_in;
		else 
			PC_out <= PC_out;
	end
endmodule
