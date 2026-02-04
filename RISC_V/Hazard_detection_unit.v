module Hazard_detection_unit(
	input  wire        	ID_EX_MemRead,  
    	input  wire 	[4:0]  	ID_EX_Rt,        
    	input  wire 	[4:0]  	IF_ID_Rs,        
    	input  wire 	[4:0]  	IF_ID_Rt,   
       
	output	wire		Hazard
);

	assign Hazard = ID_EX_MemRead && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt));

endmodule