/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;
import vga_pkg::*;

module draw_game #(
    parameter SUM_DELAY  = 2 
)
(
    input wire clk,
    input wire rst,

    input map_s map,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o 
);

vga_if vga_delay();
logic [RGB_B-1:0] rgb_nxt, rgb_d;

always_ff @(posedge clk) begin
    if(rst) begin
        rgb_o <= '0;
    end else begin
        rgb_o <= rgb_d;
    end

    vga_out.hcount <= vga_delay.hcount;
    vga_out.vcount <= vga_delay.vcount;
    vga_out.hblnk  <= vga_delay.hblnk;
    vga_out.vblnk  <= vga_delay.vblnk;
    vga_out.hsync  <= vga_delay.hsync;
    vga_out.vsync  <= vga_delay.vsync;
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

delay
#(
    .CLK_DEL(SUM_DELAY-1),
    .WIDTH(38)
) u_delay_vga(
    .clk,
    .rst,
    .din ({vga_in.hcount,    vga_in.vcount,    vga_in.hblnk,    vga_in.vblnk,    vga_in.hsync,    vga_in.vsync,    rgb_nxt}),
    .dout({vga_delay.hcount, vga_delay.vcount, vga_delay.hblnk, vga_delay.vblnk, vga_delay.hsync, vga_delay.vsync, rgb_d})
);

endmodule