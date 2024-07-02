// by KK

`timescale 1 ns / 1 ps

module top (
    input wire clk,
    input wire rst,
    input wire PCenBtn,
    input wire PCen,
    input wire extCtlBtn,
    input wire micRstBtn,
    input wire [5:0] ctrlBtns,
    input wire rx,
    output logic tx,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp,
    output logic led
);

logic [3:0][3:0] hex;
logic [7:0] w_addr;
logic [15:0] w_data;
logic w_en;

microDebug u_microDebug(
    .clk,
    .rst,
    .micRstBtn,
    .PCenBtn,
    .PCen,
    .extCtlBtn,
    .iram_wa(w_addr),
    .iram_wen(w_en),
    .iram_din(w_data),
    .mode(ctrlBtns[1:0]),
    .register(ctrlBtns[5:2]),
    .monitorValue(hex[0:3]),
    .bit0(led)
);

disp_hex_mux u_disp_hex_mux(
    .clk,
    .reset(rst),
    .an({an[0], an[1], an[2], an[3]}),
    .sseg({dp, seg[0], seg[1], seg[2], seg[3], seg[4], seg[5], seg[6]}),
    .dp_in('1),
    .hex0(hex[0]),
    .hex1(hex[1]),
    .hex2(hex[2]),
    .hex3(hex[3])
);

get_memory u_get_memory(
    .clk,
    .rst,
    .rx,
    .tx,
    .read_ready(w_en),
    .addr(w_addr),
    .memory(w_data)
);

endmodule
