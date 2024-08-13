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

vga_timing u_vga_timing(
    .clk,
    .rst,
    .vga(vga_in)
);

draw u_draw (
    .clk,
    .rst,
    .map,
    .mouse_x(12'd20),
    .mouse_y(12'd20),
    .mode(GAME),
    .vga_in,
    .vga_out,
    .rgb
);

logic clk_move;
direction dir;

move u_move (
    .clk(clk_move),
    .rst,
    .dir,
    .map
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
            rst = 1'b0; clk_move = 1'b0;
    # 30    rst = 1'b1; clk_move = 1'b1;
    # 30    rst = 1'b0; clk_move = 1'b0;

    $display("If simulation ends before the testbench");
    $display("completes, use the menu option to run all.");
    $display("Prepare to wait a long time...");

    wait (vs == 1'b0);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    dir = LEFT;
    clk_move = 1'b1; 
    #30 clk_move = 1'b0; 
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    dir = UP;
    clk_move = 1'b1; 
    #30 clk_move = 1'b0; 
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    dir = RIGHT;
    clk_move = 1'b1; 
    #30 clk_move = 1'b0; 
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    dir = DOWN;
    clk_move = 1'b1; 
    #30 clk_move = 1'b0; 
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    dir = NONE;
    clk_move = 1'b1; 
    #30 clk_move = 1'b0; 
    @(negedge vs) $display("Info: negedge VS at %t",$time);
    // End the simulation.
    $display("Simulation is over, check the waveforms.");
    $finish;
end

endmodule