% === NANOGRAM DEFINITION ===
grid(5, 5).

hint(row, 1, [1, 1]).
hint(row, 2, [2, 2]).
hint(row, 3, [3]).
hint(row, 4, [2]).
hint(row, 5, [2]).

hint(col, 1, [2, 2]).
hint(col, 2, [4]).
hint(col, 3, [1]).
hint(col, 4, [2]).
hint(col, 5, [2]).

% === GAME RULES ===

not(P) :- P, !, fail ; true.

% Is (Row, Col) a valid coordinate on the grid?
validAxis(Value, Size) :- Value >= 1, Value =< Size.
validRow(Row) :- grid(RowSize, _), validAxis(Row, RowSize).
validCol(Col) :- grid(_, ColSize), validAxis(Col, ColSize).
validCoord(Row, Col) :- validRow(Row), validCol(Col).

% Is there a block with the given length at the given position or later?
hasBlockWithLengthFrom(row, Row, StartCol, Length) :- validCoord(Row, StartCol), block(row, Row, StartCol, Length); validCoord(Row, StartCol), hasBlockWithLengthFrom(row, Row, StartCol + 1, Length).
hasBlockWithLengthFrom(col, StartRow, Col, Length) :- validCoord(StartRow, Col), block(row, StartRow, Col, Length); validCoord(StartRow, Col), hasBlockWithLengthFrom(row, StartRow + 1, Col, Length).

% Is there a black square at (Row, Col)?
% Then there must be a block on consecutive squares in the same row,
% such that it also includes the column of the square.
black(Row, Col) :- validCoord(Row, Col), block(row, Row, StartCol, Length),  StartCol =< Col, StartCol + Length > Col.

% Row blocks must not collide with each other
block(row, Row, Col, Length) :- block(row, Row, Col2, Length2), Col2 + Length2 >= Col, Col2 + Length2 =< Col + Length, !, fail.
block(row, Row, Col, Length) :- block(row, Row, Col2, Length2), Col2 >= Col - 1, Col2 =< Col + Length, !, fail.
block(row, Row, Col, Length).

% Col blocks must not collide with each other
block(col, Row, Col, Length) :- block(col, Row2, Col, Length2), Row2 + Length2 >= Row, Row2 + Length2 =< Row + Length, !, fail.
block(col, Row, Col, Length) :- block(col, Row2, Col, Length2), Row2 >= Row - 1, Row2 =< Row + Length, !, fail.
block(col, Row, Col, Length).
