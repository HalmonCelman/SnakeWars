/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module generate_point(
    input logic clk_75,
    input logic clk_div,
    input logic rst,
    input logic game_mode mode,
    input logic map_s map_in,
	input logic seed_x_p2,
	input logic seed_y_p2,
	input logic colision,
    
    output wire map_s map_out
);

function [5:0] lfsr(logic [5:0] in_num);
    return {in_num[4], in_num[3], in_num[2], in_num[1], in_num[0] ^ in_num[5], in_num[5]};
endfunction

logic [5:0] point_x, point_y, seed_x, seed_y;
game_mode mode_prvs;


always_ff @(posedge clk_75) begin : seed_generation
    if(rst) begin
        seed_x <= 6'b1;
        seed_y <= 6'b1;
    end else if(mode == MENU && mode_prvs) begin
        seed_x <= ((seed_x + seed_x_p2) % 62) + 1;
        seed_y <= ((seed_y + seed_y_p2) % 46) + 1;
    end else if(mode == MENU) begin
        seed_x <= (seed_x + 1) % 62;
        seed_y <= ((seed_y + 3)*seed_x) % 46;
    end else begin
        seed_x <= seed_x;
        seed_y <= seed_y;
    end

	if(rst)
		mode_prvs <= MENU;
	else 
		mode_prvs <= mode;
end


always_ff @(posedge clk_div) begin : point_generation 
    if(rst) begin
        point_x <= 6'b1;
        point_y <= 6'b1;       
    end else if(mode == MENU) begin;
        point_x <= seed_x;
        point_y <= seed_y;
    end else if (mode == GAME && colision) begin
        point_x <= lfsr(point_x);
        point_y <= lfsr(point_y);
    end else begin
        point_x <= point_x;
        point_y <= point_y;
    end
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
