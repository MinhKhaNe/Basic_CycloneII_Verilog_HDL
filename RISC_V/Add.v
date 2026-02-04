module Add(
 	input 	wire	[7:0] 	input1, 
	input 	wire	[7:0]	input2,
 	output 	reg	[7:0] 	out;
);
 	
	always@( input1 or input2) begin
 		out  <= input1 + input2;
 	end

endmodule
