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

map_s map, map_nxt, map_move_gen_p, map_gen_p_draw;
direction dir_int;

vga_if vga_in(), vga_out();

logic [11:0] mouse_x, mouse_y;
direction dir_int, dir2_int;
logic clk_divided;
logic left_int, right_int;
logic rcvdir;
logic eaten1, eaten2;

logic rcvdir;
logic eaten1, eaten2;

logic [5:0] seed_x_ingoing, seed_y_ingoing, seed_x_outgoing, seed_y_outgoing;
logic send_seed, gain_point;

logic start_game_ingoing;

game_mode mode_int;
logic won_int, lost_int, draw_int, con_error_int;

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
    .map(map_gen_p_draw),
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
	.won(won_int),
	.lost(lost_int),
	.draw(draw_int),
	.con_error(con_error_int),
	.click_x(mouse_x),
	.click_y(mouse_y),
	.click_e(left_int),
    .mode(mode_int)
);

collisons u_collisions(
    .map,
    .map_nxt,
    .mode(GAME),
    .vga_in,
    .vga_out,
    .rgb
);

logic clk_divided;

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
	.won(won_int),
	.lost(lost_int),
	.draw(draw_int),
	.con_error(con_error_int),
	.click_x(mouse_x),
	.click_y(mouse_y),
	.click_e(left_int),
    .mode(mode_int)
);

collisons u_collisions(
    .map,
    .map_nxt,
    .mode(GAME),
    
    .eaten1,
    .eaten2,
    .won(),
    .lost(),
    .draw()
);

move u_move (
    .clk(clk),
    .clk_div(clk_divided),
    .rst,
    .dir1(dir_int),
    .dir2(dir2_int),
    .rcvdir,
    .map,
    .predicted_map(map_nxt),
    .com_err(),
    .eaten1,
    .eaten2
    .rst(rst),
    .dir(dir_int),
    .map(map_move_gen_p)
);

generate_point u_generate_point(
    .clk_75(clk),
    .clk_div(clk_divided),
    .rst(rst),
    .mode(mode_int),
    .map_in(map_move_gen_p),
    .seed_x_in(seed_x_ingoing),
    .seed_y_in(seed_y_ingoing),
    .colision(gain_point),
    .seed_x_out(seed_x_outgoing),
    .seed_y_out(seed_y_outgoing),
    .seed_rdy(send_seed),
    .map_out(map_gen_p_draw)
);

mouse_move u_mouse_move (
    .clk(clk),
    .clk_divided,
    .rst(rst),
    .left(left_int),
    .right(right_int),
    .dir(dir_int)
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
    .tx,
    .dir1(dir_int),
    .dir2(dir2_int),
    .rcvdir
);

endmodule
