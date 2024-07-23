module txt_back_to_menu
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
            8'h01: data = " ";
            8'h02: data = "w";
            8'h03: data = "r";
            8'h04: data = "o";
            8'h05: data = "c";
            8'h06: data = " ";
            8'h07: data = "d";
            8'h08: data = "o";
            8'h09: data = " ";
            8'h0a: data = "m";
            8'h0b: data = "e";
            8'h0c: data = "n";
            8'h0d: data = "u";
            8'h0e: data = " ";
            8'h0f: data = " ";

            default: data = " ";
        endcase

endmodule
