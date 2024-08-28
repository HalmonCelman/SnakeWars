/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by: Piotr Kaczmarczyk, Krzysztof Korbaś, Emilia Jerdanek
 *
 * Description:
 * Testbench for top_vga.
 * Thanks to the tiff_writer module, an expected image
 * produced by the project is exported to a tif file.
 * Since the vs signal is connected to the go input of
 * the tiff_writer, the first (top-left) pixel of the tif
 * will not correspond to the vga project (0,0) pixel.
 * The active image (not blanked space) in the tif file
 * will be shifted down by the number of lines equal to
 * the difference between VER_SYNC_START and VER_TOTAL_TIME.
 */

`timescale 1 ns / 1 ps

import snake_pkg::*;

module move_tb;
/**
 *  Local parameters
 */

localparam CLK_PERIOD = 1000/75; //75MHz

/**
 * Local variables and signals
 */

logic clk, clk_move, rst;
logic vs, hs;
logic [3:0] r, g, b;

/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
    clk_move = 1'b0;
    forever begin
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        clk_move = ~clk_move;
    end
end

/**
 * Submodules instances
 */

//connections
map_s map;

logic rcvdir, eaten1, eaten2;
direction dir;

move u_move (
    .clk,
    .clk_div(clk_move),
    .rst,
    .dir1(dir),
    .dir2(dir),
    .rcvdir,
    .map,
    .eaten1,
    .eaten2,
    .com_err()
);

/**
 * Main test
 */

initial begin
    rcvdir = 1'b0;   rst = 1'b0;
    @(posedge clk);  rst = 1'b1;
    @(posedge clk);  rst = 1'b0;

    $display("Starting move simulation...");

    $display("Moving LEFT, eating");
    {dir, rcvdir, eaten1, eaten2} = {LEFT, 1'b0, 1'b0, 1'b0};
    @(posedge clk);
    @(posedge clk_move);
    @(posedge clk_move);
    rcvdir = 1'b0;
    $display("tail x: %d tail y: %d direction: %s, tail tile: %s", map.snake1.tail_x, map.snake1.tail_y, map.snake1.segments[map.snake1.length - 2].name(), map.tiles[map.snake1.tail_y][map.snake1.tail_x].name());

    $finish;
end

endmodule