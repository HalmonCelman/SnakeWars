module mouse_control(
    input logic clk100MHz,
    input logic clk40MHz,
    input logic rst,
    inout logic ps2_clk,
    inout logic ps2_data,
    output logic left,
    output logic [11:0] x,
    output logic [11:0] y
);

logic [11:0] xpos;
logic [11:0] ypos;

MouseCtl u_MouseCtl (
    .clk(clk100MHz),
    .rst,
    .ps2_clk,
    .ps2_data,
    .xpos(xpos),
    .ypos(ypos),

    .zpos(),
    .value(),
    .left,
    .middle(),
    .right(),
    .setx(),
    .sety(),
    .setmax_x(),
    .setmax_y(),
    .new_event()
);

always_ff @(posedge clk40MHz) begin
    if(rst) begin
        x <= '0;
        y <= '0;
    end else begin
        x <= xpos;
        y <= ypos;
    end
end

endmodule