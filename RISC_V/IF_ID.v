module IF_ID(
	input  	wire        	clk,
    	input  	wire        	Flush,
	input 	wire		Hazard,
    	input  	wire 	[31:0] 	Instruction,
    	input  	wire 	[7:0]  	Address,

    	output 	reg  	[31:0] 	Instruction_out,
    	output 	reg  	[7:0]  	Address_out 
);

	always @(posedge clk) begin
        	if (Flush) begin
            		Instruction_out <= 32'b0;
            		Address_out     <= 8'b0;
        	end
		else if(Hazard) begin
			Instruction_out <= Instruction_out;
            		Address_out     <= Address_out;
		end
        	else begin
            		Instruction_out <= Instruction;
            		Address_out     <= Address;
        	end
    	end

endmodule