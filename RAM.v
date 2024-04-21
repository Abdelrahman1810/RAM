module RAM #(
    parameter MEM_WIDTH = 16, MEM_DEPTH = 1024, ADDR_SIZE = 10,
    parameter ADDR_PIPELINE = "FALSE", DOUT_PIPELINE = "TRUE",
    parameter ARITY_ENABLE = 1
)(
    input clk, rst,
    input [MEM_WIDTH-1:0] din,
    input [ADDR_SIZE-1:0] addr,
    input wr_en, rd_en, blk_select, addr_en, dout_en,

    output [MEM_WIDTH-1:0] dout,
    output parity_out
);
    reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

    wire [ADDR_SIZE-1:0]addr_reg;
    reg [MEM_WIDTH-1:0] out;
    
    // ADDR_PIPELINE
    register #(.FF(ADDR_PIPELINE), .N(ADDR_SIZE))regadd(rst, clk, addr_en, addr, addr_reg);
    // DOUT_PIPELINE
    register #(.FF(DOUT_PIPELINE), .N(MEM_WIDTH))regout(rst, clk, dout_en, out, dout);

    always @(posedge clk) begin
        if (rst) out <= 0;
        else if (blk_select) begin
            if (wr_en)
                mem[addr_reg] <= din;
             else if (rd_en)
                out <= mem[addr_reg];
        end
    end
    assign parity_out = (^dout)? (1'b1):(1'b0);

endmodule