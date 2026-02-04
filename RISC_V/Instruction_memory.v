module Instruction_memory (
    input  wire [7:0]  Read_address,
    output reg  [31:0] Instruction
);

    always @(*) begin
        case (Read_address)

            // ===== INIT =====
          //  8'd0: Instruction = 32'h20080005; // addi $t0, $zero, 5
          //  8'd1: Instruction = 32'h20090003; // addi $t1, $zero, 3

            // ===== ALU =====
           // 8'd2: Instruction = 32'h01095020; // add  $t2, $t0, $t1  (8)
           // 8'd3: Instruction = 32'h01495822; // sub  $t3, $t2, $t1  (5)
           // 8'd4: Instruction = 32'h01096024; // and  $t4, $t0, $t1  (1)
           // 8'd5: Instruction = 32'h01096825; // or   $t5, $t0, $t1  (7)
           // 8'd6: Instruction = 32'h0128702A; // slt  $t6, $t1, $t0  (1)

            // ===== LOOP =====
           // 8'd7: Instruction = 32'h21EF0001; // addi $t7, $t7, 1
           // 8'd8: Instruction = 32'h08000007; // j 7

			 // ===== LOAD-USE HAZARD TEST =====
            8'd0: Instruction = 32'h8C080000; // lw  t0, 0(t0)
            8'd1: Instruction = 32'h01084820; // add t1, t0, t0  <-- HAZARD
            8'd2: Instruction = 32'h01085020; // add t2, t0, t0

            // ===== LOOP =====
            8'd3: Instruction = 32'h08000001; // j 
			
            default: Instruction = 32'h00000000; // nop
        endcase
    end
endmodule
