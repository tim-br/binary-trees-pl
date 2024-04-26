:- use_module(library(format)).
:- use_module(library(between)).


%%['tree.pl'].

    :- use_module('tree.pl').
:- use_module(library(lists)).


width(1200).
height(1200).
beginning_x(600).
beginning_y(25).
radius(18).
radius_squared(Res):-
    radius(R),
    Res is R * R.

svg_begin('<svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 1200 1200">').
svg_end('</svg>').
/*circle(C):-
    radius(R),
    svg_circle(600, 25, R, C).*/

next_two(CX, CY, Node, C, Res):-
    leaf(Node),
    Res = '',
    radius(R),
    number_chars(Node, NodeS),
    svg_circle_with_text(CX, CY, R, NodeS, C).

next_two(CX, CY, Node, C, Res):-
    \+ leaf(Node),
    width(W),
    radius(R),
    number_chars(Node, NodeS),
    svg_circle_with_text(CX, CY, R, NodeS, C),
    next_two_(W, CX, CY, Node, Res).

two_circles(Width, CX, CY, Res, NewCXRight, NewCXLeft, NewWidth, NewCY):-
    NewWidth is Width / 2,
    NewCXDifference is NewWidth / 2,
    NewCXLeft is CX - NewCXDifference,
    NewCXRight is CX + NewCXDifference,
    NewCY is CY + 40,
    radius(R),
    svg_circle_with_text(NewCXRight, NewCY, R, 'FOO', CRight),
    svg_circle_with_text(NewCXLeft, NewCY, R, 'Foo', CLeft),
    atom_chars(CLeftS, CLeft),
    atom_chars(CRightS, CRight),
    append(CLeftS, CRightS, Res).

right_circle(Node, Width, CX, CY, Res, NewCXRight, NewWidth, NewCY):-
    number_chars(Node, NodeS),
    NewWidth is Width / 2,
    NewCXDifference is NewWidth / 2,
    NewCXRight is CX + NewCXDifference,
    NewCY is CY + 40,
    radius(R),
    %line(CX, CY, NewCXRight, NewCY, Res0, Res0Y, Res1, Res1Y),
    %% svg_line(CX, CY, NewCXRight, NewCY, Res0),
    line(CX, CY, NewCXRight, NewCY, Res0X, Res0Y, _, _),
    second_line(CX, CY, NewCXRight, NewCY, _, _,Res1X, Res1Y),
    svg_line(Res1X, Res1Y, Res0X, Res0Y, Res0),
    svg_circle_with_text(NewCXRight, NewCY, R, NodeS, Res1),
    atom_chars(Res1S, Res1),
    atom_chars(Res0S, Res0),
    append(Res0, Res1, Res).

left_circle(Node, Width, CX, CY, Res, NewCXLeft, NewWidth, NewCY):-
    number_chars(Node, NodeS),
    NewWidth is Width / 2,
    NewCXDifference is NewWidth / 2,
    NewCXLeft is CX - NewCXDifference,
    NewCY is CY + 40,
    radius(R),
    line(CX, CY, NewCXLeft, NewCY, _, _, Res1X, Res1Y),
    second_line(CX, CY, NewCXLeft, NewCY, Res0X, Res0Y, _, _),
    svg_line(Res1X, Res1Y, Res0X, Res0Y, Res0),
    svg_circle_with_text(NewCXLeft, NewCY, R, NodeS, Res1),
    atom_chars(Res1S, Res1),
    atom_chars(Res0S, Res0),
    append(Res0, Res1, Res).

next_two_(_, _, _, Node, Res):-
    \+ left_child(Node, _),
    \+ right_child(Node, _),
    Res = "".

next_two_(Width, CX, CY, Node, Res):-
    \+ right_child(Node, _),
    left_child(Node, LeftChild),
    left_circle(LeftChild, Width, CX, CY, Res0, NewCXLeft, NewWidth, NewCY),
    next_two_(NewWidth, NewCXLeft, NewCY, LeftChild, Res1),
    append(Res0, Res1, Res).

next_two_(Width, CX, CY, Node, Res):-
    \+ left_child(Node, _),
    right_child(Node, RightChild),
    right_circle(RightChild, Width, CX, CY, Res0, NewCXRight, NewWidth, NewCY),
    next_two_(NewWidth, NewCXRight, NewCY, RightChild, Res1),
    append(Res0, Res1, Res).

next_two_(Width, CX, CY, Node, Res):-
    left_child(Node, LeftChild),
    left_circle(LeftChild, Width, CX, CY, Res0, NewCXLeft, NewWidth, NewCY),
    right_child(Node, RightChild),
    right_circle(RightChild, Width, CX, CY, Res1, NewCXRight, NewWidth, NewCY),
    next_two_(NewWidth, NewCXLeft, NewCY, LeftChild, Res2),
    next_two_(NewWidth, NewCXRight, NewCY, RightChild, Res3),
    append(Res0, Res1, Res4),
    append(Res2, Res3, Res5),
    append(Res4, Res5, Res).

line(CX, CY, NewCX, NewCY, Res0, Res0Y, Res1, Res1Y):-
    slope(CX, CY, NewCX, NewCY, Slope),
    radius_squared(RADIUS_SQUARED),
    height_at_X0(CX, CY, Slope, H),
    SLOPE_SQUARED is Slope * Slope,
    C is ((CY * CY)  - RADIUS_SQUARED + (CX * CX) - (2* H*CY) + (H * H)),
    B is 2 * (Slope*H - Slope*CY - CX ),
    A is (SLOPE_SQUARED + 1),
    SECOND_TERM is sqrt((B* B) - (4 * A * C)),
    THIRD_TERM is 2 * A,
    Res0 is (-B + SECOND_TERM) / THIRD_TERM,
    get_y_coord(Res0, Slope, H, Res0Y),
    Res1 is (-B - SECOND_TERM) / THIRD_TERM,
    get_y_coord(Res1, Slope, H, Res1Y).

second_line(CX, CY, NewCX, NewCY, Res0, Res0Y, Res1, Res1Y):-
    slope(CX, CY, NewCX, NewCY, Slope),
    radius_squared(RADIUS_SQUARED),
    height_at_X0(CX, CY, Slope, H),
    SLOPE_SQUARED is Slope * Slope,
    C is ((NewCY * NewCY)  - RADIUS_SQUARED + (NewCX * NewCX) - (2* H* NewCY) + (H * H)),
    B is 2 * (Slope*H - Slope*NewCY - NewCX),
    A is (SLOPE_SQUARED + 1),
    SECOND_TERM is sqrt((B* B) - (4 * A * C)),
    THIRD_TERM is 2 * A,
    Res0 is (-B + SECOND_TERM) / THIRD_TERM,
    get_y_coord(Res0, Slope, H, Res0Y),
    Res1 is (-B - SECOND_TERM) / THIRD_TERM,
    get_y_coord(Res1, Slope, H, Res1Y).

/*line_(CX, CY, NewCX, NewCY):-
    line(CX, CY, NewCX, NewCY, Res0, Res1).*/



% (SLOPE_SQUARED + 1) (x * x) + 2(Slope*H - Slope*CY - CX )x + (CY^2  - RADIUS_SQUARED + CX^2 - 2H*CY + H^2) = 0

svg_circle(CX, CY, R, Res):-
    number_chars(CX, CXS),
    number_chars(CY, CYS),
    phrase(format_("<circle cx='~s' cy='~s' r='~d' fill-opacity='0' stroke='black' />", [CXS, CYS, R]), Res).

svg_circle_with_text(CX, CY, R, Text, Res):-
    svg_circle(CX, CY, R, SCircle),
    number_chars(CX, CXS),
    number_chars(CY, CYS),
    phrase(format_("~s  <text x='~s' y='~s' text-anchor='middle' stroke='black' stroke-width='1px'> ~s </text>", [SCircle, CXS, CYS, Text]), Res).

svg_line(X1, Y1, X2, Y2, Res):-
    number_chars(X1, X1S),
    number_chars(Y1, Y1S),
    number_chars(X2, X2S),
    number_chars(Y2, Y2S),
    phrase(format_("<line x1='~s' y1='~s' x2='~s' y2='~s' stroke='black' />", [X1S, Y1S, X2S, Y2S]), Res).

height_at_X0(X, Y, Slope, Res):-
    Res is Y - (Slope * X).

slope(X1, Y1, X2, Y2, Res):-
    YDIFF is Y2 - Y1,
    XDIFF is X2 - X1,
    Res is YDIFF / XDIFF.

get_y_coord(X, Slope, H, Y):-
    Y is (Slope * X) + H.

/*circle_equation(C, D, X, Y,):-
    radius_squared(R2),
    X_MINUS_C_SQUARED is (X - C) * (X - C),
    Y_MINUS_D_SQUARED is (Y - D) * (Y - D).*/


write_file(FileName):-
    open(FileName, write, Stream),
    current_output(SO),
    set_output(Stream),
    svg_begin(Head),
    svg_end(Tail),
    next_two(600, 25, 50, C, C2),
    write(Head),
    write(C),
    write(C2),
    write(Tail),
    close(Stream),
    set_output(SO).