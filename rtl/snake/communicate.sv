/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/
import snake_pkg::*;

module communicate(
    input wire clk,
    input wire rst,
    input wire rx,
    input wire send,
    input wire seed_rdy,
    input wire [4:0] seed_x_in,
    input wire [4:0] seed_y_in,
    input direction dir1,
    input logic singleplayer,
    output logic start_game,
    output logic [4:0] seed_x_out,
    output logic [4:0] seed_y_out,
    output logic tx,
    output direction dir2,
    output logic rcvdir
);

logic [7:0] w_data, w_data_nxt, r_data;
logic rd_uart, rd_uart_nxt, wr_uart, wr_uart_nxt, tx_full, rx_empty;
logic send_prv, rcvdir_nxt, start_game_nxt;
direction dir2_nxt;

logic [4:0] seed_x_out_nxt;
logic [4:0] seed_y_out_nxt;

logic seed_flag, seed_flag_nxt;

uart u_uart(
    .clk,
    .reset(rst),
    .rd_uart,
    .wr_uart,
    .rx,
    .w_data,
    .tx_full,
    .rx_empty,
    .tx,
    .r_data
);

always_ff @(posedge clk) begin
    if(rst) begin
        rd_uart <= '0;
        wr_uart <= '0;
        w_data  <= '0;
        rcvdir  <= '0;
        seed_flag <= '0;
        start_game <= '0;
        dir2    <= NONE;
        seed_x_out <= '0;
        seed_y_out <= '0;
    end else begin
        rd_uart <= rd_uart_nxt;
        wr_uart <= wr_uart_nxt;
        w_data  <= w_data_nxt;
        rcvdir  <= rcvdir_nxt;
        seed_flag <= seed_flag_nxt;
        start_game <= start_game_nxt;
        dir2    <= dir2_nxt;
        seed_x_out <= seed_x_out_nxt;
        seed_y_out <= seed_y_out_nxt;
    end
    send_prv <= send;
end

always_comb begin
    if(~singleplayer) begin
        if(rx_empty == 1'b0 && rd_uart == 1'b0) begin
            /*
            OPCODES:
            00 - direction
            01 - seed x
            10 - seed y
            11 - not used
            */
            rd_uart_nxt = 1'b1;

            case(r_data[7:6])
                2'b00: begin
                    dir2_nxt = direction'(r_data[2:0]);
                    rcvdir_nxt = 1'b1;
                    start_game_nxt = start_game;
                    seed_x_out_nxt = seed_x_out;
                    seed_y_out_nxt = seed_y_out;
                end
                2'b01: begin
                    dir2_nxt = dir2;
                    rcvdir_nxt = 1'b0;
                    start_game_nxt = 1'b0;
                    seed_x_out_nxt = r_data[4:0];
                    seed_y_out_nxt = seed_y_out;
                end
                2'b10: begin
                    dir2_nxt = dir2;
                    rcvdir_nxt = 1'b0;
                    start_game_nxt = 1'b1;
                    seed_x_out_nxt = seed_x_out;
                    seed_y_out_nxt = r_data[4:0];
                end
                default: begin
                    dir2_nxt = dir2;
                    rcvdir_nxt = 1'b0;
                    start_game_nxt = start_game;
                    seed_x_out_nxt = seed_x_out;
                    seed_y_out_nxt = seed_y_out;
                end
            endcase
        end else begin
            dir2_nxt = dir2;
            rd_uart_nxt = 1'b0;
            rcvdir_nxt = 1'b0;
            start_game_nxt = start_game;
            seed_x_out_nxt = seed_x_out;
            seed_y_out_nxt = seed_y_out;
        end

        /*
            OPCODES:
            00 - direction
            01 - seed x
            10 - seed y
            11 - not used
            */
        if(tx_full == 1'b0) begin
            if(seed_rdy) begin
                wr_uart_nxt = 1'b1;
                w_data_nxt = {2'b01,  1'b0, seed_x_in};
                seed_flag_nxt = 1'b1;
            end else if(seed_flag) begin
                wr_uart_nxt = 1'b1;
                w_data_nxt = {2'b10, 1'b0, seed_y_in};
                seed_flag_nxt = 1'b0;
            end else if(send == 1'b1 && send_prv == 1'b0) begin // positive edge of send
                wr_uart_nxt = 1'b1;
                w_data_nxt = {5'b0, dir1};
                seed_flag_nxt = 1'b0;
            end else begin
                wr_uart_nxt = 1'b0;
                w_data_nxt = {5'b0,NONE};
                seed_flag_nxt = 1'b0;
            end
        end else begin
            wr_uart_nxt = 1'b0;
            w_data_nxt = w_data;
            seed_flag_nxt = 1'b0;
        end
    end else begin
        rd_uart_nxt = '0;
        wr_uart_nxt = '0;
        w_data_nxt  = '0;
        rcvdir_nxt  = '0;
        seed_flag_nxt = '0;
        start_game_nxt = '0;
        dir2_nxt    = NONE;
        seed_x_out_nxt = '0;
        seed_y_out_nxt = '0;
    end
end

endmodule