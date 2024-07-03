// by KK

`timescale 1 ns / 1 ps

module top_basys3 (
    input  wire clk,
    input wire btnC,
    output logic led
);

logic clk100MHz;

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)
(* CORE_GENERATION_INFO = "clk_wiz_0,clk_wiz_v6_0_13_0_0,{component_name=clk_wiz_0,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,enable_axi=0,feedback_source=FDBK_AUTO,PRIMITIVE=MMCM,num_out_clk=1,clkin1_period=10.000,clkin2_period=10.000,use_power_down=false,use_reset=false,use_locked=false,use_inclk_stopped=false,feedback_type=SINGLE,CLOCK_MGR_TYPE=NA,manual_override=false}" *)

clk_wiz_0_clk_wiz u_clk(
    .clk,
    .clk100MHz
);

top u_top(
    .clk(clk100MHz),
    .rst(btnC),
    .led
);

endmodule
