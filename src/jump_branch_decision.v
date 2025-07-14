//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// module name: jump_branch_decision
//////////////////////////////////////////////////////////////////////////

module jump_branch_decision(operand_1, operand_2, zero, neg, less_than, jump_branch, pc_src);

    parameter SIZE = 32;

    // input port   
    input [SIZE-1:0] operand_1, operand_2;                 // Input operands (32 bits each)
    input [2:0] jump_branch;                               // Jump or branch signal (3 bits)
    
    // output port
    output reg pc_src;                                     // Output PC source (1 bits)
    output zero, neg, less_than;                           // Zero and negative and less than flags
    
    // Always block to decide the PC source
    always @(*) begin
        if (jump_branch == 3'b010) begin
            pc_src <= 0; // PC source is the incremented PC
        end else if (jump_branch == 3'b011) begin
            pc_src <= 1; // PC source is the jump target address
        end else begin
            case (jump_branch)
                3'b000: pc_src <= (zero) ? 1 : 0; // BEQ
                3'b001: pc_src <= (!zero) ? 1 : 0; // BNE
                3'b100: pc_src <= (neg) ? 1 : 0; // BLT
                3'b101: pc_src <= (!neg || zero) ? 1 : 0; // BGE
                3'b110: pc_src <= (less_than) ? 1 : 0; // BLTU
                3'b111: pc_src <= (!less_than || zero) ? 1 : 0; // BGEU
                default: pc_src <= 0; // Default case
            endcase
        end
    end

    // Zero flag is high if result is zero
    assign zero = (operand_1 - operand_2 == 0);

    // Negative flag is high if result is negative
    assign neg = (operand_1 < operand_2);

    // UNSIGNED LESS THAN FLAG
    assign less_than = ($unsigned(operand_1) < $unsigned(operand_2));

endmodule









