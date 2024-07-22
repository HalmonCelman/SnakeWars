/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import vga_pkg::*;

module draw_menu
#(
    parameter BG_COLOR = 12'hAAA
)(
    input wire clk,
    input wire rst,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

vga_if rect1(), rect2(), rect3();
logic [RGB_B-1:0] rgb_r1, rgb_r2, rgb_r3; 
vga_if text1(), text2(), text3();
logic [RGB_B-1:0] rgb_t1, rgb_t2, rgb_t3; 

draw_rect u_draw_rect(
    .clk,
    .rst,
    .vga_in,
    .rgb_i(BG_COLOR),
    .vga_out(rect1),
    .rgb_o(rgb_r1)
);

draw_text u_draw_text(
    .clk,
    .rst,
    .vga_in(rect1),
    .rgb_i(rgb_r1),
    .vga_out,
    .rgb_o
);

endmodule