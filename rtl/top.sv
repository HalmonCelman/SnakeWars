/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/
`timescale 1 ns / 1 ps

import snake_pkg::*;

module top (
    input  wire clk100MHz,
    input  wire clk,
    input  wire rst,
    
    output logic hsync,
    output logic vsync,
    output logic [RGB_B-1:0] rgb,

    inout wire mouse_clk,
    inout wire mouse_data
);

map_s map;
vga_if vga_in(), vga_out();
logic [11:0] mouse_x, mouse_y;

assign hsync = vga_out.hsync;
assign vsync = vga_out.vsync;

vga_timing u_vga_timing(
    .clk,
    .rst,
    .vga(vga_in)
);

draw u_draw (
    .clk,
    .rst,
    .map,
    .mouse_x,
    .mouse_y,
    .mode(GAME),
    .vga_in,
    .vga_out,
    .rgb
);

logic clk_divided;

clk_div u_clk_div(
    .clk,
    .rst,
    .clk_divided
);

move u_move (
    .clk(clk_divided),
    .rst,
    .dir(LEFT),
    .map
);

mouse_control u_mouse_control(
    .clk100MHz,
    .clk75MHz(clk),
    .rst,
    .left(),
    .ps2_clk(mouse_clk),
    .ps2_data(mouse_data),
    .x(mouse_x),
    .y(mouse_y)
);

endmodule
