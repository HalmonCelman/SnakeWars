/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module mode_control(
    input wire clk,
    input wire clk_div,
    input wire rst,
    input direction dir,

    output map_s map
);

map_s map_nxt;
logic clk_div_prv;
