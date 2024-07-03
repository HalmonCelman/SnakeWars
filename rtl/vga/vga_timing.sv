/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Vga timing controller.
 */

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk,
    input  logic rst,
    vga_if.out vga
);

import vga_pkg::*;

/**
 * Local variables and signals
 */

    logic [10:0] vcount_nxt;
    logic vsync_nxt;
    logic vblnk_nxt;

    logic [10:0] hcount_nxt;
    logic hsync_nxt;
    logic hblnk_nxt;

/**
 * Internal logic
 */

    always_ff @(posedge clk) begin
        if(rst) begin
            vga.vcount <= '0;
            vga.vsync <= 1'b0;
            vga.vblnk <= 1'b0;

            vga.hcount <= '0;
            vga.hsync <= 1'b0;
            vga.hblnk <= 1'b0;
        end else begin
            vga.vcount <= vcount_nxt;
            vga.vsync <= vsync_nxt;
            vga.vblnk <= vblnk_nxt;

            vga.hcount <= hcount_nxt;
            vga.hsync <= hsync_nxt;
            vga.hblnk <= hblnk_nxt;
        end
    end

    always_comb begin
        if( vga.hcount < HOR_TOTAL_TIME - 1) begin
            hcount_nxt = vga.hcount + 1;
            vcount_nxt = vga.vcount;
        end else begin
            hcount_nxt = '0;
            if( vga.vcount < VER_TOTAL_TIME - 1) begin
                vcount_nxt = vga.vcount + 1;
            end else begin
                vcount_nxt = '0;
            end
        end

        hsync_nxt = (hcount_nxt >= HOR_SYNC_START && hcount_nxt < (HOR_SYNC_START + HOR_SYNC_TIME)) ?  1'b1 : 1'b0;
        hblnk_nxt = (hcount_nxt >= HOR_BLANK_START && hcount_nxt < (HOR_BLANK_START + HOR_BLANK_TIME)) ?  1'b1 : 1'b0;
        
        vsync_nxt = (vcount_nxt >= VER_SYNC_START && vcount_nxt < (VER_SYNC_START + VER_SYNC_TIME)) ?  1'b1 : 1'b0;
        vblnk_nxt = (vcount_nxt >= VER_BLANK_START && vcount_nxt < (VER_BLANK_START + VER_BLANK_TIME)) ?  1'b1 : 1'b0;

    end


endmodule
