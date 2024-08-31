`timescale 1 ns / 1 ps

import snake_pkg::*;
import vga_pkg::*;

module collisions_tb;
/**
 *  Local parameters
 */

localparam CLK_PERIOD = 1000/75; //75MHz

logic clk, rst;
logic rcvdir, refreshed, clk_divided, eaten1, eaten2, eaten1_pre, eaten2_pre, won, lost, draw; 

/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
    clk_divided = 1'b0;
    forever begin
        @(posedge clk);
        @(posedge clk);
        rcvdir = 1'b1;
        @(posedge clk);
        rcvdir = 1'b0;
        @(posedge clk);
        @(posedge clk);
        clk_divided = ~clk_divided;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        clk_divided = ~clk_divided;
    end
end

/**
 * Submodules instances
 */

//connections
map_s map, map_nxt, map_reg;

/*
move u_move (
    .clk,
    .clk_div(clk_divided),
    .rst,
    .dir1(UP),
    .dir2(UP),
    .rcvdir,
    .map,
    .map_nxt,
    .com_err(),
    .eaten1(eaten1_pre),
    .eaten2(eaten2_pre),
    .refreshed
);*/

collisons u_collisions(
    .clk,
    .rst,
    .clk_div(clk_divided),
    .dir1(UP),
    .dir2(UP),
    .map(map_reg),
    .map_nxt,
    .mode(GAME),
    .eaten1,
    .eaten2,
    .eaten1_pre,
    .eaten2_pre,
    .won,
    .lost,
    .draw
);

generate_point u_generate_point(
    .clk_75(clk),
    .clk_div(clk_divided),
    .rst(rst),
    .mode(GAME),
    .map_in(map),
    .seed_x_in(0),
    .seed_y_in(0),
    .colision(eaten1 | eaten2),
    .seed_x_out(),
    .seed_y_out(),
    .seed_rdy(),
    .map_out(map_reg)
);

/**
 * Main test
 */

initial begin
    rst = 1'b0;
    @(posedge clk);  rst = 1'b1;
    @(posedge clk);  rst = 1'b0;
    
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
                if(i==0 || i==MAP_HEIGHT-1 || j==0 || j==MAP_WIDTH-1) begin
                    map.tiles[i][j] <= WALL;
                end else if ((i==START_POS_Y - 1) && (j==START_POS_X)) begin
                    map.tiles[i][j] <= POINT;
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
            end else begin
                map.snake1.segments[k] <= NONE;
                map.snake2.segments[k] <= NONE;
            end
        end

    $display("Starting collisions simulation...");
    
    $finish;
end

endmodule