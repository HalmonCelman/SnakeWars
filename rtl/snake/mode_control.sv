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

    output game_mode mode,
	output logic local_start
);


always_ff @(posedge clk_75) begin
	if(rst) begin
		mode <= MENU;
		local_start <= 1'b0;
	end else
		case(mode)
		
			MENU: begin
				if(click_e &&  click_x >= BUTTONS_X &&  click_x <  BUTTONS_X + BUTTONS_W
				    && click_y >= BUTTON2_Y &&  click_y <  BUTTON2_Y + BUTTONS_H) begin  
					mode <= GAME;
					local_start <= 1'b1;
				
				end else if(start_game) begin	
					mode <= GAME;
					local_start <= 1'b0;
				end
			end

			GAME: begin
				local_start <= 1'b0;
				
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
				local_start <= 1'b0;
				mode <= MENU;
			end

		endcase
end

endmodule 
