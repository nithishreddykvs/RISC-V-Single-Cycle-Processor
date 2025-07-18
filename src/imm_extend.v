//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// module name: imm_extend
//////////////////////////////////////////////////////////////////////////

module imm_extend(imm, extended_imm, imm_src);

    parameter SIZE = 32;

    // input port
    input [31:7] imm;                                                   // Input immediate value (25 bits)
    input [2:0] imm_src;                                                // Input source type (3 bits)

    // output port
    output reg [SIZE-1:0] extended_imm;                                 // Output extended immediate value (32 bits)

    // Select the immediate extension based on the instruction format
    always @(*) begin
        case (imm_src)
        // U-FORMAT-INSTRUCTIONS
            0: begin
                extended_imm = {imm[31:12],12'b0};
            end
        // J-FORMAT-INSTRUCTIONS
            1: begin
                extended_imm = {{12{imm[31]}}, imm[19:12], imm[20], imm[30:21], 1'b0};
            end
        // S-FORMAT-INSTRUCTIONS
            2: begin
                extended_imm = {{20{imm[31]}}, imm[31:25], imm[11:7]};
            end
        // B-FORMAT-INSTRUCTIONS
            3: begin
                extended_imm = {{20{imm[31]}}, imm[7], imm[30:25], imm[11:8], 1'b0};
            end
        // I-FORMAT-SIGNED-INSTRUCTIONS & JALR instruction
            4: begin
                extended_imm = {{20{imm[31]}}, imm[31:20]};
            end
        // I-FORMAT-SHIFT-INSTRUCTIONS
            5: begin
                extended_imm = {{27{imm[31]}}, imm[24:20]};
            end
        // I-FORMAT-UNSIGNED-INSTRUCTIONS
            6: begin
                extended_imm = {20'b0, imm[31:20]};
            end
            // Default case for invalid instruction format
            default: extended_imm = 32'hxxxxxxxx;
        endcase
    end

endmodule



