module top(clk, rst, alu_result);

    // input port
    input clk;                                                          // Clock signal
    input rst;                                                          // reset signal

    // wire declaration
    wire [31:0] instruction;                                            // Instruction read from the instruction memory
    wire [31:0] read_data_1, read_data_2;                               // Data read from the register file
    wire [31:0] read_data;                                              // Data read from the data memory
    wire [31:0] write_data;                                             // Data to be written to the data memory
    wire [31:0] in;                                                     // input address from the program counter
    wire [31:0] out;                                                    // Output address from the program counter
    wire [31:0] extended_imm;                                           // Extended immediate value
    output [31:0] alu_result;                                             // ALU result
    wire [31:0] operand_1;                                              // ALU operand 1
    wire [31:0] operand_2;                                              // ALU operand 2
    wire [4:0] alu_control;                                             // ALU control signal
    wire [2:0] jump_branch;                                             // Jump or branch signal
    wire [2:0] imm_src;                                                 // Immediate source
    wire [1:0] result_src, alu_src;                                     // Result source and ALU source
    wire [1:0] data_size;                                               // Data size
    wire pc_src, mem_write, reg_write;                                  // Control signals for program counter, data memory, and register file
    wire extension_type;                                                // Extension type
    wire zero, neg, less_than;                                          // Zero, negative, and less than flags

// module instantiation

    // Mux to select the next PC value
    mux2 mux2_pc_value_inst(.operand_1(out + 4), .operand_2(alu_result), .result(in), .select(pc_src));

    // Program Counter
    pc pc_inst(.clk(clk), .rst(rst), .in(in), .out(out));

    // Instruction Memory
    imem imem_inst(.addr({2'b00,out[31:2]}), .instruction(instruction));

    // Mux to select the register input value
    mux4 mux4_register_input_inst(.operand_1(alu_result), .operand_2(read_data), .operand_3(out + 4), .operand_4(extended_imm), .result(write_data), .select(result_src));

    // Register File
    reg_file reg_file_inst(.read_address_1(instruction[19:15]), .read_address_2(instruction[24:20]), .write_address(instruction[11:7]), .write_data(write_data), .clk(clk), .write_enable(reg_write), .read_data_1(read_data_1), 
    .read_data_2(read_data_2), .rst(rst));

    // Mux to select the first operand for the ALU
    mux2 mux2_ADDER_OPERAND_1_inst(.operand_1(read_data_1), .operand_2(out), .result(operand_1), .select(alu_src[1]));

    // Mux to select the second operand for the ALU
    mux2 mux2_ADDER_OPERAND_2_inst(.operand_1(read_data_2), .operand_2(extended_imm), .result(operand_2), .select(alu_src[0]));

    // ALU
    ALU alu_inst(.operand_1(operand_1), .operand_2(operand_2), .result(alu_result), .ALU_control(alu_control));

    // Data Memory
    data_memory data_memory_inst(.address({2'b00,alu_result[31:2]}), .write_data(read_data_2), .read_data(read_data), .clk(clk), .rst(rst), .data_size(data_size), .extension_type(extension_type), .write_enable(mem_write));

    // Immediate Value Extender
    imm_extend imm_extend_inst(.imm(instruction[31:7]), .extended_imm(extended_imm), .imm_src(imm_src));

    // Control Unit
    control_unit control_unit_inst(.op(instruction[6:0]), .funct3(instruction[14:12]), .funct7(instruction[31:25]), .jump_branch(jump_branch), .result_src(result_src), .mem_write(mem_write), .alu_control(alu_control), .alu_src(alu_src),
    .imm_src(imm_src), .reg_write(reg_write), .data_size(data_size), .extension_type(extension_type));

    // Jump and Branch Decision Unit
    jump_branch_decision jump_branch_decision_inst(.operand_1(read_data_1), .operand_2(read_data_2), .zero(zero), .neg(neg), .less_than(less_than), .jump_branch(jump_branch), .pc_src(pc_src));

endmodule




