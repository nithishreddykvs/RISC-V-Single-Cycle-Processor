//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// module name: reg_file
//////////////////////////////////////////////////////////////////////////

module reg_file (read_address_1, read_address_2, write_address, write_data, clk, write_enable, read_data_1, read_data_2, rst);
    
    // Size of the register file (32 registers, each 32 bits wide)
    parameter SIZE = 32;

    // input port
    input [SIZE-1:0] write_data;                                        //Input data to be written to the register file
    input [4:0] read_address_1, read_address_2, write_address;          // Addresses for reading and writing data
    input clk, write_enable, rst;                                     // Clock, write enable, and reset signals                    

    // output port
    output [SIZE-1:0] read_data_1, read_data_2;                         // Data read from the specified registers

    // Register file array (32 registers, each 32 bits wide)
    reg [SIZE-1:0] reg_file [0:SIZE-1];

    // Integer for loop iteration
    integer i;

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (rst) begin
            // If reset is high, initialize all registers to 0
            for (i = 0; i < SIZE; i = i + 1) begin
                reg_file[i] <= 0;
            end
            reg_file[2] <= 32'h00000500;
        end else if (write_enable) begin
            // If write enable is high, write data to the specified register
            if (!write_address) begin
                reg_file[write_address] <= 0;
            end else begin
                reg_file[write_address] <= write_data;
            end
            
        end
    end

    // Assign the read data outputs to the values stored in the specified registers
    assign read_data_1 = reg_file[read_address_1];
    assign read_data_2 = reg_file[read_address_2];

endmodule