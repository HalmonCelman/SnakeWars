`timescale 1ns/1ps 

import snake_pkg::*;
import vga_pkg::*;

module generate_point_tb();

logic clk_75;
logic clk_div;
logic rst;
logic local_start;
game_mode mode;
logic [4:0] seed_x_in;
logic [4:0] seed_y_in;
logic colision;
logic [4:0] seed_x_out;
logic [4:0] seed_y_out;
logic [4:0] point_x;
logic [4:0] point_y;
logic seed_rdy;
generate_point u_generate_point(

	.clk_75,
	.clk_div,
	.rst,
	.mode,
	.seed_x_in,
	.seed_y_in,
	.colision,
	.seed_x_out,
	.seed_y_out,
	.seed_rdy,
	.local_start,
	.point_gen_x(point_x),
	.point_gen_y(point_y)
);

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
	seed_x_in = 5'd1;
	seed_y_in = 5'd1;
	colision = 1'b0;
	local_start = 1'b0;
	rst = 1'b1;
	
	repeat(10) @(posedge clk_75);

	rst = 1'b0;

	repeat(500) @(posedge clk_75);

	local_start = 1'b1;
	mode = GAME;

	repeat(500) @(posedge clk_75);
	
	colision = 1'b1;
	@(posedge clk_div);
	@(posedge clk_75);	
	colision = 1'b0;
	
	repeat(100) @(posedge clk_75);
	colision = 1'b1;
	
	repeat(3) @(posedge clk_div);

	colision = 1'b0;

	repeat(500) @(posedge clk_75);
	
	mode = MENU;
	local_start = 1'b0;

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
