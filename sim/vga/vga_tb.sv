/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * Modified by: Krzysztof Korbaś, Emilia Jerdanek
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 25;     // 40 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;

vga_if vga();

/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing dut(
    .clk,
    .rst,
    .vga
);

/**
 * Tasks and functions
 */
 // Here you can declare tasks with immediate assertions (assert).

bit reseted;
task signals_initialized;
    assert(vga.hcount == '0)    else $error("hcount is not 0 at start");
    assert(vga.vcount == '0)    else $error("vcount is not 0 at start");
    assert(vga.hblnk == '0)     else $error("hblnk is not 0 at start");
    assert(vga.vblnk == '0)     else $error("vblnk is not 0 at start");
    assert(vga.hsync == '0)     else $error("hsync is not 0 at start");
    assert(vga.vsync == '0)     else $error("vsync is not 0 at start");
endtask;

/**
 * Assertions
 */

// Here you can declare concurrent assertions (assert property).
// counters check
assert property (@(posedge clk) ((rst == 1) || (reseted == 0) || (vga.hcount < HOR_TOTAL_TIME))) else $error("hcount out of range");
assert property (@(posedge clk) ((rst == 1) || (reseted == 0) || (vga.vcount < VER_TOTAL_TIME))) else $error("vcount out of range");

// hblnk check
assert property (@(posedge clk) ((vga.hcount >= HOR_BLANK_START && vga.hcount < HOR_BLANK_START + HOR_BLANK_TIME) |-> ( vga.hblnk == 1 || rst == 1 || reseted == 0))) else $error("hblnk isn't going up");
assert property (@(posedge clk) ((vga.hcount < HOR_BLANK_START || vga.hcount > HOR_BLANK_START + HOR_BLANK_TIME)  |-> ( vga.hblnk == 0 || rst == 1 || reseted == 0))) else $error("hblnk isn't going down");

// hsync check
assert property (@(posedge clk) ((vga.hcount >= HOR_SYNC_START && vga.hcount < HOR_SYNC_START + HOR_SYNC_TIME) |-> ( vga.hsync == 1 || rst == 1 || reseted == 0))) else $error("hsync isn't going up");
assert property (@(posedge clk) ((vga.hcount < HOR_SYNC_START || vga.hcount > HOR_SYNC_START + HOR_SYNC_TIME)  |-> ( vga.hsync == 0 || rst == 1 || reseted == 0))) else $error("hsync isn't going down");

// vblnk check
assert property (@(posedge clk) ((vga.vcount >= VER_BLANK_START && vga.vcount < VER_BLANK_START + VER_BLANK_TIME) |-> ( vga.vblnk == 1 || rst == 1 || reseted == 0))) else $error("vblnk isn't going up");
assert property (@(posedge clk) ((vga.vcount < VER_BLANK_START || vga.vcount > VER_BLANK_START + VER_BLANK_TIME)  |-> ( vga.vblnk == 0 || rst == 1 || reseted == 0))) else $error("vblnk isn't going down");

// vsync check
assert property (@(posedge clk) ((vga.vcount >= VER_SYNC_START && vga.vcount < VER_SYNC_START + VER_SYNC_TIME) |-> ( vga.vsync == 1 || rst == 1 || reseted == 0))) else $error("vsync isn't going up");
assert property (@(posedge clk) ((vga.vcount < VER_SYNC_START || vga.vcount > VER_SYNC_START + VER_SYNC_TIME)  |-> ( vga.vsync == 0 || rst == 1 || reseted == 0))) else $error("vsync isn't going down");


/**
 * Main test
 */

initial begin
    reseted = 0;

    @(posedge rst);
    @(negedge rst);

    reseted = 1;

    signals_initialized();

    wait (vga.vsync == 1'b0);
    @(negedge vga.vsync)
    @(negedge vga.vsync)

    $finish;
end

endmodule