/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module move_n_collisions(
    input wire clk,
    input wire clk_div,
    input wire rst,
    input direction dir1,
    input direction dir2,
    input wire rcvdir,
    input game_mode mode,
    input wire [WIDTH_BITS-1:0]  point_x,
    input wire [HEIGHT_BITS-1:0] point_y,

    output map_s map,
    output logic com_err,
    output logic eaten,
    output logic won,
    output logic lost,
    output logic draw
);

// move logic
map_s map_nxt;
logic clk_div_prv, clk_div_reg;
logic refreshed, refreshed_nxt;
logic com_err_nxt;
logic pos_clk_div;

logic eaten1, eaten2, eaten1_nxt, eaten2_nxt;
logic wrong_pt_loc, wrong_pt_loc_nxt;

// collision logic
// collisions logic
logic head_bump;
logic head1_tail1, head1_tail2;
logic head2_tail1, head2_tail2;
logic head1_body1, head1_body2;  // tail dont count
logic head2_body1, head2_body2;  // tail dont count

logic head1_oldtail1, head1_oldtail2;
logic head2_oldtail1, head2_oldtail2;
logic hit_wall1, hit_wall2;

logic suicide1, suicide2;
logic got_killed1, got_killed2;
logic died1, died2;
logic long1, long2;

logic head1_body1_nxt, head1_body2_nxt;
logic head2_body1_nxt, head2_body2_nxt;  

logic head1_oldtail1_nxt, head1_oldtail2_nxt;
logic head2_oldtail1_nxt, head2_oldtail2_nxt;
logic hit_wall1_nxt, hit_wall2_nxt;

game_mode mode_prv;

assign pos_clk_div = ((clk_div_prv == 1'b0) && (clk_div_reg == 1'b1));
assign eaten = eaten1 | eaten2 | wrong_pt_loc;

always_ff @(posedge clk) begin
    if(rst || (mode == GAME && mode_prv == MENU)) begin
        com_err   <= 1'b0;
        refreshed <= 1'b1;
        eaten1    <= 1'b0;
        eaten2    <= 1'b0;
        wrong_pt_loc <= 1'b0;

        // collisions
        head1_body1    <= 1'b0;
        head1_body2    <= 1'b0;
        head2_body1    <= 1'b0;
        head2_body2    <= 1'b0;
        head1_oldtail1 <= 1'b0;
        head1_oldtail2 <= 1'b0;
        head2_oldtail1 <= 1'b0;
        head2_oldtail2 <= 1'b0;
        hit_wall1      <= 1'b0;
        hit_wall2      <= 1'b0;
        // ---

        map.snake1.length <= START_LENGTH;
        map.snake1.head_x <= START_POS_X;
        map.snake1.head_y <= START_POS_Y;
        map.snake1.tail_x <= START_POS_X;
        map.snake1.tail_y <= START_POS_Y+START_LENGTH-1;

        map.snake2.length <= START_LENGTH;
        map.snake2.head_x <= START_POS_X_2;
        map.snake2.head_y <= START_POS_Y_2+START_LENGTH-1;
        map.snake2.tail_x <= START_POS_X_2;
        map.snake2.tail_y <= START_POS_Y_2;

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                if(i==0 || i==MAP_HEIGHT-1 || j==0 || j==MAP_WIDTH-1) begin
                    map.tiles[i][j] <= WALL;
                end else if((i>=START_POS_Y && i<START_POS_Y+START_LENGTH) && (j==START_POS_X)) begin
                    map.tiles[i][j] <= SNAKE1;
                end else if((i>=START_POS_Y_2 && i<START_POS_Y_2+START_LENGTH) && (j==START_POS_X_2)) begin
                    map.tiles[i][j] <= SNAKE2;
                end else begin
                    map.tiles[i][j] <= EMPTY;
                end
            end
        end

        for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
            if(k<START_LENGTH-1) begin
                map.snake1.segments[k] <= UP;
                map.snake2.segments[k] <= UP;
            end else begin
                map.snake1.segments[k] <= NONE;
                map.snake2.segments[k] <= NONE;
            end
        end

    end else begin
        com_err <= com_err_nxt;
        refreshed <= refreshed_nxt;

        if(pos_clk_div) begin
            eaten1            <= eaten1_nxt;
            map.snake1.length <= map_nxt.snake1.length;
            map.snake1.head_x <= map_nxt.snake1.head_x;
            map.snake1.head_y <= map_nxt.snake1.head_y;
            map.snake1.tail_x <= map_nxt.snake1.tail_x;
            map.snake1.tail_y <= map_nxt.snake1.tail_y;

            for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
                map.snake1.segments[k] <= map_nxt.snake1.segments[k];
            end

            head1_body1    <= head1_body1_nxt;
            head1_body2    <= head1_body2_nxt;
            head1_oldtail1 <= head1_oldtail1_nxt;
            head1_oldtail2 <= head1_oldtail2_nxt;
            hit_wall1      <= hit_wall1_nxt;
        end

        if(rcvdir) begin
            eaten2            <= eaten2_nxt;
            map.snake2.length <= map_nxt.snake2.length;
            map.snake2.head_x <= map_nxt.snake2.head_x;
            map.snake2.head_y <= map_nxt.snake2.head_y;
            map.snake2.tail_x <= map_nxt.snake2.tail_x;
            map.snake2.tail_y <= map_nxt.snake2.tail_y;
            for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
                map.snake2.segments[k] <= map_nxt.snake2.segments[k];
            end

            head2_body1    <= head2_body1_nxt;
            head2_body2    <= head2_body2_nxt;
            head2_oldtail1 <= head2_oldtail1_nxt;
            head2_oldtail2 <= head2_oldtail2_nxt;
            hit_wall2      <= hit_wall2_nxt;
        end

        for(int i=0;i<MAP_HEIGHT;i++) begin
            for(int j=0;j<MAP_WIDTH;j++) begin
                map.tiles[i][j] <= map_nxt.tiles[i][j];
            end
        end

        wrong_pt_loc <= wrong_pt_loc_nxt;
    end
    
    clk_div_reg <= clk_div;
    clk_div_prv <= clk_div_reg;

    mode_prv        <= mode;
end

// collisions
always_comb begin
    // we walk into each other with our heads - DRAW!
    head_bump   = (map.snake1.head_x == map.snake2.head_x &&  map.snake1.head_y == map.snake2.head_y);

    // head meets with tail
    head1_tail1 = (map.snake1.head_y == map.snake1.tail_y && map.snake1.head_x == map.snake1.tail_x);
    head2_tail2 = (map.snake2.head_y == map.snake2.tail_y && map.snake2.head_x == map.snake2.tail_x);
    head1_tail2 = (map.snake1.head_x == map.snake2.tail_x && map.snake1.head_y == map.snake2.tail_y);
    head2_tail1 = (map.snake2.head_x == map.snake1.tail_x && map.snake2.head_y == map.snake1.tail_y);

    // how to commit suicide (and cannibalism at the same moment): you either have to eat your tail, or eat your body (but not the previous tail cause it's moving)
    suicide1 = (head1_tail1 || (head1_body1 && !head1_oldtail1));
    suicide2 = (head2_tail2 || (head2_body2 && !head2_oldtail2));

    // how to get killed: it seems that oponent is toxic -.- so you need to bite his tail or body(again, not previous tail cause it's moving) 
    got_killed1 = (head1_tail2 || (head1_body2 && !head1_oldtail2));
    got_killed2 = (head2_tail1 || (head2_body1 && !head2_oldtail1));
    
    // how to die: commit suicide, get killed or sprint into sth hard(wall) 
    died1 = (suicide1 || got_killed1 || hit_wall1 || head_bump);
    died2 = (suicide2 || got_killed2 || hit_wall2 || head_bump);

    // is it long enough? remember that you can also win without killing anyone
    long1 = (map.snake1.length == MAX_SNAKE_LENGTH);
    long2 = (map.snake2.length == MAX_SNAKE_LENGTH);

    won  = ((long1 | died2) & ~died1) & refreshed;
    lost = ((long2 | died1) & ~died2) & refreshed;
    draw = died1 & died2 & refreshed;
end

always_comb begin
    case(dir1)
        NONE: begin 
            map_nxt.snake1.head_x = map.snake1.head_x;
            map_nxt.snake1.head_y = map.snake1.head_y;
        end
        UP: begin 
            map_nxt.snake1.head_x = map.snake1.head_x;
            map_nxt.snake1.head_y = map.snake1.head_y-1;
        end
        DOWN: begin 
            map_nxt.snake1.head_x = map.snake1.head_x;
            map_nxt.snake1.head_y = map.snake1.head_y+1;
        end
        RIGHT: begin 
            map_nxt.snake1.head_x = map.snake1.head_x+1;
            map_nxt.snake1.head_y = map.snake1.head_y;
        end
        LEFT: begin 
            map_nxt.snake1.head_x = map.snake1.head_x-1;
            map_nxt.snake1.head_y = map.snake1.head_y;
        end
        default: begin 
            map_nxt.snake1.head_x = map.snake1.head_x;
            map_nxt.snake1.head_y = map.snake1.head_y;
        end
    endcase

    if(map_nxt.snake1.head_x == point_x && map_nxt.snake1.head_y == point_y) begin
        eaten1_nxt = 1'b1;
        map_nxt.snake1.length = map.snake1.length+1;
    end else begin
        eaten1_nxt = 1'b0;
        map_nxt.snake1.length = map.snake1.length;
    end


    if(~eaten1_nxt) begin
        case(map.snake1.segments[map.snake1.length-2])
            UP: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y-1;
            end
            DOWN: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y+1;
            end
            RIGHT: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x+1;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
            LEFT: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x-1;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
            default: begin  
                map_nxt.snake1.tail_x = map.snake1.tail_x;
                map_nxt.snake1.tail_y = map.snake1.tail_y;
            end
        endcase
    end else begin
        map_nxt.snake1.tail_x = map.snake1.tail_x;
        map_nxt.snake1.tail_y = map.snake1.tail_y;
    end
    
    for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
        if(k<map_nxt.snake1.length-1) begin
            if(dir1 != NONE) begin
                if(k==0)    map_nxt.snake1.segments[k] = dir1;
                else        map_nxt.snake1.segments[k] = map.snake1.segments[k-1];
            end else begin
                map_nxt.snake1.segments[k] = map.snake1.segments[k];
            end
        end else begin
            map_nxt.snake1.segments[k] = NONE;
        end
    end

    case(dir2)
        UP: begin 
            map_nxt.snake2.head_x = map.snake2.head_x;
            map_nxt.snake2.head_y = map.snake2.head_y+1;
        end
        DOWN: begin 
            map_nxt.snake2.head_x = map.snake2.head_x;
            map_nxt.snake2.head_y = map.snake2.head_y-1;
        end
        RIGHT: begin 
            map_nxt.snake2.head_x = map.snake2.head_x-1;
            map_nxt.snake2.head_y = map.snake2.head_y;
        end
        LEFT: begin 
            map_nxt.snake2.head_x = map.snake2.head_x+1;
            map_nxt.snake2.head_y = map.snake2.head_y;
        end
        default: begin 
            map_nxt.snake2.head_x = map.snake2.head_x;
            map_nxt.snake2.head_y = map.snake2.head_y;
        end
    endcase

    if(map_nxt.snake2.head_x == point_x && map_nxt.snake2.head_y == point_y) begin
        eaten2_nxt = 1'b1;
        map_nxt.snake2.length = map.snake2.length+1;
    end else begin
        eaten2_nxt = 1'b0;
        map_nxt.snake2.length = map.snake2.length;
    end

    if(~eaten2_nxt) begin
        case(map.snake2.segments[map.snake2.length-2])
            NONE: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
            UP: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y+1;
            end
            DOWN: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y-1;
            end
            RIGHT: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x-1;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
            LEFT: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x+1;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
            default: begin  
                map_nxt.snake2.tail_x = map.snake2.tail_x;
                map_nxt.snake2.tail_y = map.snake2.tail_y;
            end
        endcase
    end else begin
        map_nxt.snake2.tail_x = map.snake2.tail_x;
        map_nxt.snake2.tail_y = map.snake2.tail_y;
    end

    for(int k=0;k<MAX_SNAKE_LENGTH-1;k++) begin
        if(k<map_nxt.snake2.length-1) begin
            if(dir2 != NONE) begin
                if(k==0)    map_nxt.snake2.segments[k] = dir2;
                else        map_nxt.snake2.segments[k] = map.snake2.segments[k-1];
            end else begin
                map_nxt.snake2.segments[k] = map.snake2.segments[k];
            end
        end else begin
            map_nxt.snake2.segments[k] = NONE;
        end
    end

    if(map.tiles[point_y][point_x] != EMPTY && map.tiles[point_y][point_x] != POINT) begin
        wrong_pt_loc_nxt = 1'b1;
    end else begin
        wrong_pt_loc_nxt = 1'b0;
    end

    for(int i=0;i<MAP_HEIGHT;i++) begin
        for(int j=0;j<MAP_WIDTH;j++) begin
                 if(pos_clk_div & (map_nxt.snake1.head_y == i && map_nxt.snake1.head_x == j))                               map_nxt.tiles[i][j] = SNAKE1;
            else if(rcvdir      & (map_nxt.snake2.head_y == i && map_nxt.snake2.head_x == j))                               map_nxt.tiles[i][j] = SNAKE2;
            else if(map.snake1.head_y == i && map.snake1.head_x == j)                                                       map_nxt.tiles[i][j] = SNAKE1;
            else if(map.snake2.head_y == i && map.snake2.head_x == j)                                                       map_nxt.tiles[i][j] = SNAKE2;
            else if(i == point_y && j == point_x && map.tiles[point_y][point_x] == EMPTY)                                   map_nxt.tiles[i][j] = POINT;
            else if((rcvdir      & (map.snake2.tail_y == i && map.snake2.tail_x == j && dir2 != NONE && ~eaten2_nxt))
                 || (pos_clk_div & (map.snake1.tail_y == i && map.snake1.tail_x == j && dir1 != NONE && ~eaten1_nxt)))      map_nxt.tiles[i][j] = EMPTY;
            else map_nxt.tiles[i][j] = map.tiles[i][j];
        end
    end

    // collisions
    // if head don't meet tail, and there WAS tail previous it means that there's no collision even if this tile was occupied previously( there was no point eaten - tail is moving)
    head1_oldtail1_nxt = (map_nxt.snake1.head_y == map.snake1.tail_y && map_nxt.snake1.head_x == map.snake1.tail_x);
    head2_oldtail2_nxt = (map_nxt.snake2.head_y == map.snake2.tail_y && map_nxt.snake2.head_x == map.snake2.tail_x);
    head1_oldtail2_nxt = (map_nxt.snake1.head_y == map.snake2.tail_y && map_nxt.snake1.head_x == map.snake2.tail_x);
    head2_oldtail1_nxt = (map_nxt.snake2.head_y == map.snake1.tail_y && map_nxt.snake2.head_x == map.snake1.tail_x);

    // check if tile where head is going to be was occupied - then collision, except above
    head1_body2_nxt = (map.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == SNAKE2);
    head1_body1_nxt = (map.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == SNAKE1);
    head2_body1_nxt = (map.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == SNAKE1);
    head2_body2_nxt = (map.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == SNAKE2);

    // how to hit a wall? just step into it! - no, no exceptions this time, unfortunately walls don't like running around the map
    hit_wall1_nxt = (map.tiles[map_nxt.snake1.head_y][map_nxt.snake1.head_x] == WALL);
    hit_wall2_nxt = (map.tiles[map_nxt.snake2.head_y][map_nxt.snake2.head_x] == WALL);

    if(pos_clk_div || rcvdir) begin
        if(rcvdir) begin
            refreshed_nxt = 1'b1;
            com_err_nxt = com_err;
        end else begin
            if(refreshed == 1'b0) begin
                com_err_nxt = 1'b1;
            end else begin
                com_err_nxt = com_err;
            end

            refreshed_nxt = 1'b0;
        end
    end else begin
        com_err_nxt = com_err;
        refreshed_nxt = refreshed;
    end
end

endmodule