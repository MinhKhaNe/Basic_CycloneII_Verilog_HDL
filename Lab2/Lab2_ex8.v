module Lab2_ex8(SW,LEDG,LEDR,CLOCK_50);
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
    
	right_shift DUT(slow_clk,SW[0],SW[1],SW[2],LEDG[3:0]);
endmodule

module right_shift (
    input	wire clk,
    input	wire rst,
    input	wire in_value,
    input	wire enable,          
    output	reg [3:0] Q            
);

	always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 4'b0000;
        end 
        else if (enable) begin
            Q <= {in_value, Q[3:1]};
        end
	end
	
endmodule
