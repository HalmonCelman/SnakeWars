/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module draw_error
#(
    parameter BG_COLOR   = 12'hF00,
    parameter RECT_COLOR = 12'h0F0 
)(
    input wire clk,
    input wire rst,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

vga_if rect();
logic [RGB_B-1:0] rgb_r; 
vga_if text1();
logic [RGB_B-1:0] rgb_t1, rgb_t2; 

draw_text #(
    .X(ERROR_TXT_X),
    .Y(ERROR_TXT_Y),
    .TEXT_DISP(3),
    .FONT_COLOR(12'hFFF)
) u_draw_text1 (
    .clk,
    .rst,
    .vga_in,
    .rgb_i(BG_COLOR),
    .vga_out(text1),
    .rgb_o(rgb_t1)
);


// back to menu
draw_rect #(
    .X(BUTTONS_X),
    .Y(BUTTONE_Y),
    .W(BUTTONS_W),
    .H(BUTTONS_H),
    .COLOR(RECT_COLOR)
) u_draw_rect2 (
    .clk,
    .rst,
    .vga_in(text1),
    .rgb_i(rgb_t1),
    .vga_out(rect),
    .rgb_o(rgb_r)
);

draw_text #(
    .X(BUTTONS_X+TEXT_ADJ_W),
    .Y(BUTTONE_Y+TEXT_ADJ_H),
    .TEXT_DISP(4)
) u_draw_text2 (
    .clk,
    .rst,
    .vga_in(rect),
    .rgb_i(rgb_r),
    .vga_out,
    .rgb_o
);

endmodule