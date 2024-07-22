/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import vga_pkg::*;

module draw_text(
    input wire clk,
    input wire rst,

    vga_if.in vga_in,
    input wire [RGB_B-1:0] rgb_i,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

logic [7:0] char_xy;
logic [3:0] char_line;
logic [6:0] char_code;
logic [7:0] char_pixels;

draw_rect_char #(
    .X(200),
    .Y(50)
) u_draw_rect_char (
    .clk,
    .rst,
    .vga_in,
    .rgb_i,
    .vga_out,
    .rgb_o,
    .char_line,
    .char_xy,
    .char_pixels
);

font_rom u_font_rom (
    .clk,
    .addr({char_code, char_line}),
    .char_line_pixels(char_pixels)
);

char_rom_16x16 u_char_rom_16x16 (
    .clk,
    .char_code,
    .char_xy
);

endmodule