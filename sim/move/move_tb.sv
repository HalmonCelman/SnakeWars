`timescale 1 ns / 1 ps

import snake_pkg::*;
import vga_pkg::*;

module move_tb;
/**
 *  Local parameters
 */

localparam CLK_PERIOD = 1000/75; //75MHz

/**
 * Local variables and signals
 */

logic clk, clk_move, rst;

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

logic rcvdir, eaten;
direction dir;

move_n_collisions dut (
    .clk,
    .clk_div(clk_move),
    .rst,
    .dir1(dir),
    .dir2(dir),
    .rcvdir,
    .map,
    .eaten,
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
    {dir, rcvdir} = {LEFT, 1'b0};
    @(posedge clk);
    @(posedge clk_move);
    @(posedge clk_move);
    rcvdir = 1'b0;
    $display("tail x: %d tail y: %d direction: %s, tail tile: %s", map.snake1.tail_x, map.snake1.tail_y, map.snake1.segments[map.snake1.length - 2].name(), map.tiles[map.snake1.tail_y][map.snake1.tail_x].name());

    $finish;
end

endmodule