/*
Authors: Krzysztof Korbaś, Emilia Jerdanek
*/

package snake_pkg;
import vga_pkg::*;

typedef enum { 
    MENU,
    ERROR,
    GAME,
    WIN,
    LOSE,
    DRAW
} game_mode;

typedef enum { 
    NONE,
    UP,
    RIGHT,
    DOWN,
    LEFT
} direction;

// snake & map settings
localparam MAX_SNAKE_LENGTH = 15;

localparam MAP_WIDTH = 64;
localparam MAP_HEIGHT = 48;

typedef enum { 
    EMPTY,
    WALL,
    SNAKE1,
    SNAKE2,
    POINT
} tile;

localparam TILE_SIZE = HOR_PIXELS/MAP_WIDTH;

// colors
localparam TILE_EMPTY_COLOR = 12'hAAA;
localparam TILE_WALL_COLOR  = 12'h000;
localparam TILE_SNAKE1_COLOR = 12'h00F;
localparam TILE_SNAKE2_COLOR = 12'hF00;
localparam TILE_POINT_COLOR = 12'hFF0;

// menu options
localparam BUTTONS_X = HOR_PIXELS*2/5;
localparam BUTTONS_W = HOR_PIXELS*1/5;
localparam BUTTONS_H = VER_PIXELS*1/7;

localparam BUTTON1_Y = VER_PIXELS*1/7;
localparam BUTTON2_Y = VER_PIXELS*3/7;
localparam BUTTON3_Y = VER_PIXELS*5/7;

localparam TEXT_ADJ_W = (BUTTONS_W/2-64);
localparam TEXT_ADJ_H = (BUTTONS_H/2-8);

// error disp options
localparam ERROR_TXT_X = HOR_PIXELS/2-64;
localparam ERROR_TXT_Y = VER_PIXELS*3/14-8;

localparam BUTTONE_Y = VER_PIXELS*5/7;

// endscreen options
localparam END_TXT_X = HOR_PIXELS/2-64;
localparam END_TXT_Y = VER_PIXELS*3/14-8;
localparam BUTTONEND_Y = VER_PIXELS*5/7;

endpackage