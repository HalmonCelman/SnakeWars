`timescale 1 ns / 1 ps

import vga_pkg::*;

module draw_rect_char
#(
    parameter X=0,
    parameter Y=0,
    parameter CHARS_IN_LINE = 16,
    parameter NUMBER_OF_LINES = 16,
    parameter FONT_COLOR = 12'h000
)
(
    input wire clk,
    input wire rst,

    input wire [0:7] char_pixels,
    output logic [7:0] char_xy,
    output logic [3:0] char_line,

    vga_if.in vga_in,
    input wire [RGB_B-1:0] rgb_i,  
    vga_if.out vga_out,
    output logic [RGB_B-1:0] rgb_o
);

localparam FONT_WIDTH = 8;
localparam FONT_HEIGHT = 16;

logic [11:0] rgb_delayed, rgb_nxt;
logic [7:0] char_xy_nxt;
logic [3:0] char_line_nxt,char_line_nxt2;

logic [10:0] hcnt_sub;

delay
#(
    .CLK_DEL(3),
    .WIDTH(12)
) u_delay_rgb(
    .clk,
    .rst,
    .din(rgb_i),
    .dout(rgb_delayed)
);

vga_if vga_delayed();

delay
#(
    .CLK_DEL(3),
    .WIDTH(26)
) u_delay_vga(
    .clk,
    .rst,
    .din ({vga_in.hcount,      vga_in.vcount,      vga_in.hblnk,      vga_in.vblnk,      vga_in.hsync,      vga_in.vsync}),
    .dout({vga_delayed.hcount, vga_delayed.vcount, vga_delayed.hblnk, vga_delayed.vblnk, vga_delayed.hsync, vga_delayed.vsync})
);

always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.hcount  <= '0;
        vga_out.vcount  <= '0;
        vga_out.hblnk   <= '0;
        vga_out.vblnk   <= '0;
        vga_out.hsync   <= '0;
        vga_out.vsync   <= '0;
        
        rgb_o             <= '0;
        char_xy         <= '0;
        char_line       <= '0;
        char_line_nxt   <= '0;
    end else begin
        vga_out.hcount  <= vga_delayed.hcount;
        vga_out.vcount  <= vga_delayed.vcount;
        vga_out.hblnk   <= vga_delayed.hblnk;
        vga_out.vblnk   <= vga_delayed.vblnk;
        vga_out.hsync   <= vga_delayed.hsync;
        vga_out.vsync   <= vga_delayed.vsync;

        rgb_o             <= rgb_nxt;
        char_xy         <= char_xy_nxt;
        char_line       <= char_line_nxt;
        char_line_nxt   <= char_line_nxt2;
    end
end
 
always_comb begin
    hcnt_sub = vga_in.hcount-X;

    if(char_pixels[3'(vga_delayed.hcount-X)]
    && vga_delayed.hcount >= X
    && vga_delayed.hcount < X+FONT_WIDTH * CHARS_IN_LINE
    && vga_delayed.vcount >= Y
    && vga_delayed.vcount < Y+FONT_HEIGHT * NUMBER_OF_LINES
    ) begin
        rgb_nxt = FONT_COLOR;
    end
    else begin
        rgb_nxt = rgb_delayed;
    end
    
    char_xy_nxt = {4'((vga_in.vcount-Y)/FONT_HEIGHT), hcnt_sub[6:3] };
    char_line_nxt2 = 4'(vga_in.vcount-Y);
end
 
endmodule
 