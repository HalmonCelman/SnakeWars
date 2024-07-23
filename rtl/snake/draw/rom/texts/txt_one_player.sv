module txt_one_player
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
            8'h00: data = "g";
            8'h01: data = "r";
            8'h02: data = "a";
            8'h03: data = " ";
            8'h04: data = "j";
            8'h05: data = "e";
            8'h06: data = "d";
            8'h07: data = "n";
            8'h08: data = "o";
            8'h09: data = "o";
            8'h0a: data = "s";
            8'h0b: data = "o";
            8'h0c: data = "b";
            8'h0d: data = "o";
            8'h0e: data = "w";
            8'h0f: data = "a";

            default: data = " ";
        endcase

endmodule
