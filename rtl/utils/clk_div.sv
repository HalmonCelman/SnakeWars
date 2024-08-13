module clk_div#(
    parameter COUNTS = 18750000,
    parameter COUNTER_BITS = 25
)(
    input wire clk,
    input wire rst,

    output logic clk_divided
);

logic [COUNTER_BITS-1:0] ctr, ctr_nxt;
logic clk_divided_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        ctr <= '0;
        clk_divided <= '0;
    end else begin
        ctr <= ctr_nxt;
        clk_divided <= clk_divided_nxt;
    end
end

always_comb begin
    if(ctr >= COUNTS) begin
        ctr_nxt = '0;
        clk_divided_nxt = ~clk_divided;
    end else begin
        ctr_nxt = ctr+1;
        clk_divided_nxt = clk_divided;
    end
end

endmodule