module register #(
    parameter FF = "TRUE", N = 18
) (
    input reset, clk, enable, [N-1:0]d,
    output [N-1:0]out
);
    reg [N-1:0] q;
    assign out = (FF=="TRUE")? q:d;
    generate
        always @(posedge clk) begin
            if (reset) q <= 0;
            else if (enable) q <= d;
        end
    endgenerate
endmodule