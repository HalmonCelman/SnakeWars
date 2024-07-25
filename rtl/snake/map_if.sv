import snake_pkg::*;

interface map_if;
tile tiles [MAP_HEIGHT][MAP_WIDTH];
direction snake [MAX_SNAKE_LENGTH];

modport in(
    input tiles,
    input snake
);

modport out(
    output tiles,
    output snake
);

endinterface