/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import vga_pkg::*;

module draw(
    input wire clk,
    input wire rst,

    vga_if.in vga_in,
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb
);

logic [RGB_B-1:0] rgb_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        rgb <= '0;
    end else begin
        rgb <= rgb_nxt;
    end

    vga_out.hcount <= vga_in.hcount;
    vga_out.vcount <= vga_in.vcount;
    vga_out.hblnk  <= vga_in.hblnk;
    vga_out.vblnk  <= vga_in.vblnk;
    vga_out.hsync  <= vga_in.hsync;
    vga_out.vsync  <= vga_in.vsync;
end

always_comb begin
    if(vga_in.hblnk | vga_in.vblnk) begin
        rgb_nxt = '0;
    end else begin
        rgb_nxt = 12'hAAA;
    end
end

endmodule