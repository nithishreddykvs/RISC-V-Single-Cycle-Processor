//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// module name: pc
//////////////////////////////////////////////////////////////////////////

module pc (clk, rst, in, out);

    // Base address for the first instruction
    parameter BASE_INSTRUCTION = 32'h00000000;
    // Size of the instruction (32 bits)
    parameter SIZE = 32;
    
    // input port
    input [SIZE-1:0] in;                                                // Input address (32 bits)
    input clk, rst;                                                   // Clock and reset signals

    // output port
    output reg [SIZE-1:0] out;                                          // Output address (32 bits)

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            // If reset is high, set the output to the base instruction address
            out <= BASE_INSTRUCTION;
        end else begin
            // Otherwise, increment the input address by 4 and assign it to the output
            out <= in;
        end
    end

endmodule













