module test_fifo;
    timeunit 1ns; timeprecision 100ps;
    import tb_utils_pkg::*;
    // Parameters
    localparam WIDTH = 32;
    localparam DEPTH = 16;
    localparam CLK_PERIOD = 10;

    // Signals
    logic clk_i;
    logic rst_n_i;
    logic [WIDTH-1:0] wdata_i;
    logic wr_en_i;
    logic full_o;
    logic [WIDTH-1:0] rdata_o;
    logic rd_en_i;
    logic empty_o;

    // Queue for reference
    logic [WIDTH-1:0] ref_queue[$];

    // Error count
    int error_count = 0;

    // DUT instantiation
    fifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dut (.*);

    // Clock generation
    initial begin
        clk_i = 0;
        forever #(CLK_PERIOD/2) clk_i = ~clk_i;
    end

    // Test stimulus
    initial begin
        // Initialize
        {rst_n_i, wr_en_i, rd_en_i, wdata_i} = '0;
        ref_queue = {};

        // Reset
        #(CLK_PERIOD*2);
        rst_n_i = 1;
        #(CLK_PERIOD*2);

        // Test 1: Write until full
        $display("Test 1: Write until full");
        for(int i=0; i<DEPTH-1; i++) begin
            @(posedge clk_i);
            wdata_i = $random;
            wr_en_i = 1;
            ref_queue.push_back(wdata_i);
            @(negedge clk_i);
            assert(!full_o) else begin $error("FIFO full before expected"); error_count++; end
        end
        // Write one more to make FIFO full
        @(posedge clk_i);
        wdata_i = $random;
        wr_en_i = 1;
        ref_queue.push_back(wdata_i);
        @(negedge clk_i);
        wr_en_i = 0;
        assert(full_o) else begin $error("FIFO not full when expected"); error_count++; end
        @(posedge clk_i);
        wr_en_i = 0;
        assert(full_o) else begin $error("FIFO not full when expected"); error_count++; end

        // Test 2: Read until empty
        $display("Test 2: Read until empty");
        for(int i=0; i<DEPTH; i++) begin
            @(posedge clk_i);
            rd_en_i = 1;
            @(negedge clk_i);
            assert(rdata_o == ref_queue[0]) else begin
                $error("Read data mismatch. Expected: %h, Got: %h", ref_queue[0], rdata_o);
                error_count++; 
            end
            void'(ref_queue.pop_front());
        end
        @(posedge clk_i);
        rd_en_i = 0;
        assert(empty_o) else begin $error("FIFO not empty when expected"); error_count++; end

        // Test 3: Alternate read/write
        $display("Test 3: Alternate read/write");
        for(int i=0; i<10; i++) begin
            @(posedge clk_i);
            wdata_i = $random;
            wr_en_i = 1;
            ref_queue.push_back(wdata_i);
            @(posedge clk_i);
            wr_en_i = 0;
            rd_en_i = 1;
            @(negedge clk_i);
            assert(rdata_o == ref_queue[0]) else begin
                $error("Read data mismatch. Expected: %h, Got: %h", ref_queue[0], rdata_o);
                error_count++;
            end
            void'(ref_queue.pop_front());
            rd_en_i = 0;
        end

        // Test completion
        #(CLK_PERIOD*5);
        display_result(error_count);
        if (error_count==0) $display("All tests passed!");
        $finish;
    end

    // Timeout watchdog
    initial begin
        #(CLK_PERIOD*1000);
        $error("Timeout occurred!");
        error_count++;
        $finish;
    end

    // Assertions
    property write_when_full;
        @(posedge clk_i) full_o && wr_en_i |-> ##1 $stable(dut.wptr);
    endproperty

    property read_when_empty;
        @(posedge clk_i) empty_o && rd_en_i |-> ##1 $stable(dut.rptr);
    endproperty

    assert property(write_when_full) else begin $error("Write occurred when FIFO full"); error_count++; end
    assert property(read_when_empty) else begin $error("Read occurred when FIFO empty"); error_count++; end

endmodule