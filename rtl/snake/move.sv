/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module move(
    input wire clk,
    input wire clk_div,
    input wire rst,
    input direction dir,

    output map_s map
);

map_s map_nxt;
logic clk_div_prv;

always_ff @(posedge clk) begin
    if(rst) begin
        map.snake1.length <= START_LENGTH;
        map.snake1.head_x <= START_POS_X;
        map.snake1.head_y <= START_POS_Y;
        map.snake1.tail_x <= START_POS_X;
        map.snake1.tail_y <= START_POS_Y+START_LENGTH-1;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                if((i>=START_POS_Y && i<START_POS_Y+START_LENGTH) && (j==START_POS_X)) begin
                    map.tiles[i][j] <= SNAKE1;
                end else begin
                    map.tiles[i][j] <= EMPTY;
                end
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            if(k<START_LENGTH-1) begin
                map.snake1.segments[k] <= UP;
            end
        end

    end else begin
        map.snake1.length <= map_nxt.snake1.length;
        map.snake1.head_x <= map_nxt.snake1.head_x;
        map.snake1.head_y <= map_nxt.snake1.head_y;
        map.snake1.tail_x <= map_nxt.snake1.tail_x;
        map.snake1.tail_y <= map_nxt.snake1.tail_y;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                map.tiles[i][j] <= map_nxt.tiles[i][j];
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            map.snake1.segments[k] <= map_nxt.snake1.segments[k];
        end
    end

    clk_div_prv <= clk_div;
end

always_comb begin
    if((clk_div_prv == 1'b0) && (clk_div == 1'b1)) begin
        map_nxt.snake1.length = map.snake1.length;

        case(dir)
            NONE: begin 
                map_nxt.snake1.head_x = map.snake1.head_x;
                map_nxt.snake1.head_y = map.snake1.head_y;
            end
            UP: begin 
                map_nxt.snake1.head_x = map.snake1.head_x;
                map_nxt.snake1.head_y = map.snake1.head_y-1;
            end
            DOWN: begin 
                map_nxt.snake1.head_x = map.snake1.head_x;
                map_nxt.snake1.head_y = map.snake1.head_y+1;
            end
            RIGHT: begin 
                map_nxt.snake1.head_x = map.snake1.head_x+1;
                map_nxt.snake1.head_y = map.snake1.head_y;
            end
            LEFT: begin 
                map_nxt.snake1.head_x = map.snake1.head_x-1;
                map_nxt.snake1.head_y = map.snake1.head_y;
            end
            default: begin 
                map_nxt.snake1.head_x = map.snake1.head_x;
                map_nxt.snake1.head_y = map.snake1.head_y;
            end
        endcase

        case(map.snake1.segments[map.snake1.length-2])
            NONE: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
            UP: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y-1;
            end
            DOWN: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y+1;
            end
            RIGHT: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x+1;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
            LEFT: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x-1;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
            default: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
        endcase

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            if(k<START_LENGTH-1) begin
                if(dir != NONE) begin
                    if(k==0)    map_nxt.snake1.segments[k] = dir;
                    else        map_nxt.snake1.segments[k] = map.snake1.segments[k-1];
                end else begin
                    map_nxt.snake1.segments[k] = map.snake1.segments[k];
                end
            end else begin
                map_nxt.snake1.segments[k] = NONE;
            end
        end

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                if(dir != NONE) begin
                    if(map_nxt.snake1.head_y == i && map_nxt.snake1.head_x == j)      map_nxt.tiles[i][j] = SNAKE1;
                    else if(map.snake1.tail_y == i && map.snake1.tail_x == j)         map_nxt.tiles[i][j] = EMPTY;
                    else map_nxt.tiles[i][j] = map.tiles[i][j];
                end else begin
                    map_nxt.tiles[i][j] = map.tiles[i][j];
                end
            end
        end
    end else begin
        map_nxt.snake1.length = map.snake1.length;
        map_nxt.snake1.head_x = map.snake1.head_x;
        map_nxt.snake1.head_y = map.snake1.head_y;
        map_nxt.snake1.tail_x = map.snake1.tail_x;
        map_nxt.snake1.tail_y = map.snake1.tail_y;
        
        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            map_nxt.snake1.segments[k] = map.snake1.segments[k];
        end

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                map_nxt.tiles[i][j] = map.tiles[i][j];
            end
        end
    end
end

endmodule