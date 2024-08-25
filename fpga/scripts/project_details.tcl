# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name UEC2

# Top module name                               -- EDIT
set top_module top_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_basys3.xdc
    constraints/clk_wiz_0.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    rtl/top_basys3.sv
    ../rtl/mouse/mouse_control.sv
    ../rtl/snake/draw/draw_draw.sv
    ../rtl/snake/draw/draw_error.sv
    ../rtl/snake/draw/draw_game.sv
    ../rtl/snake/draw/draw_lose.sv
    ../rtl/snake/draw/draw_menu.sv
    ../rtl/snake/draw/draw_mouse.sv
    ../rtl/snake/draw/draw_rect_char.sv
    ../rtl/snake/draw/draw_rect.sv
    ../rtl/snake/draw/draw_text.sv
    ../rtl/snake/draw/draw_win.sv
    ../rtl/snake/draw/draw.sv
    ../rtl/snake/draw/rom/font_rom.sv
    ../rtl/snake/draw/rom/texts/txt_back_to_menu.sv
    ../rtl/snake/draw/rom/texts/txt_connection_error.sv
    ../rtl/snake/draw/rom/texts/txt_draw.sv
    ../rtl/snake/draw/rom/texts/txt_lose.sv
    ../rtl/snake/draw/rom/texts/txt_one_player.sv
    ../rtl/snake/draw/rom/texts/txt_settings.sv
    ../rtl/snake/draw/rom/texts/txt_two_players.sv
    ../rtl/snake/draw/rom/texts/txt_win.sv
    ../rtl/snake/mouse_move.sv
    ../rtl/snake/move.sv
    ../rtl/snake/collisions.sv
    ../rtl/snake/communicate.sv
    ../rtl/snake/generate_point.sv
    ../rtl/snake/snake_pkg.sv
    ../rtl/utils/delay.sv
    ../rtl/utils/clk_div.sv
    ../rtl/vga/vga_if.sv
    ../rtl/vga/vga_pkg.sv
    ../rtl/vga/vga_timing.sv
    ../rtl/top.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    rtl/clk_wiz_0_clk_wiz.v
    ../rtl/uart/flag_buf.v
    ../rtl/uart/uart_rx.v
    ../rtl/uart/uart_tx.v
    ../rtl/uart/uart.v
    ../rtl/utils/fifo.v
    ../rtl/utils/mod_m_counter.v
}

# Specify VHDL design files location            -- EDIT
set vhdl_files {
    ../rtl/mouse/MouseCtl.vhd
    ../rtl/mouse/MouseDisplay.vhd
    ../rtl/mouse/Ps2Interface.vhd
}

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }
