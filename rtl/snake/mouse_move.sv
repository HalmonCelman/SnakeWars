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
    input game_mode mode,

    output direction dir
);

direction dir_nxt;
logic clk_div_prev, left_prv, right_prv, click_left, click_right;

typedef enum logic {WAIT_MOUSE, WAIT_READ} STATE_T;

STATE_T state, state_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        dir <= UP;
        state <= WAIT_MOUSE;
    end else begin
        if(mode == GAME) begin
            dir <= dir_nxt;
            state <= state_nxt;
        end else begin
            dir <= UP;
            state <= WAIT_MOUSE;
        end
    end

    clk_div_prev <= clk_divided;
    left_prv <= left;
    right_prv <= right;
end

always_comb begin
    click_left = ~left_prv & left;
    click_right = ~right_prv & right;

    case(state)
        WAIT_MOUSE: begin
            if(click_left | click_right) begin
                
                case(dir)
                    UP:         dir_nxt = click_left ? LEFT : RIGHT;
                    DOWN:       dir_nxt = click_left ? RIGHT : LEFT;
                    LEFT:       dir_nxt = click_left ? DOWN : UP;
                    RIGHT:      dir_nxt = click_left ? UP : DOWN;
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

            if(clk_div_prev == 0 && clk_divided == 1) begin
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