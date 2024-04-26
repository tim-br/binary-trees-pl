:- module(tree, [write_string/1, 
                 foo/1,
                 insert_random/1,
                 insert/2,
                 right_child/2,
                 left_child/2,
                 leaf/1]).
                 
:- use_module(library(random)).
:- use_module(library(between)).

:- dynamic(left_child/2).
:- dynamic(right_child/2).

/*
# left_child(22,10).
# left_child(10,5).
# right_child(22,50).
# right_child(10,15).
*/

right_child(125,150).
left_child(125, 110).

insert(X,Y):-
    X == Y,
    !.

insert(X,Y):-
    Y > X,
    \+ right_child(X,_),
    assertz(right_child(X,Y)).

insert(X,Y):-
    Y < X,
    \+ left_child(X,_),
    assertz(left_child(X,Y)).

insert(X,Y):-
    Y > X,
    right_child(X,Z),
	insert(Z, Y).
    
insert(X,Y):-
    Y < X,
    left_child(X,Z),
	insert(Z, Y).

leaf(X):-
    /* node(X),*/
    \+ left_child(X, _),
    \+ right_child(X, _).

child(X,Y):-
    /* node(X),
    # node(Y), */
    right_child(X,Y) ; left_child(X,Y).

insert_random(X) :-
    random_integer(0,100,Y),
    insert(X, Y).

exists(X,Y):-
    left_child(X,Y). 

exists(X,Y):-
	right_child(X,Y).

exists(X,Y):-
    left_child(X,Q),
    exists(Q,Y).

exists(X,Y):-
    right_child(X,Q),
    exists(Q,Y).

/*
ask_name(Name) :-
        new(D, dialog('Register')),
        send(D, append(new(NameItem, text_item(name)))),
        send(D, append(button(ok, message(D, return,
                                          NameItem?selection)))),
        send(D, append(button(cancel, message(D, return, @nil)))),
        send(D, default_button(ok)),
        get(D, confirm, Rval),
        free(D),
        Rval \== @nil,
        Name = Rval.
*/

/* between(1,50,_), insert_random(50), fail. */

write_string(X) :-
    open('weldeg.svg', write, Stream),
    current_output(SO),
    set_output(Stream),
    %format("~s", [X]),
    write(X),
    close(Stream),
    set_output(SO).

foo(X):-
    X is 42.