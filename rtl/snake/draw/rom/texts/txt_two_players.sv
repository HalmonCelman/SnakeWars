module txt_two_players
(
    input  logic clk,
    input  logic [7:0] char_xy,
    output logic [6:0] char_code
);
    logic [6:0] data;

    // body
    always_ff @(posedge clk)
        char_code <= data;

    always_comb
        case (char_xy)
            8'h00: data = " ";
            8'h01: data = "g";
            8'h02: data = "r";
            8'h03: data = "a";
            8'h04: data = " ";
            8'h05: data = "d";
            8'h06: data = "w";
            8'h07: data = "u";
            8'h08: data = "o";
            8'h09: data = "s";
            8'h0a: data = "o";
            8'h0b: data = "b";
            8'h0c: data = "o";
            8'h0d: data = "w";
            8'h0e: data = "a";
            8'h0f: data = " ";

            default: data = " ";
        endcase

endmodule
