/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import vga_pkg::*;

module draw_text #(
    parameter X=0,
    parameter Y=0,
    parameter FONT_COLOR=12'h000,
    /*
    TEXT_DISP - text to be displayed(one line, 16 characters)
    0 - "gra jednoosobowa"
    1 - " gra dwuosobowa "
    2 - "   ustawienia   "
    3 - "BLAD: polaczenie"
    4 - "  wroc do menu  "
    5 - "   ZWYCIESTWO   "
    6 - "    PORAZKA     "
    7 - "     REMIS      "
    */
    parameter TEXT_DISP=0
)(
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
    .X(X),
    .Y(Y),
    .FONT_COLOR(FONT_COLOR),
    .NUMBER_OF_LINES(1),
    .CHARS_IN_LINE(16)
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


// all texts possible
logic [6:0] one_player, two_players, settings, conn_error, back_to_menu, s_win, s_lose, s_draw;

txt_one_player u_text0 (
    .clk,
    .char_code(one_player),
    .char_xy
);

txt_two_players u_text1 (
    .clk,
    .char_code(two_players),
    .char_xy
);

txt_settings u_text2 (
    .clk,
    .char_code(settings),
    .char_xy
);

txt_connection_error u_text3 (
    .clk,
    .char_code(conn_error),
    .char_xy
);

txt_back_to_menu u_text4 (
    .clk,
    .char_code(back_to_menu),
    .char_xy
);

txt_win u_text5 (
    .clk,
    .char_code(s_win),
    .char_xy
);

txt_lose u_text6 (
    .clk,
    .char_code(s_lose),
    .char_xy
);

txt_draw u_text7 (
    .clk,
    .char_code(s_draw),
    .char_xy
);

always_comb begin
    case(TEXT_DISP)
        0:          char_code = one_player;
        1:          char_code = two_players;
        2:          char_code = settings;
        3:          char_code = conn_error;
        4:          char_code = back_to_menu;
        5:          char_code = s_win;
        6:          char_code = s_lose;
        7:          char_code = s_draw;

        default:    char_code = one_player;
    endcase
end

endmodule