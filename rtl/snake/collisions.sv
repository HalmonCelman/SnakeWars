import snake_pkg::*;

module collisons(
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
    output logic draw,
    output logic start1,
    output logic start2,
    output logic menu
);

// STARTING GAME
always_comb begin
    case(mode)
        MENU: begin
            if( click_e
            &&  click_x >= BUTTONS_X
            &&  click_x <  BUTTONS_X + BUTTONS_W
            ) begin
                // singleplayer
                if( click_y >= BUTTON1_Y   
                &&  click_y <  BUTTON1_Y + BUTTONS_H
                ) begin
                    start1 = 1'b1;
                    start2 = 1'b0; 
                end else
                // multiplayer
                if( click_y >= BUTTON2_Y   
                &&  click_y <  BUTTON2_Y + BUTTONS_H
                ) begin
                    start1 = 1'b0;
                    start2 = 1'b1;
                end else
                // settings
                if( click_y >= BUTTON3_Y   
                &&  click_y <  BUTTON3_Y + BUTTONS_H
                ) begin
                    // possible feat - settings
                    start1 = 1'b0;
                    start2 = 1'b0;
                end else begin
                    start1 = 1'b0;
                    start2 = 1'b0;
                end
            end
        end
        default: begin
            start1 = 1'b0;
            start2 = 1'b0;
        end
    endcase
end

// BACK TO MENU buttons
always_comb begin
    case(mode)
        ERROR, WIN, LOSE, DRAW: begin
            if( click_e
            &&  click_x >= BUTTONS_X
            &&  click_x <  BUTTONS_X + BUTTONS_W
            ) begin
                if( mode == ERROR
                &&  click_y >= BUTTONE_Y   
                &&  click_y <  BUTTONE_Y + BUTTONS_H
                ) begin
                    menu = 1'b1;
                end else
                if( click_y >= BUTTONEND_Y   
                &&  click_y <  BUTTONEND_Y + BUTTONS_H
                ) begin
                    menu = 1'b1;
                end else begin
                    menu = 1'b0;
                end
            end
        end
        default: menu = 1'b0;
    endcase
end

// POINT (it is possible that it will need to be one cycle before everything else, not sure how to solve at the moment, will see tommorow)
always_comb begin
    case(mode)
        GAME: begin
            if( map_nxt.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == POINT) 
                 eaten1 = 1'b1;
            else begin
                 eaten1 = 1'b0;
            end
        end
        default: eaten1 = 1'b0;
    endcase
end

always_comb begin
    case(mode)
        GAME: begin
            if( map_nxt.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == POINT) 
                 eaten2 = 1'b1;
            else begin
                 eaten2 = 1'b0;
            end
        end
        default: eaten2 = 1'b0;
    endcase
end

// GAME
bool head_bump;
bool head1_tail1, head1_tail2;
bool head2_tail1, head2_tail2;
bool head1_body1, head1_body2;  // tail dont count
bool head2_body1, head2_body2;  // tail dont count

bool head1_oldtail1, head1_oldtail2;
bool head2_oldtail1, head2_oldtail2;

bool suicide1, suicide2;
bool got_killed1, got_killed2;
bool hit_wall1, hit_wall2;
bool died1, died2;

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
    head1_body2 = (map[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == SNAKE2);
    head2_body1 = (map[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == SNAKE1);
    head1_body1 = (map[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == SNAKE1);
    head1_body2 = (map[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == SNAKE2);

    // how to commit suicide (and cannibalism at the same moment): you either have to eat your tail, or eat your body (but not the previous tail cause it's moving)
    suicide1 = (head1_tail1 || (head1_body1 && !head1_oldtail1));
    suicide2 = (head2_tail2 || (head2_body2 && !head2_oldtail2));

    // how to get killed: it seems that oponent is toxic -.- so you need to bite his tail or body(again, not previous tail cause it's moving) 
    got_killed1 = (head1_tail2 || (head1_body2 && !head1_oldtail2));
    got_killed2 = (head2_tail1 || (head2_body1 && !head2_oldtail1));

    // how to hit a wall? just step into it! - no, no exceptions this time, unfortunately walls don't like running around the map
    hit_wall1 = (map[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == WALL);
    hit_wall2 = (map[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == WALL);

    // how to die: commit suicide, get killed or sprint into sth hard(wall) 
    died1 = (suicide1 || got_killed1 || hit_wall1);
    died2 = (suicide2 || got_killed2 || hit_wall2);
end

always_comb begin
    case(mode)
        GAME: begin
            if(died1 && died2)  {won,lost,draw} = 3'b001; // died at the same moment
            else if(died1)      {won,lost,draw} = 3'b010; // lost
            else if(died2)      {won,lost,draw} = 3'b100; // won
            else                {won,lost,draw} = 3'b000; // nothing
        end
        default: {won,lost,draw} = 3'b000;
    endcase
end


endmodule