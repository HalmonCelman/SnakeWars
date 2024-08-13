module mouse_control(
    input logic clk100MHz,
    input logic clk75MHz,
    input logic rst,
    inout logic ps2_clk,
    inout logic ps2_data,
    output logic left,
    output logic right,
    output logic [11:0] x,
    output logic [11:0] y
);

logic [11:0] xpos;
logic [11:0] ypos;
logic mouse_left;
logic mouse_right;

MouseCtl u_MouseCtl (
    .clk(clk100MHz),
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos(xpos),
    .ypos(ypos),

    .zpos(),
    .value(),
    .left(mouse_left),
    .middle(),
    .right(mouse_right),
    .setx(),
    .sety(),
    .setmax_x(),
    .setmax_y(),
    .new_event()
);

always_ff @(posedge clk75MHz) begin
    if(rst) begin
        x <= '0;
        y <= '0;
        right <= '0;
        left <= '0;
    end else begin
        x <= xpos;
        y <= ypos;
        right <= mouse_right;
        left <= mouse_left;
    end
end

endmodule