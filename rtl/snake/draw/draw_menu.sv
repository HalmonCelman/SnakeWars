/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;
import vga_pkg::*;

module draw_menu
#(
    parameter BG_COLOR   = 12'hAAA,
    parameter RECT_COLOR = 12'h0F0,
    parameter SUM_DELAY  = 17 
)(
    input wire clk,
    input wire rst,

    input logic [11:0] mouse_x,
    input logic [11:0] mouse_y, 

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

vga_if rect1(), rect2(), rect3();
logic [RGB_B-1:0] rgb_r1, rgb_r2, rgb_r3; 
vga_if text1(), text2(), text3(), mouse();
logic [RGB_B-1:0] rgb_t1, rgb_t2, rgb_t3, rgb_m; 

// one player game
draw_rect #(
    .X(BUTTONS_X),
    .Y(BUTTON1_Y),
    .W(BUTTONS_W),
    .H(BUTTONS_H),
    .COLOR(RECT_COLOR)
) u_draw_rect1 (
    .clk,
    .rst,
    .vga_in,
    .rgb_i(BG_COLOR),
    .vga_out(rect1),
    .rgb_o(rgb_r1)
);

draw_text #(
    .X(BUTTONS_X+TEXT_ADJ_W),
    .Y(BUTTON1_Y+TEXT_ADJ_H),
    .TEXT_DISP(0)
) u_draw_text1 (
    .clk,
    .rst,
    .vga_in(rect1),
    .rgb_i(rgb_r1),
    .vga_out(text1),
    .rgb_o(rgb_t1)
);


// two players game
draw_rect #(
    .X(BUTTONS_X),
    .Y(BUTTON2_Y),
    .W(BUTTONS_W),
    .H(BUTTONS_H),
    .COLOR(RECT_COLOR)
) u_draw_rect2 (
    .clk,
    .rst,
    .vga_in(text1),
    .rgb_i(rgb_t1),
    .vga_out(rect2),
    .rgb_o(rgb_r2)
);

draw_text #(
    .X(BUTTONS_X+TEXT_ADJ_W),
    .Y(BUTTON2_Y+TEXT_ADJ_H),
    .TEXT_DISP(1)
) u_draw_text2 (
    .clk,
    .rst,
    .vga_in(rect2),
    .rgb_i(rgb_r2),
    .vga_out(text2),
    .rgb_o(rgb_t2)
);

// settings
draw_rect #(
    .X(BUTTONS_X),
    .Y(BUTTON3_Y),
    .W(BUTTONS_W),
    .H(BUTTONS_H),
    .COLOR(RECT_COLOR)
) u_draw_rect3 (
    .clk,
    .rst,
    .vga_in(text2),
    .rgb_i(rgb_t2),
    .vga_out(rect3),
    .rgb_o(rgb_r3)
);

draw_text #(
    .X(BUTTONS_X+TEXT_ADJ_W),
    .Y(BUTTON3_Y+TEXT_ADJ_H),
    .TEXT_DISP(2)
) u_draw_text3 (
    .clk,
    .rst,
    .vga_in(rect3),
    .rgb_i(rgb_r3),
    .vga_out(text3),
    .rgb_o(rgb_t3)
);

draw_mouse u_draw_mouse(
    .clk,
    .rst,

    .x(mouse_x),
    .y(mouse_y), 
    
    .vga_in(text3),    
    .rgb_i(rgb_t3),  
    .vga_out(mouse),
    .rgb_o(rgb_m)
);

delay
#(
    .CLK_DEL(SUM_DELAY-16),
    .WIDTH(38)
) u_delay_vga(
    .clk,
    .rst,
    .din ({mouse.hcount,   mouse.vcount,   mouse.hblnk,   mouse.vblnk,   mouse.hsync,   mouse.vsync,   rgb_m}),
    .dout({vga_out.hcount, vga_out.vcount, vga_out.hblnk, vga_out.vblnk, vga_out.hsync, vga_out.vsync, rgb_o})
);

endmodule