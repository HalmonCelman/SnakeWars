/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

import snake_pkg::*;

module mode_control(
    input logic clk_75,
	input logic rst,
	input logic start_game,
	input logic won,
	input logic lost,
	input logic draw,
	input logic con_error,
	input logic [11:0] click_x,
	input logic [11:0] click_y,
	input logic click_e,

    output game_mode mode
);

always_ff @(posedge clk_75) begin
	if(rst)
		mode <= MENU;
	else
		case(mode)
		
			MENU: begin
				if((click_e &&  click_x >= BUTTONS_X &&  click_x <  BUTTONS_X + BUTTONS_W
				    && click_y >= BUTTON2_Y &&  click_y <  BUTTON2_Y + BUTTONS_H) || start_game)    
					mode <= GAME;
			end

			GAME: begin
				if(con_error)
					mode <= ERROR;
				else if(won)
					mode <= WIN;
				else if(lost)
					mode <= LOSE;
				else if(draw)
					mode <= DRAW;
			end

			WIN, LOSE, DRAW: begin
				if( click_e &&  click_x >= BUTTONS_X &&  click_x <  BUTTONS_X + BUTTONS_W
				    && click_y >= BUTTONEND_Y &&  click_y <  BUTTONEND_Y + BUTTONS_H )    
					mode <= MENU;
			end

			ERROR: begin
				if( click_e &&  click_x >= BUTTONS_X &&  click_x <  BUTTONS_X + BUTTONS_W
				    && click_y >= BUTTONE_Y &&  click_y <  BUTTONE_Y + BUTTONS_H )    
					mode <= MENU;
			end

			default: begin
				mode <= MENU;
			end

		endcase
end

endmodule 
