module Sign_extend (
	input 	wire	[15:0] sign_in,
	output 	wire	[31:0] sign_out

);
	assign sign_out[15:0]	=	sign_in[15:0];
	assign sign_out[31:16]	=	sign_in[15] ? {16{1'b1}} : 16'b0;

endmodule
