/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import vga_pkg::*;
import snake_pkg::*;

module draw(
    input wire clk,
    input wire rst,
    input game_mode mode,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb
);

vga_if vga_nxt();
logic [RGB_B-1:0] rgb_nxt;

vga_if vga_menu(), vga_error(), vga_win(), vga_lose(), vga_draw();
logic [RGB_B-1:0] rgb_menu, rgb_error, rgb_win, rgb_lose, rgb_draw;

always_ff @(posedge clk) begin
    if(rst) begin
        rgb <= '0;
    end else begin
        rgb <= rgb_nxt;
    end

    vga_out.hcount <= vga_nxt.hcount;
    vga_out.vcount <= vga_nxt.vcount;
    vga_out.hblnk  <= vga_nxt.hblnk;
    vga_out.vblnk  <= vga_nxt.vblnk;
    vga_out.hsync  <= vga_nxt.hsync;
    vga_out.vsync  <= vga_nxt.vsync;
end

always_comb begin
    if(vga_in.hblnk | vga_in.vblnk) begin
        vga_nxt.hcount = vga_in.hcount;
        vga_nxt.vcount = vga_in.vcount;
        vga_nxt.hblnk  = vga_in.hblnk;
        vga_nxt.vblnk  = vga_in.vblnk;
        vga_nxt.hsync  = vga_in.hsync;
        vga_nxt.vsync  = vga_in.vsync;
        rgb_nxt = '0;
    end else begin
        case(mode)
            MENU: begin
                vga_nxt.hcount  = vga_menu.hcount;
                vga_nxt.vcount  = vga_menu.vcount;
                vga_nxt.hblnk   = vga_menu.hblnk;
                vga_nxt.vblnk   = vga_menu.vblnk;
                vga_nxt.hsync   = vga_menu.hsync;
                vga_nxt.vsync   = vga_menu.vsync;
                rgb_nxt         = rgb_menu;
            end
            ERROR: begin
                vga_nxt.hcount  = vga_error.hcount;
                vga_nxt.vcount  = vga_error.vcount;
                vga_nxt.hblnk   = vga_error.hblnk;
                vga_nxt.vblnk   = vga_error.vblnk;
                vga_nxt.hsync   = vga_error.hsync;
                vga_nxt.vsync   = vga_error.vsync;
                rgb_nxt         = rgb_error;
            end
            WIN: begin
                vga_nxt.hcount  = vga_win.hcount;
                vga_nxt.vcount  = vga_win.vcount;
                vga_nxt.hblnk   = vga_win.hblnk;
                vga_nxt.vblnk   = vga_win.vblnk;
                vga_nxt.hsync   = vga_win.hsync;
                vga_nxt.vsync   = vga_win.vsync;
                rgb_nxt         = rgb_win;
            end
            LOSE: begin
                vga_nxt.hcount  = vga_lose.hcount;
                vga_nxt.vcount  = vga_lose.vcount;
                vga_nxt.hblnk   = vga_lose.hblnk;
                vga_nxt.vblnk   = vga_lose.vblnk;
                vga_nxt.hsync   = vga_lose.hsync;
                vga_nxt.vsync   = vga_lose.vsync;
                rgb_nxt         = rgb_lose;
            end
            DRAW: begin
                vga_nxt.hcount  = vga_draw.hcount;
                vga_nxt.vcount  = vga_draw.vcount;
                vga_nxt.hblnk   = vga_draw.hblnk;
                vga_nxt.vblnk   = vga_draw.vblnk;
                vga_nxt.hsync   = vga_draw.hsync;
                vga_nxt.vsync   = vga_draw.vsync;
                rgb_nxt         = rgb_draw;
            end
            default: begin
                vga_nxt.hcount  = vga_in.hcount;
                vga_nxt.vcount  = vga_in.vcount;
                vga_nxt.hblnk   = vga_in.hblnk;
                vga_nxt.vblnk   = vga_in.vblnk;
                vga_nxt.hsync   = vga_in.hsync;
                vga_nxt.vsync   = vga_in.vsync;
                rgb_nxt         = 12'h0F0;
            end
        endcase
    end
end



// all submodules connected below
draw_menu u_draw_menu(
    .clk,
    .rst,

    .vga_in,
    .vga_out(vga_menu),
    .rgb_o(rgb_menu)
);

draw_error u_draw_error(
    .clk,
    .rst,

    .vga_in,
    .vga_out(vga_error),
    .rgb_o(rgb_error)
);

draw_win u_draw_win(
    .clk,
    .rst,

    .vga_in,
    .vga_out(vga_win),
    .rgb_o(rgb_win)
);

draw_lose u_draw_lose(
    .clk,
    .rst,

    .vga_in,
    .vga_out(vga_lose),
    .rgb_o(rgb_lose)
);

draw_draw u_draw_draw(
    .clk,
    .rst,

    .vga_in,
    .vga_out(vga_draw),
    .rgb_o(rgb_draw)
);

endmodule