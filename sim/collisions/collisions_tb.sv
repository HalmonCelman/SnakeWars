`timescale 1 ns / 1 ps

import snake_pkg::*;
import vga_pkg::*;

module collisions_tb;
/**
 *  Local parameters
 */

localparam CLK_PERIOD = 1000/75; //75MHz

logic clk, rst;
logic rcvdir, refreshed, clk_divided, eaten1, eaten2, won, lost, draw; 

/**
 * Clock generation
 */
int i;
initial begin
    i=2;
    clk = 1'b0;
    forever #(CLK_PERIOD/2) begin
        clk = ~clk;
        if(rcvdir == 1'b1) begin
            rcvdir = '0;
            i=0;
        end else begin
            if(i == 4) begin
                rcvdir = 1'b1;
            end
            i++;
        end
    end
end

initial begin
    clk_divided = 1'b0;
    forever #(CLK_PERIOD*5/2) begin
        clk_divided = ~clk_divided;
    end
end

/**
 * Submodules instances
 */

//connections
map_s map, map_nxt, map_reg;


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
    .eaten1,
    .eaten2,
    .refreshed
);

collisons u_collisions(
    .clk,
    .refreshed,
    .rst,
    .clk_div(clk_divided),
    .map,
    .map_nxt,
    .mode(GAME),
    .eaten1,
    .eaten2,
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
    rcvdir=1'b0; rst = 1'b0;
    @(posedge clk);  rst = 1'b1;
    @(posedge clk);  rst = 1'b0;

    $display("Starting collisions simulation...");
    
    $finish;
end

endmodule