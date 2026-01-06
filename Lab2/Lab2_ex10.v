module Lab2_ex10(SW,LEDG,LEDR,CLOCK_50);
	input[17:0] SW;
	input CLOCK_50;
	output[7:0] LEDG;
	output[17:0] LEDR;
	assign LEDR=SW;
	reg [25:0] count;
    reg slow_clk;

    always @(posedge CLOCK_50 or posedge SW[0]) begin
        if (SW[0]) begin
            count    <= 0;
            slow_clk <= 0;
        end 
        else begin
            if (count == 49_999_999 - 1) begin
                count    <= 0;
                slow_clk <= ~slow_clk; 
            end 
            else begin
                count <= count + 1;
            end
        end
    end
    
	 universal_shift_register #(.N(4)) DUT(slow_clk,SW[0],SW[2:1],SW[3],SW[4],SW[8:5],LEDG[3:0],LEDG[4],LEDG[5]);
endmodule


module universal_shift_register #(
	parameter N = 8
)(
	input	wire			clk,
	input	wire			rst_n,
	input	wire	[1:0]	S,
	input	wire			sl_in,
	input	wire			sr_in,
	input	wire	[N-1:0]	p_din,
	output	reg		[N-1:0]	p_dout,	
	output	reg				sr_out,
	output	reg				sl_out
);

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			p_dout <= {N{1'b0}}; 
		end
		else begin
			case(S)
				2'b00: begin
				 	p_dout <= p_dout;
				end
				2'b01: begin
					sr_out <= p_dout[0];
				 	p_dout <= {sr_in, p_dout[N-1:1]};
				end
				2'b10:	begin
					 sl_out <= p_dout[N-1];
					p_dout <= {p_dout[N-2:0], sl_in};
				end
				2'b11: 	begin
					p_dout <= p_din;
				end
			endcase
		end
	end	

endmodule

