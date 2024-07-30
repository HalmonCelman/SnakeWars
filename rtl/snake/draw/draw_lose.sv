/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module draw_lose
#(
    parameter BG_COLOR   = 12'h222,
    parameter RECT_COLOR = 12'h0F0,
    parameter SUM_DELAY  = 11 
)(
    input wire clk,
    input wire rst,

    input logic [11:0] mouse_x,
    input logic [11:0] mouse_y,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

vga_if rect();
logic [RGB_B-1:0] rgb_r; 
vga_if text1(), text2(), mouse();
logic [RGB_B-1:0] rgb_t1, rgb_t2, rgb_m; 

draw_text #(
    .X(END_TXT_X),
    .Y(END_TXT_Y),
    .TEXT_DISP(6),
    .FONT_COLOR(12'hF00)
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
    .vga_out(text2),
    .rgb_o(rgb_t2)
);

draw_mouse u_draw_mouse(
    .clk,
    .rst,

    .x(mouse_x),
    .y(mouse_y), 
    
    .vga_in(text2),    
    .rgb_i(rgb_t2),  
    .vga_out(mouse),
    .rgb_o(rgb_m)
);

delay
#(
    .CLK_DEL(SUM_DELAY-10),
    .WIDTH(38)
) u_delay_vga(
    .clk,
    .rst,
    .din ({mouse.hcount,   mouse.vcount,   mouse.hblnk,   mouse.vblnk,   mouse.hsync,   mouse.vsync,   rgb_m}),
    .dout({vga_out.hcount, vga_out.vcount, vga_out.hblnk, vga_out.vblnk, vga_out.hsync, vga_out.vsync, rgb_o})
);

endmodule