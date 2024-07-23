module txt_connection_error
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
            8'h00: data = "B";
            8'h01: data = "L";
            8'h02: data = "A";
            8'h03: data = "D";
            8'h04: data = ":";
            8'h05: data = " ";
            8'h06: data = "p";
            8'h07: data = "o";
            8'h08: data = "l";
            8'h09: data = "a";
            8'h0a: data = "c";
            8'h0b: data = "z";
            8'h0c: data = "e";
            8'h0d: data = "n";
            8'h0e: data = "i";
            8'h0f: data = "e";

            default: data = " ";
        endcase

endmodule
