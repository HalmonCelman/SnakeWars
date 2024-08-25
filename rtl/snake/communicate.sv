/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/
import snake_pkg::*;

module communicate(
    input wire clk,
    input wire rst,
    input wire rx,
    input wire send,
    output logic tx,
    input direction dir1,
    output direction dir2,
    output logic rcvdir
);

logic [7:0] w_data, w_data_nxt, r_data;
logic rd_uart, rd_uart_nxt, wr_uart, wr_uart_nxt, tx_full, rx_empty;
logic send_prv, rcvdir_nxt;
direction dir2_nxt;

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
        dir2    <= NONE;
    end else begin
        rd_uart <= rd_uart_nxt;
        wr_uart <= wr_uart_nxt;
        w_data  <= w_data_nxt;
        rcvdir  <= rcvdir_nxt;
        dir2    <= dir2_nxt;
    end
    send_prv <= send;
end

always_comb begin
    if(rx_empty == 1'b0 && rd_uart == 1'b0) begin
        rd_uart_nxt = 1'b1;
        /*
        OPCODES:
        00 - error
        01 - direction
        10 - collision
        11 - click 
        */
        //case(r_data[7:6])
        //    2'b01: begin
                dir2_nxt = direction'(r_data);
                rcvdir_nxt = 1'b1;
        //    end
        //    default: begin
        //        dir2_nxt = dir2;
        //        rcvdir_nxt = 1'b0;
        //    end
        //endcase
    end else begin
        rd_uart_nxt = 1'b0;
        dir2_nxt = dir2;
        rcvdir_nxt = 1'b0;
    end
    
    if(tx_full == 1'b0 && send == 1'b1 && send_prv == 1'b0) begin // positive edge of send
        wr_uart_nxt = 1'b1;
        /*
        OPCODES:
        00 - error
        01 - direction
        10 - collision
        11 - click 
        */
        //case(r_data[7:6])
        w_data_nxt = LEFT; 
        //    default:    w_data_nxt = w_data;
        //endcase
    end else begin
        wr_uart_nxt = 1'b0;
        w_data_nxt = w_data;
    end

end

endmodule