// by KK

`timescale 1 ns / 1 ps

module top (
    input wire clk,
    input wire rst,
    output logic led
);

always_ff @(posedge clk) begin
    if(rst) begin
        led <= 1'b0;
    end else begin
        led <= 1'b1;
    end
end


endmodule
