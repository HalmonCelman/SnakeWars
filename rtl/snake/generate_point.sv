/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module generate_point(
    input logic         clk_75,
    input logic         clk_div,
    input logic         rst,
    input game_mode     mode,
    input map_s         map_in,
	input logic [5:0]   seed_x_in,
	input logic [5:0]   seed_y_in,
	input logic         colision,
    
	output logic [5:0]   seed_x_out,
	output logic [5:0]   seed_y_out,
	output logic        seed_rdy,
    output map_s        map_out
);


function [5:0] lfsr(logic [5:0] in_num);
    return {in_num[4], in_num[3], in_num[2], in_num[1], in_num[0] ^ in_num[5], in_num[5]};
endfunction


logic [5:0] point_x, point_y, seed_x, seed_y;
game_mode mode_prvs_point, mode_prvs_seed;


assign seed_x_out = seed_x;
assign seed_y_out = seed_y;


always_ff @(posedge clk_75) begin : seed_generation
    if(rst) begin
        seed_x 		<= 6'd1;
        seed_y 		<= 6'd23;
    end else if(mode == MENU) begin
        seed_x <= (seed_x + 1) % 62;
        seed_y <= (seed_y + 1) % 46;
    end else begin
        seed_x <= seed_x;
        seed_y <= seed_y;
    end
	
	if(rst)
		mode_prvs_seed <= MENU;
	else 
		mode_prvs_seed <= mode;
end


always_ff @(posedge clk_75) begin : seed_rdy_control_signal_for_uart
	if(rst)
		seed_rdy <= 1'b0;
	else if (mode == GAME && mode_prvs_seed == MENU)
		seed_rdy <= 1'b1;
	else 
		seed_rdy <= 1'b0;
end


always_ff @(posedge clk_div) begin : point_generation 
    if(rst) begin
        point_x <= 6'b0;
        point_y <= 6'b0;       
    end else if(mode == GAME && mode_prvs_point == MENU) begin
        point_x <= ((seed_x + seed_x_in) % 62) + 1;
        point_y <= ((seed_y + seed_y_in) % 46) + 1;
    end else if (mode == GAME && colision) begin
        point_x <= (lfsr((point_x)) % 62) + 1;
        point_y <= (lfsr((point_y)) % 46) + 1;
    end else begin
        point_x <= point_x;
        point_y <= point_y;
    end
	
	if(rst)
		mode_prvs_point <= MENU;
	else 
		mode_prvs_point <= mode;
end


always_ff @(posedge clk_75) begin : map_update
    if(rst) begin
        map_out.snake1.length <= START_LENGTH;
        map_out.snake1.head_x <= START_POS_X;
        map_out.snake1.head_y <= START_POS_Y;
        map_out.snake1.tail_x <= START_POS_X;
        map_out.snake1.tail_y <= START_POS_Y+START_LENGTH-1;

        map_out.snake2.length <= START_LENGTH;
        map_out.snake2.head_x <= START_POS_X_2;
        map_out.snake2.head_y <= START_POS_Y_2;
        map_out.snake2.tail_x <= START_POS_X_2;
        map_out.snake2.tail_y <= START_POS_Y_2+START_LENGTH-1;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                if((i>=START_POS_Y && i<START_POS_Y+START_LENGTH) && (j==START_POS_X)) begin
                    map_out.tiles[i][j] <= SNAKE1;
                end else if((i>=START_POS_Y_2 && i<START_POS_Y_2+START_LENGTH) && (j==START_POS_X_2)) begin
                    map_out.tiles[i][j] <= SNAKE2;
                end else begin
                    map_out.tiles[i][j] <= EMPTY;
                end
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            if(k<START_LENGTH-1) begin
                map_out.snake1.segments[k] <= UP;
                map_out.snake2.segments[k] <= UP;
            end
        end

    end else begin 
        map_out.snake1.length <= map_in.snake1.length;
        map_out.snake1.head_x <= map_in.snake1.head_x;
        map_out.snake1.head_y <= map_in.snake1.head_y;
        map_out.snake1.tail_x <= map_in.snake1.tail_x;
        map_out.snake1.tail_y <= map_in.snake1.tail_y;

        map_out.snake2.length <= map_in.snake2.length;
        map_out.snake2.head_x <= map_in.snake2.head_x;
        map_out.snake2.head_y <= map_in.snake2.head_y;
        map_out.snake2.tail_x <= map_in.snake2.tail_x;
        map_out.snake2.tail_y <= map_in.snake2.tail_y;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
				if(point_x + point_y == 0) 
                	map_out.tiles[i][j] <= map_in.tiles[i][j];
				else
					map_out.tiles[i][j] <= i == point_y && j == point_x ? map_in.tiles[i][j] != POINT ? POINT : map_in.tiles[i][j] : map_in.tiles[i][j];
				
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            map_out.snake1.segments[k] <= map_in.snake1.segments[k];
            map_out.snake2.segments[k] <= map_in.snake2.segments[k];
        end
    end
end

endmodule
