//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// module name: mux4
//////////////////////////////////////////////////////////////////////////

module mux4(operand_1, operand_2, operand_3, operand_4, select, result);

    parameter SIZE = 32;

    // input port
    input [31:0] operand_1, operand_2, operand_3, operand_4;               // Input operands (32 bits each)
    input [1:0] select;                                                    // Select signal (2 bits)

    // output port
    output reg [31:0] result;                                                  // Output (32 bits)

    // Assign the output based on the select signal
    always @(*) begin
        case (select)
            2'b00: result = operand_1;
            2'b01: result = operand_2;
            2'b10: result = operand_3;
            2'b11: result = operand_4;
            default: result = 32'hxxxxxxxx;
        endcase
    end

endmodule