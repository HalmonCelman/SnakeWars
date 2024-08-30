/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import vga_pkg::*;
import snake_pkg::*;

module draw(
    input wire clk,
    input wire rst,
    input game_mode mode,

    input tile act_tile,

    input logic [11:0] mouse_x,
    input logic [11:0] mouse_y, 

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb
);

vga_if vga_nxt();
logic [RGB_B-1:0] rgb_nxt;

vga_if vga_menu(), vga_error(), vga_win(), vga_lose(), vga_draw(), vga_game();
logic [RGB_B-1:0] rgb_menu, rgb_error, rgb_win, rgb_lose, rgb_draw, rgb_game;

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
    
    case(mode)
        MENU: begin
            vga_nxt.hcount  = vga_menu.hcount;
            vga_nxt.vcount  = vga_menu.vcount;
            vga_nxt.hblnk   = vga_menu.hblnk;
            vga_nxt.vblnk   = vga_menu.vblnk;
            vga_nxt.hsync   = vga_menu.hsync;
            vga_nxt.vsync   = vga_menu.vsync;
        end
        ERROR: begin
            vga_nxt.hcount  = vga_error.hcount;
            vga_nxt.vcount  = vga_error.vcount;
            vga_nxt.hblnk   = vga_error.hblnk;
            vga_nxt.vblnk   = vga_error.vblnk;
            vga_nxt.hsync   = vga_error.hsync;
            vga_nxt.vsync   = vga_error.vsync;
        end
        WIN: begin
            vga_nxt.hcount  = vga_win.hcount;
            vga_nxt.vcount  = vga_win.vcount;
            vga_nxt.hblnk   = vga_win.hblnk;
            vga_nxt.vblnk   = vga_win.vblnk;
            vga_nxt.hsync   = vga_win.hsync;
            vga_nxt.vsync   = vga_win.vsync;
        end
        LOSE: begin
            vga_nxt.hcount  = vga_lose.hcount;
            vga_nxt.vcount  = vga_lose.vcount;
            vga_nxt.hblnk   = vga_lose.hblnk;
            vga_nxt.vblnk   = vga_lose.vblnk;
            vga_nxt.hsync   = vga_lose.hsync;
            vga_nxt.vsync   = vga_lose.vsync;
        end
        DRAW: begin
            vga_nxt.hcount  = vga_draw.hcount;
            vga_nxt.vcount  = vga_draw.vcount;
            vga_nxt.hblnk   = vga_draw.hblnk;
            vga_nxt.vblnk   = vga_draw.vblnk;
            vga_nxt.hsync   = vga_draw.hsync;
            vga_nxt.vsync   = vga_draw.vsync;
        end
        GAME: begin
            vga_nxt.hcount  = vga_game.hcount;
            vga_nxt.vcount  = vga_game.vcount;
            vga_nxt.hblnk   = vga_game.hblnk;
            vga_nxt.vblnk   = vga_game.vblnk;
            vga_nxt.hsync   = vga_game.hsync;
            vga_nxt.vsync   = vga_game.vsync;
        end
        default: begin
            vga_nxt.hcount  = vga_in.hcount;
            vga_nxt.vcount  = vga_in.vcount;
            vga_nxt.hblnk   = vga_in.hblnk;
            vga_nxt.vblnk   = vga_in.vblnk;
            vga_nxt.hsync   = vga_in.hsync;
            vga_nxt.vsync   = vga_in.vsync;
        end
    endcase

    if(vga_nxt.hblnk | vga_nxt.vblnk) begin
        rgb_nxt = '0;
    end else begin  
        case(mode)
        MENU:       rgb_nxt         = rgb_menu;
        ERROR:      rgb_nxt         = rgb_error;
        WIN:        rgb_nxt         = rgb_win;
        LOSE:       rgb_nxt         = rgb_lose;
        DRAW:       rgb_nxt         = rgb_draw;
        GAME:       rgb_nxt         = rgb_game;
        default:    rgb_nxt         = 12'h0F0;
    endcase
    end
end



// all submodules connected below
localparam SUM_DELAY=17; //paths should have same amount of flip flop delays

draw_menu #(
    .SUM_DELAY(SUM_DELAY)
) u_draw_menu(
    .clk,
    .rst,

    .mouse_x,
    .mouse_y,

    .vga_in,
    .vga_out(vga_menu),
    .rgb_o(rgb_menu)
);

draw_error #(
    .SUM_DELAY(SUM_DELAY)
) u_draw_error(
    .clk,
    .rst,

    .mouse_x,
    .mouse_y,

    .vga_in,
    .vga_out(vga_error),
    .rgb_o(rgb_error)
);

draw_win #(
    .SUM_DELAY(SUM_DELAY)
) u_draw_win(
    .clk,
    .rst,

    .mouse_x,
    .mouse_y,

    .vga_in,
    .vga_out(vga_win),
    .rgb_o(rgb_win)
);

draw_lose #(
    .SUM_DELAY(SUM_DELAY)
) u_draw_lose(
    .clk,
    .rst,

    .mouse_x,
    .mouse_y,

    .vga_in,
    .vga_out(vga_lose),
    .rgb_o(rgb_lose)
);

draw_draw #(
    .SUM_DELAY(SUM_DELAY)
) u_draw_draw(
    .clk,
    .rst,

    .mouse_x,
    .mouse_y,
    
    .vga_in,
    .vga_out(vga_draw),
    .rgb_o(rgb_draw)
);

draw_game #(
    .SUM_DELAY(SUM_DELAY)
) u_draw_game(
    .clk,
    .rst,
    
    .act_tile,

    .vga_in,
    .vga_out(vga_game),
    .rgb_o(rgb_game)
);
endmodule