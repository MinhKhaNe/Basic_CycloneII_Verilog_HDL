module Forwarding_unit(
	input  	wire        	EX_MEM_RegWrite,
    	input  	wire 	[4:0]  	EX_MEM_Rd,
    	input  	wire        	MEM_WB_RegWrite,
    	input  	wire 	[4:0]  	MEM_WB_Rd,
    	input  	wire 	[4:0]  	ID_EX_Rs,
    	input  	wire 	[4:0]  	ID_EX_Rt,

	output	wire	[1:0]	Forwarding_A,
	output	wire	[1:0]	Forwarding_B
);

	assign Forwarding_A 	= (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs)) ? 2'b01 :
				  (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && !(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs)) && (MEM_WB_Rd == ID_EX_Rs)) ? 2'b10 : 
				   2'b00;

	assign Forwarding_B 	= (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rt)) ? 2'b01 :
				  (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && !(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rt)) && (MEM_WB_Rd == ID_EX_Rt)) ? 2'b10 : 
				   2'b00;
endmodule