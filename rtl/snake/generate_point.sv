/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module generate_point(
    input logic         clk_75,
    input logic         clk_div,
    input logic         rst,
    input game_mode     mode,
	input logic [4:0]   seed_x_in,
	input logic [4:0]   seed_y_in,
	input logic         colision,
	input logic 		local_start,
    
	output logic [4:0]   seed_x_out,
	output logic [4:0]   seed_y_out,
	output logic         seed_rdy,
    output logic [4:0]   point_gen_x,
    output logic [4:0]   point_gen_y
);


function [4:0] lfsr(logic [4:0] in_num);
    return {in_num[3], in_num[2], in_num[1], in_num[0] ^ in_num[4], in_num[4]};
endfunction


logic [4:0] point_x, point_y, seed_x, seed_y;
game_mode mode_prvs_point;

assign point_gen_x = point_x;//(seed_y_in ? (MAP_WIDTH-point_x-1): point_x);
assign point_gen_y = point_y;//(seed_y_in ? (MAP_HEIGHT-point_y-1): point_y);

assign seed_x_out = seed_x;
assign seed_y_out = seed_y;

always_ff @(posedge clk_75) begin : seed_generation
    if(rst) begin
        seed_x 		<= 5'd1;
        seed_y 		<= 5'd23;
    end else if(mode == MENU) begin
        seed_x <= (seed_x + 1) % 31;
        seed_y <= (seed_y + 1) % 23;
    end else begin
        seed_x <= seed_x;
        seed_y <= seed_y;
    end
end


always_ff @(posedge clk_75) begin : seed_rdy_control_signal_for_uart
	if(rst) begin
		seed_rdy <= 1'b0;
    end else if (mode == GAME && local_start) begin
		seed_rdy <= 1'b1;
    end else 
		seed_rdy <= 1'b0;
end

logic clk_div_prv, clk_div_reg, pos_clk_div;
assign pos_clk_div = ((clk_div_prv == 1'b0) && (clk_div_reg == 1'b1));

always_ff @(posedge clk_75) begin : point_generation 
    if(rst) begin
        point_x <= 5'b0;
        point_y <= 5'b0;       
    end else if(mode == GAME && mode_prvs_point == MENU && !local_start) begin
        point_x <= ((seed_x_in) % 30) + 1;
        point_y <= ((seed_y_in) % 22) + 1;
    end else if(mode == GAME && mode_prvs_point == MENU && local_start) begin
        point_x <= ((seed_x) % 30) + 1;
        point_y <= ((seed_y) % 22) + 1;
    end else if (mode == GAME && colision && pos_clk_div) begin
        point_x <= (lfsr(point_x) % 30) + 1;
        point_y <= (lfsr(point_y) % 22) + 1;
    end else begin
        point_x <= point_x;
        point_y <= point_y;
    end

    mode_prvs_point <= mode;
    clk_div_reg <= clk_div;
    clk_div_prv <= clk_div_reg;
end

endmodule
