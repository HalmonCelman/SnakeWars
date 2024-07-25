import snake_pkg::*;

interface snake_if;
direction [MAX_SNAKE_LENGTH] segments;

modport in(
    input segments
);

modport out(
    output segments
);

endinterface