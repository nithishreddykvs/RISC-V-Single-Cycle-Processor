//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// Module-Name: control_unit
//////////////////////////////////////////////////////////////////////////

module control_unit(op, funct3, funct7, jump_branch, result_src, mem_write, alu_control, alu_src, imm_src, reg_write, data_size, extension_type);

    // input port
    input [6:0] op;                                                      // Input opcode (7 bits)
    input [6:0] funct7;                                                  // Input funct7 (7 bits)
    input [2:0] funct3;                                                  // Input funct3 (3 bits)

    // output port
    output reg [4:0] alu_control;                                      // Output ALU control (4 bits)
    output reg [2:0] imm_src;                                          // Output immediate source (3 bits)
    output reg [1:0] result_src;                                       // Output result source (2 bits)
    output reg [1:0] alu_src;                                          // Output ALU source (2 bits)
    output reg [2:0] jump_branch;                                      // Output jump branch (3 bits)
    output reg [1:0] data_size;                                        // Output data size (2 bits)
    output reg extension_type;                                         // Output extension type (1 bits)
    output reg mem_write;                                              // Output memory write (1 bits)
    output reg reg_write;                                              // Output register write (1 bits)

    // Always block to determine the control signals based on the opcode and funct3 and funct7

    always @(*) begin

        //alu_control
            case (op)
                // R-FORMAT-INSTRUCTIONS
                    7'b0110011: case ({funct7, funct3})
                        10'b0000000000: alu_control <= 5'b00000;        // ADD
                        10'b0100000000: alu_control <= 5'b00010;        // SUB
                        10'b0000000001: alu_control <= 5'b00100;        // SLL
                        10'b0000000010: alu_control <= 5'b01000;        // SLT
                        10'b0000000011: alu_control <= 5'b01100;        // SLTU
                        10'b0000000100: alu_control <= 5'b10000;        // XOR
                        10'b0000000101: alu_control <= 5'b10100;        // SRL
                        10'b0100000101: alu_control <= 5'b10110;        // SRA
                        10'b0000000110: alu_control <= 5'b11000;        // OR
                        10'b0000000111: alu_control <= 5'b11100;        // AND
                        default: alu_control <= 5'b00000;               // Default case
                    endcase
                // I-FORMAT-INSTRUCTIONS
                    7'b0010011: case (funct3)
                        3'b000: alu_control <= 5'b00000;                // ADDI
                        3'b001: alu_control <= 5'b00100;                // SLLI
                        3'b010: alu_control <= 5'b01000;                // SLTI
                        3'b011: alu_control <= 5'b01100;                // SLTIU
                        3'b100: alu_control <= 5'b10000;                // XORI
                        3'b110: alu_control <= 5'b11000;                // ORI
                        3'b111: alu_control <= 5'b11100;                // ANDI
                        3'b101: case (funct7)
                            7'b0000000: alu_control <= 5'b10100;        // SRLI
                            7'b0100000: alu_control <= 5'b10110;        // SRAI
                            default: alu_control <= 5'b00000;           // Default case
                        endcase
                        default: alu_control <= 5'b00000;               // Default case
                    endcase

                // LOAD-INSTRUCTIONS
                    7'b0000011: alu_control = 5'b00000;                              // ADD
                // S-FORMAT-INSTRUCTIONS
                    7'b0100011: alu_control = 5'b00000;                              // ADD
                // J-FORMAT-INSTRUCTIONS
                    7'b1101111, 7'b1100111: alu_control <= 5'b00000;                 // ADD
                // U-FORMAT-INSTRUCTIONS
                    7'b0010111, 7'b0110111: alu_control = 5'b00000;                  // ADD
                // B-FORMAT-INSTRUCTIONS
                    7'b1100011: alu_control <= 5'b00000;                             // ADD
                // PAUSE INSTURCTION
                    7'b0001111: alu_control = 5'b00000;                              // ADD
                default: alu_control = 4'b0000;
            endcase

        //imm_src
            case (op)
                // I-FORMAT-SIGNED-INSTRUCTIONS & JALR instruction
                    7'b0010011, 7'b0000011, 7'b1100111: imm_src <= 3'b100;
                // S-FORMAT-INSTRUCTIONS
                    7'b0100011: imm_src <= 3'b010;
                // B-FORMAT-INSTRUCTIONS
                    7'b1100011: imm_src <= 3'b011;
                // U-FORMAT-INSTRUCTIONS
                    7'b0110111, 7'b0010111: imm_src <= 3'b000;
                // JAL-INSTRUCTION
                    7'b1101111: imm_src <= 3'b001;
                // I-FORMAT-SHIFT-INSTRUCTIONS
                    7'b0010011: imm_src <= 3'b101;
                // I-FORMAT-UNSIGNED-INSTRUCTIONS
                    7'b0010011: imm_src <= 3'b110;
                default: imm_src <= 3'b000;
            endcase

        //result_src
            case (op)
                // I-FORMAT-ARITHMATIC-INSTRUCTIONS & R-FORMAT-INSTRUCTIONS & AUIPC-INSTRUCTION
                    7'b0010011, 7'b0110011, 7'b0010111: result_src <= 2'b00;
                // I-FORMAT-LOAD-INSTRUCTIONS
                    7'b0000011: result_src <= 2'b01;
                // JAL-INSTURCTION & JALR-INSTURCTION
                    7'b1101111, 7'b1100111: result_src <= 2'b10;
                // LUI-INSTRUCTION
                    7'b0110111: result_src <= 2'b11;
                default: result_src <= 2'b00;
            endcase

            //alu_src
            case (op)
                // R-FORMAT-INSTRUCTIONS
                    7'b0110011: alu_src <= 2'b00;
                // I-FORMAT-INSTRUCTIONS & S-FORMAT-INSTRUCTIONS & //JALR-INSTRUCTION
                    7'b0000011, 7'b0010011, 7'b0100011, 7'b1100111: alu_src <= 2'b01;
                // B-FORMAT-INSTRUCTIONS & JAL-INSTRUCTION & AUIPC-INSTRUCTION
                    7'b1101111, 7'b1100011, 7'b0010111: alu_src <= 2'b11;
                default: alu_src <= 2'b00;
            endcase

            //jump_branch
            case (op)
                // JAL-INSTRUCTION & JALR-INSTRUCTION
                    7'b1101111, 7'b1100111: jump_branch <= 3'b011; // J
                // B-FORMAT-INSTRUCTIONS
                    7'b1100011: case (funct3)
                        3'b000: jump_branch <= 3'b000; // BEQ
                        3'b001: jump_branch <= 3'b001; // BNE
                        3'b100: jump_branch <= 3'b100; // BLT
                        3'b101: jump_branch <= 3'b101; // BGE
                        3'b110: jump_branch <= 3'b110; // BLTU
                        3'b111: jump_branch <= 3'b111; // BGEU
                        default: jump_branch <= 3'b010; // NO
                    endcase
                default: jump_branch <= 3'b010; // NO
            endcase

            //data_size
            case (op)
                7'b0000011: case (funct3)
                    3'b000: data_size <= 2'b00; // LB
                    3'b001: data_size <= 2'b01; // LH
                    3'b010: data_size <= 2'b10; // LW
                    3'b100: data_size <= 2'b00; // LBU
                    3'b101: data_size <= 2'b01; // LHU 
                    default: data_size <= 2'b00; // Default case 
                endcase
                7'b0100011: case (funct3)
                    3'b000: data_size <= 2'b00; // SB
                    3'b001: data_size <= 2'b01; // SH
                    3'b010: data_size <= 2'b10; // SW
                endcase
                default: data_size <= 2'b00; // Default case
            endcase

            //extension_type
            case (op)
                7'b0000011: case (funct3)
                    3'b000, 3'b001 : extension_type <= 1'b0; // LB, LH
                    3'b100, 3'b101 : extension_type <= 1'b1; // LBU, LHU
                    default: extension_type <= 1'b0; // Default case 
                endcase
                default: extension_type <= 1'b0; // Default case
            endcase

        //mem_write
            case (op)
                // S-FORMAT-INSTRUCTIONS
                    7'b0100011: mem_write <= 1'b1;
                default: mem_write <= 1'b0;
            endcase

        

        //reg_write
            case (op)
                // I-FORMAT-INSTRUCTIONS & R-FORMAT-INSTRUCTIONS & JAL-INSTURCTION & JALR-INSTURCTION & AUIPC-INSTRUCTION
                    7'b0000011, 7'b0010011, 7'b0110011, 7'b1101111, 7'b1100111, 7'b0010111 : reg_write <= 1'b1;
                default: reg_write <= 1'b0;
            endcase
    end

endmodule