module top_tb();

    reg clk,rst;

    top top_inst(.clk(clk), .rst(rst));

    initial begin
        clk = 0;
        forever begin
            #20;
            clk = ~clk;
        end
    end

    initial begin
        rst = 1;
        @(negedge clk);
        rst = 0;
        repeat(220) @(negedge clk);
        $stop;
    end

endmodule
