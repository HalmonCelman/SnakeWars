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
import vga_pkg::*;

module draw_tb;
/**
 *  Local parameters
 */

localparam CLK_PERIOD = 1000/75; //75MHz

/**
 * Local variables and signals
 */

logic clk, rst;
logic vs, hs;
logic [3:0] r, g, b;

/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Submodules instances
 */

//connections
map_if map();
vga_if vga_in(), vga_out();
logic [RGB_B-1:0] rgb;

game_mode mode;

vga_timing u_vga_timing(
    .clk,
    .rst,
    .vga(vga_in)
);

draw dut (
    .clk,
    .rst,
    .map,
    .mouse_x(12'd20),
    .mouse_y(12'd20),
    .mode,
    .vga_in,
    .vga_out,
    .rgb
);

always_comb begin
    vs = vga_out.vsync;
    hs = vga_out.hsync;
    {r,g,b} = rgb;
end

tiff_writer #(
    .XDIM(16'd1328),
    .YDIM(16'd806),
    .FILE_DIR("../../results")
) u_tiff_writer (
    .clk(clk),
    .r({r,r}), // fabricate an 8-bit value
    .g({g,g}), // fabricate an 8-bit value
    .b({b,b}), // fabricate an 8-bit value
    .go(vs)
);


/**
 * Main test
 */

initial begin
    // setup map for testing
    map.tiles[1][0]=EMPTY;
    map.tiles[1][1]=WALL;
    map.tiles[1][2]=SNAKE1;
    map.tiles[1][3]=SNAKE2;
    map.tiles[1][4]=POINT;


    rst = 1'b0;
    mode = MENU;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");

    wait (vs == 1'b0);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    mode = ERROR;
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    mode = WIN;
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    mode = LOSE;
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    mode = DRAW;
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    mode = GAME;
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule