// by KK
module get_memory
#(
    parameter ADDR_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire rx,
    output logic tx,
    output logic read_ready,
    output logic [ADDR_WIDTH-1:0] addr,
    output logic [15:0] memory
);

logic [ADDR_WIDTH-1:0] addr_nxt;
logic [15:0] memory_nxt;
logic [7:0] r_data, char1, char2;
logic rcv_tick, rx_empty;
logic ctr, ctr_nxt;
logic read_ready_nxt;

uart u_uart(
    .clk,
    .reset(rst),
    .rd_uart(rcv_tick),
    .wr_uart(),
    .rx,
    .w_data(),
    .tx_full(),
    .rx_empty,
    .tx,
    .r_data
);

make_numbers u_make_numbers(
    .clk,
    .rst,
    .data_in(r_data),
    .rx_empty,

    .char1,
    .char2,
    .readByte(rcv_tick) 
);

always_ff @(posedge clk) begin
    if(rst) begin
        memory <= '0;
        addr <= -1;
        ctr <= 1'b0;
        read_ready <= 1'b0;
    end else begin
        memory <= memory_nxt;
        addr <= addr_nxt;
        ctr <= ctr_nxt;
        read_ready <= read_ready_nxt; 
    end
end

always_comb begin
    if(rcv_tick) begin
        if(ctr) begin
            addr_nxt = addr + 1;
            memory_nxt = {char2, char1};
            read_ready_nxt = 1'b1;
        end else begin
            addr_nxt = addr;
            memory_nxt = memory;
            read_ready_nxt = 1'b0;
        end
        ctr_nxt = ~ctr;
    end else begin
        addr_nxt = addr;
        memory_nxt = memory;
        read_ready_nxt = 1'b0;
        ctr_nxt = ctr;
    end
end

endmodule