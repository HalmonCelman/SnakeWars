/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: KK
 *
 * Description:
 * Create Interface for VGA
 */

 interface vga_if;
    logic [10:0] vcount;
    logic vsync;
    logic vblnk;
    logic [10:0] hcount;
    logic hsync;
    logic hblnk;

    modport in(
        input vcount,
        input vsync,
        input vblnk,
        input hcount,
        input hsync,
        input hblnk
    );

    modport out(
        output vcount,
        output vsync,
        output vblnk,
        output hcount,
        output hsync,
        output hblnk
    );
 endinterface