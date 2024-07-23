module txt_lose
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
            8'h03: data = " ";
            8'h04: data = "P";
            8'h05: data = "O";
            8'h06: data = "R";
            8'h07: data = "A";
            8'h08: data = "Z";
            8'h09: data = "K";
            8'h0a: data = "A";
            8'h0b: data = " ";
            8'h0c: data = " ";
            8'h0d: data = " ";
            8'h0e: data = " ";
            8'h0f: data = " ";

            default: data = " ";
        endcase

endmodule
