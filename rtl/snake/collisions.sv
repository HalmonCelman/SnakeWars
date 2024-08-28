import snake_pkg::*;

module collisons(
    input wire clk,
    input wire rst,
    input wire click_e,
    input wire [11:0] click_x,
    input wire [11:0] click_y,
    input map_s map,
    input map_s map_nxt,
    input game_mode mode,
    
    output logic eaten1,
    output logic eaten2,
    output logic won,
    output logic lost,
    output logic draw
);

logic eaten1_nxt, eaten2_nxt, won_nxt, lost_nxt, draw_nxt;

// POINT (it is possible that it will need to be one cycle before everything else, not sure how to solve at the moment, will see tommorow)
always_comb begin
    case(mode)
        GAME: begin
            if( map_nxt.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == POINT) 
                 eaten1_nxt = 1'b1;
            else begin
                 eaten1_nxt = 1'b0;
            end
        end
        default: eaten1_nxt = 1'b0;
    endcase
end

always_comb begin
    case(mode)
        GAME: begin
            if( map_nxt.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == POINT) 
                 eaten2_nxt = 1'b1;
            else begin
                 eaten2_nxt = 1'b0;
            end
        end
        default: eaten2_nxt = 1'b0;
    endcase
end

// GAME
logic head_bump;
logic head1_tail1, head1_tail2;
logic head2_tail1, head2_tail2;
logic head1_body1, head1_body2;  // tail dont count
logic head2_body1, head2_body2;  // tail dont count

logic head1_oldtail1, head1_oldtail2;
logic head2_oldtail1, head2_oldtail2;

logic suicide1, suicide2;
logic got_killed1, got_killed2;
logic hit_wall1, hit_wall2;
logic died1, died2;
logic long1, long2;

always_ff @(posedge clk) begin
    if(rst) begin
        eaten1 <= '0;
        eaten2 <= '0;
        won    <= '0;
        lose   <= '0;
        draw   <= '0;
    end else begin
        eaten1 <= eaten1_nxt;
        eaten2 <= eaten2_nxt;
        won    <= won_nxt;
        lose   <= lose_nxt;
        draw   <= draw_nxt;
    end
end


always_comb begin
    // we walk into each other with our heads
    head_bump   = (map_nxt.snake1.head_x == map_nxt.snake2.head_x &&  map_nxt.snake1.head_y == map_nxt.snake2.head_y);

    // head meets with tail
    head1_tail1 = (map_nxt.snake1.head_y == map_nxt.snake1.tail_y && map_nxt.snake1.head_x == map_nxt.snake1.tail_x);
    head2_tail2 = (map_nxt.snake2.head_y == map_nxt.snake2.tail_y && map_nxt.snake2.head_x == map_nxt.snake2.tail_x);
    head1_tail2 = (map_nxt.snake1.head_x == map_nxt.snake2.tail_x     && map_nxt.snake1.head_y == map_nxt.snake2.tail_y);
    head2_tail1 = (map_nxt.snake2.head_x == map_nxt.snake1.tail_x     && map_nxt.snake2.head_y == map_nxt.snake1.tail_y);
    
    // if head don't meet tail, and there WAS tail previous it means that there's no collision even if this tile was occupied previously( there was no point eaten - tail is moving)
    head1_oldtail1 = (map_nxt.snake1.head_y == map.snake1.tail_y && map_nxt.snake1.head_x == map.snake1.tail_x);
    head2_oldtail2 = (map_nxt.snake2.head_y == map.snake2.tail_y && map_nxt.snake2.head_x == map.snake2.tail_x);
    head1_oldtail2 = (map_nxt.snake1.head_y == map.snake2.tail_y && map_nxt.snake1.head_x == map.snake2.tail_x);
    head2_oldtail1 = (map_nxt.snake2.head_y == map.snake1.tail_y && map_nxt.snake2.head_x == map.snake1.tail_x);

    // check if tile where head is going to be was occupied - then collision, except above
    head1_body2 = (map.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == SNAKE2);
    head2_body1 = (map.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == SNAKE1);
    head1_body1 = (map.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == SNAKE1);
    head1_body2 = (map.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == SNAKE2);

    // how to commit suicide (and cannibalism at the same moment): you either have to eat your tail, or eat your body (but not the previous tail cause it's moving)
    suicide1 = (head1_tail1 || (head1_body1 && !head1_oldtail1));
    suicide2 = (head2_tail2 || (head2_body2 && !head2_oldtail2));

    // how to get killed: it seems that oponent is toxic -.- so you need to bite his tail or body(again, not previous tail cause it's moving) 
    got_killed1 = (head1_tail2 || (head1_body2 && !head1_oldtail2));
    got_killed2 = (head2_tail1 || (head2_body1 && !head2_oldtail1));

    // how to hit a wall? just step into it! - no, no exceptions this time, unfortunately walls don't like running around the map
    hit_wall1 = (map.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == WALL);
    hit_wall2 = (map.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == WALL);

    // how to die: commit suicide, get killed or sprint into sth hard(wall) 
    died1 = (suicide1 || got_killed1 || hit_wall1);
    died2 = (suicide2 || got_killed2 || hit_wall2);

    // is it long enough? remember that you can also win without killing anyone
    long1 = (map_nxt.snake1.length == MAX_SNAKE_LENGTH);
    long2 = (map_nxt.snake2.length == MAX_SNAKE_LENGTH);
end

always_comb begin
    case(mode)
        GAME: begin
                 if(died1 && died2) {won_nxt,lost_nxt,draw_nxt} = 3'b001; // died at the same moment
            else if(died1 || long2) {won_nxt,lost_nxt,draw_nxt} = 3'b010; // lost
            else if(died2 || long1) {won_nxt,lost_nxt,draw_nxt} = 3'b100; // won
            else                    {won_nxt,lost_nxt,draw_nxt} = 3'b000; // nothing
        end
        default:                    {won_nxt,lost_nxt,draw_nxt} = 3'b000;
    endcase
end


endmodule