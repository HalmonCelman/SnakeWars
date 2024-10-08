/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/
`timescale 1 ns / 1 ps

import snake_pkg::*;
import vga_pkg::*;

module top (
    input  wire clk100MHz,
    input  wire clk,
    input  wire rst,
    input  wire rx,
    
    output logic tx,
    output logic hsync,
    output logic vsync,
    output logic [RGB_B-1:0] rgb,

    inout wire mouse_clk,
    inout wire mouse_data
);

map_s map;

vga_if vga_in(), vga_out();

logic [11:0] mouse_x, mouse_y;
direction dir_int, dir2_int;
logic clk_divided;
logic left_int, right_int;

logic rcvdir;
logic eaten;

logic [4:0] seed_x_ingoing, seed_y_ingoing, seed_x_outgoing, seed_y_outgoing, point_x, point_y;
logic send_seed;

logic start_game_ingoing;

game_mode mode_int;
logic won, lost, draw, con_error_int;

logic local_start, singleplayer;

assign vsync = vga_out.vsync;
assign hsync = vga_out.hsync;

vga_timing u_vga_timing(
    .clk,
    .rst,
    .vga(vga_in)
);

draw u_draw (
    .clk(clk),
    .rst(rst),
    .act_tile(map.tiles[vga_in.vcount/TILE_SIZE][vga_in.hcount/TILE_SIZE]),
    .mouse_x(mouse_x),
    .mouse_y(mouse_y),
    .mode(mode_int),
    .vga_in(vga_in),
    .vga_out(vga_out),
    .rgb(rgb)
);

clk_div u_clk_div(
    .clk(clk),
    .rst(rst),
    .mode(mode_int),
    .clk_divided(clk_divided)
);

mode_control u_mode_control(
    .clk_75(clk),
	.rst(rst),
	.start_game(start_game_ingoing),
    .local_start,
	.won,
	.lost,
	.draw,
	.con_error(con_error_int), 
	.click_x(mouse_x),
	.click_y(mouse_y),
	.click_e(left_int),
    .mode(mode_int),
    .singleplayer
);

move_n_collisions u_move_n_collisions (
    .clk(clk),
    .clk_div(clk_divided),
    .rst,
    .mode(mode_int),
    .singleplayer,
    .dir1(dir_int),
    .dir2(dir2_int),
    .rcvdir,
    .point_x,
    .point_y,
    .map,
    .com_err(con_error_int),
    .eaten,
    .won,
    .lost,
    .draw
);

generate_point u_generate_point(
    .clk_75(clk),
    .clk_div(clk_divided),
    .rst(rst),
    .mode(mode_int),
    .local_start,
    .seed_x_in(seed_x_ingoing),
    .seed_y_in(seed_y_ingoing),
    .colision(eaten),
    .seed_x_out(seed_x_outgoing),
    .seed_y_out(seed_y_outgoing),
    .seed_rdy(send_seed),
    .point_gen_x(point_x),
    .point_gen_y(point_y)
);

mouse_move u_mouse_move (
    .clk(clk),
    .clk_divided,
    .rst(rst),
    .left(left_int),
    .right(right_int),
    .dir(dir_int),
    .mode(mode_int)
);

mouse_control u_mouse_control(
    .clk100MHz,
    .clk75MHz(clk),
    .rst(rst),
    .left(left_int),
    .right(right_int),
    .ps2_clk(mouse_clk),
    .ps2_data(mouse_data),
    .x(mouse_x),
    .y(mouse_y)
);

communicate u_communicate(
    .clk,
    .rst,
    .rx,
    .send(clk_divided),
    .seed_rdy(send_seed),
    .seed_x_in(seed_x_outgoing),
    .seed_y_in(seed_y_outgoing),
    .start_game(start_game_ingoing),
    .seed_x_out(seed_x_ingoing),
    .seed_y_out(seed_y_ingoing),
    .tx,
    .singleplayer,
    .dir1(dir_int),
    .dir2(dir2_int),
    .rcvdir
);

endmodule
