module testbench ();
    parameter MEM_WIDTH = 16, MEM_DEPTH = 1024, ADDR_SIZE = 10;
    parameter ADDR_PIPELINE = "FALSE", DOUT_PIPELINE = "TRUE";
    parameter ARITY_ENABLE = 1;

    reg clk, rst;
    reg [MEM_WIDTH-1:0] din;
    reg [ADDR_SIZE-1:0] addr;
    reg wr_en, rd_en, blk_select, addr_en, dout_en;

    wire [MEM_WIDTH-1:0] dout;
    wire parity_out;

    RAM #(
    .MEM_WIDTH(MEM_WIDTH), .MEM_DEPTH(MEM_DEPTH), 
    .ADDR_SIZE(ADDR_SIZE), .ADDR_PIPELINE(ADDR_PIPELINE),
    .DOUT_PIPELINE(DOUT_PIPELINE), .ARITY_ENABLE(ARITY_ENABLE)
    )ram(
        clk, rst, din, addr, wr_en, rd_en, blk_select,
        addr_en, dout_en, dout, parity_out
    );

    initial begin
        clk=0;
        forever #1 clk=~clk;
    end

    initial begin
        $readmemh("mem.dat", ram.mem);
        rst=1;
        @(negedge clk);
        rst=1;

    // Write Onley
        wr_en = 1;
        rd_en = 0;
        blk_select = 1;
        dout_en = 1;
        addr_en = $random; // make no diffrence once ADDR_PIPELINE = "FALSE",
        repeat(1000) begin
            din = $random;
            addr = $random;
            @(negedge clk);
        end
        $stop;
    end
endmodule