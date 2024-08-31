`timescale 1ns/1ps 

import snake_pkg::*;
import vga_pkg::*;

module generate_point_tb();

generate_point u_generate_point(

	.clk_75,
	.clk_div,
	.rst,
	.mode,
	.map_in,
	.seed_x_in,
	.seed_y_in,
	.colision,
	.seed_x_out,
	.seed_y_out,
	.seed_rdy,
	.map_out
);


logic clk_75;
logic clk_div;
logic rst;
game_mode mode;
map_s map_in;
logic [4:0] seed_x_in;
logic [4:0] seed_y_in;
logic colision;
logic [4:0] seed_x_out;
logic [4:0] seed_y_out;
logic seed_rdy;
map_s map_out;


initial begin
	clk_75 = 1'b0;
	forever #(1000/75) clk_75 = ~clk_75; 
end


initial begin
	clk_div = 1'b0;
	forever #(1000/5) clk_div = ~clk_div; 
end


initial begin
	mode = MENU;
	seed_x_in = 5'd0;
	seed_y_in = 5'd0;
	colision = 1'b0;
	rst = 1'b1;
	
	repeat(10) @(posedge clk_75);

	rst = 1'b0;

	repeat(500) @(posedge clk_75);

	mode = GAME;

	repeat(500) @(posedge clk_75);
	
	colision = 1'b1;
	@(posedge clk_div);
	@(posedge clk_75);
	colision = 1'b0;
	
	repeat(500) @(posedge clk_75);

	$finish();	
end


endmodule
