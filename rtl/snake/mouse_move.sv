/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module mouse_move(
    input wire clk,
    input wire clk_divided,
    input wire rst,
    input wire left,
    input wire right,

    output direction dir
);

direction dir_nxt;
logic clk_div_prev;

typedef enum logic {WAIT_MOUSE, WAIT_READ} STATE_T;

STATE_T state, state_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        dir <= UP;
        state <= WAIT_MOUSE;
    
    end else begin
        dir <= dir_nxt;
        state <= state_nxt;
    end

    clk_div_prev <= clk_divided;
end

always_comb begin
    
    case(state)
        WAIT_MOUSE: begin
            if(left | right) begin
                
                case(dir)
                    UP:         dir_nxt = left ? LEFT : RIGHT;
                    DOWN:       dir_nxt = left ? RIGHT : LEFT;
                    LEFT:       dir_nxt = left ? DOWN : UP;
                    RIGHT:      dir_nxt = left ? UP : DOWN;
                    default:    dir_nxt = UP;
                endcase

                state_nxt = WAIT_READ;
            
            end else begin
                dir_nxt = dir;
                state_nxt = WAIT_MOUSE;
            end
        end

        WAIT_READ: begin
            dir_nxt = dir;

            if(clk_div_prev == 1 && clk_divided == 0) begin
                state_nxt = WAIT_MOUSE;
            end else begin
                state_nxt = WAIT_READ;
            end
        end

        default: begin
            dir_nxt = UP;
            state_nxt = WAIT_MOUSE;
        end

    endcase

end

endmodule