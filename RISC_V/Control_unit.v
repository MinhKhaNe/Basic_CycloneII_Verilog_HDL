module Control_unit(
    input  wire [31:0] Instruction,

    output wire RegDst,
    output wire Branch,
    output wire MemRead,
    output wire MemtoReg,
    output wire MemWrite,
    output wire ALUSrc,
    output wire RegWrite,
    output wire Jump
);

    // Opcode
    parameter R     = 6'b000000;
    parameter ADDI  = 6'b001000;
    parameter JMP   = 6'b000010;
    parameter BEQ   = 6'b000100;
    parameter LW    = 6'b100011;
    parameter SW    = 6'b101011;

    wire [5:0] opcode;
    assign opcode = Instruction[31:26];

    // Control signals
    assign RegDst   = (opcode == R);
    assign Branch   = (opcode == BEQ);
    assign MemRead  = (opcode == LW);
    assign MemtoReg = (opcode == LW);
    assign MemWrite = (opcode == SW);

    // I-type needs immediate
    assign ALUSrc = (opcode == LW)  ||
                     (opcode == SW)  ||
                     (opcode == ADDI);

    // Only these write registers
    assign RegWrite = (opcode == R)     ||
                      (opcode == LW)    ||
                      (opcode == ADDI);

    assign Jump = (opcode == JMP);

endmodule
