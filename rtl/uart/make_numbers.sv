module make_numbers(
    input wire clk,
    input wire rst,
    input logic [7:0] data_in,
    input wire rx_empty,

    output logic [7:0] char1,
    output logic [7:0] char2,
    output logic readByte
);

logic readByte_nxt;
logic [7:0] char1_nxt, char2_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        char1 <= '0;
        char2 <= '0;

        readByte <= '0;
    end
    else begin
        char2 <= char2_nxt;
        char1 <= char1_nxt;

        readByte <= readByte_nxt;
    end
end

always_comb begin
    if(readByte) begin
        readByte_nxt = '0;
        char2_nxt = char2;
        char1_nxt = char1;
    end
    else begin
        if(!rx_empty) begin
            readByte_nxt = 1;
            char2_nxt = char1;
            char1_nxt = data_in;
        end
        else begin
            readByte_nxt = 0;
            char2_nxt = char2;
            char1_nxt = char1;
        end
    end
end

endmodule