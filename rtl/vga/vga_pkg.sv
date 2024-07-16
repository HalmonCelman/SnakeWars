/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * Modified by: Krzysztof Korbaś, Emilia Jerdanek
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 70fps using a 75 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;

// Add VGA timing parameters here and refer to them in other modules.
localparam HOR_TOTAL_TIME = 1328;
localparam HOR_BLANK_START = 1024;
localparam HOR_BLANK_TIME = 304;
localparam HOR_SYNC_START = 1048;
localparam HOR_SYNC_TIME = 136;

localparam VER_TOTAL_TIME = 806;
localparam VER_BLANK_START = 768;
localparam VER_BLANK_TIME = 38;
localparam VER_SYNC_START = 771;
localparam VER_SYNC_TIME = 6;

// number of bits in rgb for vga
localparam RGB_B = 12;

endpackage
