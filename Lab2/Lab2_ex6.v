module Lab2_ex6(CLOCK_50, SW, LEDG, LEDR);
    input  [17:0] SW;
    input         CLOCK_50;
    output [7:0]  LEDG;
    output [17:0] LEDR;
    
    assign LEDR = SW;
    
    syn_counter DUT (
        .clk(CLOCK_50),
        .rst_n(SW[0]),
        .Q(LEDG[3:0])
    );
endmodule

module syn_counter(
    input  wire       clk,
    input  wire       rst_n,
    output reg  [3:0] Q
);

    reg [25:0] count;  

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 26'd0;
            Q     <= 4'b0000;
        end else begin
            if (count == 26'd49_999_999) begin
                count <= 26'd0;
                Q <= Q + 4'b0001;  
            end else begin
                count <= count + 26'd1;
            end
        end
    end

endmodule
