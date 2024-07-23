module txt_settings
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
            8'h02: data = " ";
            8'h03: data = "u";
            8'h04: data = "s";
            8'h05: data = "t";
            8'h06: data = "a";
            8'h07: data = "w";
            8'h08: data = "i";
            8'h09: data = "e";
            8'h0a: data = "n";
            8'h0b: data = "i";
            8'h0c: data = "a";
            8'h0d: data = " ";
            8'h0e: data = " ";
            8'h0f: data = " ";

            default: data = " ";
        endcase

endmodule
