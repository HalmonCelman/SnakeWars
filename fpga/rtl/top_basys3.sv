/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

`timescale 1 ns / 1 ps

module top_basys3 (
    input  wire clk,
    input  wire btnC,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    inout wire PS2Clk,
    inout wire PS2Data,

    input wire JA0,
    output logic JA1,

    output logic led0,
    output logic led1
);

wire clk75MHz, clk100MHz;

logic rx, tx;

assign JA0 = rx;
assign JA1 = tx;
assign led0 = rx;
assign led1 = rx;


(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)
(* CORE_GENERATION_INFO = "clk_wiz_0,clk_wiz_v6_0_13_0_0,{component_name=clk_wiz_0,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=2,clkin1_period=10.000,clkin2_period=10.000,use_power_down=false,use_reset=false,use_locked=false,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}" *)

clk_wiz_0_clk_wiz u_clk(
    .clk,
    .clk100MHz,
    .clk75MHz
);

top u_top(
    .clk100MHz,
    .clk(clk75MHz),
    .rst(btnC),
    .hsync(Hsync),
    .vsync(Vsync),
    .rgb({vgaRed, vgaGreen, vgaBlue}),
    .mouse_clk(PS2Clk),
    .mouse_data(PS2Data),
    .rx,
    .tx
);

endmodule
