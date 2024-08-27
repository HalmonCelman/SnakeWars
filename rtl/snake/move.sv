/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module move(
    input wire clk,
    input wire clk_div,
    input wire rst,
    input direction dir1,
    input direction dir2,
    input wire rcvdir,

    output map_s map,
    output logic com_err
);

map_s map_nxt;
logic clk_div_prv;
logic refreshed, refreshed_nxt;
logic com_err_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        com_err <= 1'b0;
        refreshed <= 1'b1;

        map.snake1.length <= START_LENGTH;
        map.snake1.head_x <= START_POS_X;
        map.snake1.head_y <= START_POS_Y;
        map.snake1.tail_x <= START_POS_X;
        map.snake1.tail_y <= START_POS_Y+START_LENGTH-1;

        map.snake2.length <= START_LENGTH;
        map.snake2.head_x <= START_POS_X_2;
        map.snake2.head_y <= START_POS_Y_2+START_LENGTH-1;
        map.snake2.tail_x <= START_POS_X_2;
        map.snake2.tail_y <= START_POS_Y_2;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                if(i==0 || i==MAP_WIDTH-1 || j==0 || j==MAP_HEIGHT-1) begin
                    map.tiles[i][j] <= WALL;
                end else if((i>=START_POS_Y && i<START_POS_Y+START_LENGTH) && (j==START_POS_X)) begin
                    map.tiles[i][j] <= SNAKE1;
                end else if((i>=START_POS_Y_2 && i<START_POS_Y_2+START_LENGTH) && (j==START_POS_X_2)) begin
                    map.tiles[i][j] <= SNAKE2;
                end else begin
                    map.tiles[i][j] <= EMPTY;
                end
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            if(k<START_LENGTH-1) begin
                map.snake1.segments[k] <= UP;
                map.snake2.segments[k] <= UP;
            end
        end

    end else begin
        com_err <= com_err_nxt;
        refreshed <= refreshed_nxt;

        map.snake1.length <= map_nxt.snake1.length;
        map.snake1.head_x <= map_nxt.snake1.head_x;
        map.snake1.head_y <= map_nxt.snake1.head_y;
        map.snake1.tail_x <= map_nxt.snake1.tail_x;
        map.snake1.tail_y <= map_nxt.snake1.tail_y;

        map.snake2.length <= map_nxt.snake2.length;
        map.snake2.head_x <= map_nxt.snake2.head_x;
        map.snake2.head_y <= map_nxt.snake2.head_y;
        map.snake2.tail_x <= map_nxt.snake2.tail_x;
        map.snake2.tail_y <= map_nxt.snake2.tail_y;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                map.tiles[i][j] <= map_nxt.tiles[i][j];
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            map.snake1.segments[k] <= map_nxt.snake1.segments[k];
            map.snake2.segments[k] <= map_nxt.snake2.segments[k];
        end
    end

    clk_div_prv <= clk_div;
end

always_comb begin
    if((clk_div_prv == 1'b0) && (clk_div == 1'b1)) begin
        // TODO collision with point
        map_nxt.snake1.length = map.snake1.length;

        case(dir1)
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
                if(dir1 != NONE) begin
                    if(k==0)    map_nxt.snake1.segments[k] = dir1;
                    else        map_nxt.snake1.segments[k] = map.snake1.segments[k-1];
                end else begin
                    map_nxt.snake1.segments[k] = map.snake1.segments[k];
                end
            end else begin
                map_nxt.snake1.segments[k] = NONE;
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
    end

    if(rcvdir) begin // if uart direction provided
        // TODO collision with point
        map_nxt.snake2.length = map.snake2.length;

        case(dir2)
            NONE: begin 
                map_nxt.snake2.head_x = map.snake2.head_x;
                map_nxt.snake2.head_y = map.snake2.head_y;
            end
            UP: begin 
                map_nxt.snake2.head_x = map.snake2.head_x;
                map_nxt.snake2.head_y = map.snake2.head_y+1;
            end
            DOWN: begin 
                map_nxt.snake2.head_x = map.snake2.head_x;
                map_nxt.snake2.head_y = map.snake2.head_y-1;
            end
            RIGHT: begin 
                map_nxt.snake2.head_x = map.snake2.head_x-1;
                map_nxt.snake2.head_y = map.snake2.head_y;
            end
            LEFT: begin 
                map_nxt.snake2.head_x = map.snake2.head_x+1;
                map_nxt.snake2.head_y = map.snake2.head_y;
            end
            default: begin 
                map_nxt.snake2.head_x = map.snake2.head_x;
                map_nxt.snake2.head_y = map.snake2.head_y;
            end
        endcase

        case(map.snake2.segments[map.snake2.length-2])
            NONE: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
            UP: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y+1;
            end
            DOWN: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y-1;
            end
            RIGHT: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x-1;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
            LEFT: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x+1;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
            default: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
        endcase

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            if(k<START_LENGTH-1) begin
                if(dir2 != NONE) begin
                    if(k==0)    map_nxt.snake2.segments[k] = dir2;
                    else        map_nxt.snake2.segments[k] = map.snake2.segments[k-1];
                end else begin
                    map_nxt.snake2.segments[k] = map.snake2.segments[k];
                end
            end else begin
                map_nxt.snake2.segments[k] = NONE;
            end
        end

    end else begin
        map_nxt.snake2.length = map.snake2.length;
        map_nxt.snake2.head_x = map.snake2.head_x;
        map_nxt.snake2.head_y = map.snake2.head_y;
        map_nxt.snake2.tail_x = map.snake2.tail_x;
        map_nxt.snake2.tail_y = map.snake2.tail_y;
        
        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            map_nxt.snake2.segments[k] = map.snake2.segments[k];
        end
    end

    if(((clk_div_prv == 1'b0) && (clk_div == 1'b1)) || rcvdir) begin
        if(rcvdir) begin
            refreshed_nxt = 1'b1;
            com_err_nxt = com_err;
        end else begin
            if(refreshed == 1'b0) begin
                com_err_nxt = 1'b1;
            end else begin
                com_err_nxt = com_err;
            end

            refreshed_nxt = 1'b0;
        end

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                if(map_nxt.snake1.head_y == i && map_nxt.snake1.head_x == j)                map_nxt.tiles[i][j] = SNAKE1;
                else if(map_nxt.snake2.head_y == i && map_nxt.snake2.head_x == j)           map_nxt.tiles[i][j] = SNAKE2;
                else if(map.snake1.tail_y == i && map.snake1.tail_x == j && dir1 != NONE)   map_nxt.tiles[i][j] = EMPTY;
                else if(map.snake2.tail_y == i && map.snake2.tail_x == j && dir2 != NONE)   map_nxt.tiles[i][j] = EMPTY;
                else map_nxt.tiles[i][j] = map.tiles[i][j];
            end
        end
    end else begin
        com_err_nxt = com_err;
        refreshed_nxt = refreshed;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                map_nxt.tiles[i][j] = map.tiles[i][j];
            end
        end
    end
end

endmodule