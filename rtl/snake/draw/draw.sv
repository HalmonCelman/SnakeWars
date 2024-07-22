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

vga_if vga_menu();
logic [RGB_B-1:0] rgb_menu;

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


endmodule