//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// module name: imem
//////////////////////////////////////////////////////////////////////////

module imem (addr, instruction);

    // Size of the address and instruction (32 bits)
    parameter SIZE = 32;
    // Base address for the instruction memory
    parameter BASE_ADDRESS = 32'h00000000;
    // Size of the instruction memory (252 MB)
    parameter mem_SIZE = 2000;                                           //252 * 2**20;

    // input port
    input [SIZE-1:0] addr;                                              // Input address (32 bits)

    // output port
    output [SIZE-1:0] instruction;                                      // Output instruction (32 bits)

    // Memory array (8-bit wide, mem_SIZE entries)
    reg [31:0] mem [0:mem_SIZE-1];

    // Initial block to load the instruction memory from a file
    initial begin
        // Load the memory contents from the file "imem.mem"
        $readmemh("imem.mem", mem);
    end

    // Assign the instruction output to the value stored at the specified address
    assign instruction = mem[addr - BASE_ADDRESS];

endmodule









