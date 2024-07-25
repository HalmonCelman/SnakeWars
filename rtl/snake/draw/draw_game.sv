/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module draw_game
(
    input wire clk,
    input wire rst,

    map_if.in map,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

logic [RGB_B-1:0] rgb_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        rgb_o <= '0;
    end else begin
        rgb_o <= rgb_nxt;
    end

    vga_out.hcount <= vga_in.hcount;
    vga_out.vcount <= vga_in.vcount;
    vga_out.hblnk  <= vga_in.hblnk;
    vga_out.vblnk  <= vga_in.vblnk;
    vga_out.hsync  <= vga_in.hsync;
    vga_out.vsync  <= vga_in.vsync;
end

always_comb begin
    case(map.tiles[vga_in.vcount/TILE_SIZE][vga_in.hcount/TILE_SIZE])
        EMPTY:      rgb_nxt=TILE_EMPTY_COLOR;
        WALL:       rgb_nxt=TILE_WALL_COLOR;
        SNAKE1:     rgb_nxt=TILE_SNAKE1_COLOR;
        SNAKE2:     rgb_nxt=TILE_SNAKE2_COLOR;
        POINT:      rgb_nxt=TILE_POINT_COLOR;
        default:    rgb_nxt=TILE_EMPTY_COLOR;
    endcase
end

endmodule