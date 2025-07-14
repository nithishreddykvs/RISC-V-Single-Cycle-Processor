//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// Module-Name: data_memory
//////////////////////////////////////////////////////////////////////////

module data_memory(address, write_data, read_data, clk, rst, data_size, extension_type, write_enable);

    // Size of the address and instruction (32 bits)
    parameter SIZE = 32;
    // Base address for the instruction memory
    parameter BASE_ADDRESS = 32'h00000000;
    // Size of the instruction memory (1792 MB)
    parameter mem_SIZE = 2000;                                          //1792 * 2**20;

    // input port
    input [SIZE-1:0] write_data;                                        // Input data to be written to the data memory
    input [SIZE-1:0] address;                                           // Address for reading and writing data
    input [1:0] data_size;                                              // Data size (2 bits)
    input clk,rst, write_enable, extension_type;                        // Clock, write enable, extension_type and reset signals

    // output port
    output reg [SIZE-1:0] read_data;                                    // Data read from the specified address

    // Memory array (8-bit wide)
    reg [31:0] data_memory [0:mem_SIZE-1];

    // Integer for loop iteration
    integer i;

    //reg byte_enable;
    reg [3:0] byte_enable;

    // Always block triggered on the rising edge of the clock
    always @(*) begin
        case (address[1:0])
            0: byte_enable = 4'b0001;
            1: byte_enable = 4'b0010;
            2: byte_enable = 4'b0100;
            3: byte_enable = 4'b1000; 
            default: byte_enable = 4'b0000;
        endcase
    end

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (write_enable) begin
            // If write enable is high, write data to the specified address
           case (data_size)
                2'b00: begin
                    // Store byte
                    if (byte_enable[0]) data_memory[address - BASE_ADDRESS][7:0]   <= write_data[7:0];
                    if (byte_enable[1]) data_memory[address - BASE_ADDRESS][15:8]  <= write_data[7:0];
                    if (byte_enable[2]) data_memory[address - BASE_ADDRESS][23:16] <= write_data[7:0];
                    if (byte_enable[3]) data_memory[address - BASE_ADDRESS][31:24] <= write_data[7:0];
                end  
                2'b01: begin
                    // Store halfword
                    if (byte_enable[0]) data_memory[address - BASE_ADDRESS][15:0]   <= write_data[15:0];
                    if (byte_enable[2]) data_memory[address - BASE_ADDRESS][31:16] <= write_data[15:0];
                end
                2'b10: begin
                    // Store word
                    data_memory[address - BASE_ADDRESS] <= write_data[31:0];
                end
                default: begin
                    // Default case: store zero
                    data_memory[address - BASE_ADDRESS] <= 8'h00;
                end
            endcase
        end
    end

always @(*) begin
        case (data_size)
            2'b00: begin
                if (!extension_type) begin
                    // Byte-Sign Extend
                    if (byte_enable[0]) read_data <= {{24{data_memory[address - BASE_ADDRESS][7]}} ,data_memory[address - BASE_ADDRESS][7:0]};
                    if (byte_enable[1]) read_data <= {{24{data_memory[address - BASE_ADDRESS][15]}} ,data_memory[address - BASE_ADDRESS][15:8]};
                    if (byte_enable[2]) read_data <= {{24{data_memory[address - BASE_ADDRESS][23]}} ,data_memory[address - BASE_ADDRESS][23:16]};
                    if (byte_enable[3]) read_data <= {{24{data_memory[address - BASE_ADDRESS][31]}} ,data_memory[address - BASE_ADDRESS][31:24]}; 
                end else begin
                    // Byte-UNSign Extend
                    if (byte_enable[0]) read_data <= {24'h000000 ,data_memory[address - BASE_ADDRESS][7:0]};
                    if (byte_enable[1]) read_data <= {24'h000000 ,data_memory[address - BASE_ADDRESS][15:8]};
                    if (byte_enable[2]) read_data <= {24'h000000 ,data_memory[address - BASE_ADDRESS][23:16]};
                    if (byte_enable[3]) read_data <= {24'h000000 ,data_memory[address - BASE_ADDRESS][31:24]}; 
                end
            end 
            2'b01: begin
                if (!extension_type) begin
                    // Halfword-Sign Extend
                    if (byte_enable[0]) read_data <= {{16{data_memory[address - BASE_ADDRESS][15]}} ,data_memory[address - BASE_ADDRESS][15:0]};
                    if (byte_enable[2]) read_data <= {{16{data_memory[address - BASE_ADDRESS][31]}} ,data_memory[address - BASE_ADDRESS][31:16]}; 
                    
                end else begin
                    // Halfword-Zero Extend
                    if (byte_enable[0]) read_data <= {16'h0000 ,data_memory[address - BASE_ADDRESS][15:0]};
                    if (byte_enable[2]) read_data <= {16'h0000 ,data_memory[address - BASE_ADDRESS][31:16]}; 
                end
            end
            2'b10: read_data <= data_memory[address - BASE_ADDRESS]; // Word
            default: read_data <= 0;
        endcase
    end

endmodule