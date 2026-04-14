
:- dynamic p/2.
:- dynamic tah/3.
:- dynamic game/1.

% ---------------------------------------
% UTILS
% ---------------------------------------

% odstanuje prvky ze seznamu 
% odstran(Z, Co, Vys)
odstran([], _, []).
odstran([H|L1], L2, L3):-
    member(H, L2),
    odstran(L1, L2, L3).
odstran([H|L1], L2, [H|L3]):-
    not(member(H, L2)),
    odstran(L1, L2, L3).

% vypisuje pole po radcich
vypis([]).
vypis([H|T]):-
    write(H), nl,
    vypis(T).

% resetuje hraci pole
reset:-
    retractall(p(_,_)),
    retractall(tah(_,_,_)),
    pole([4,5,6,3,2,7,8,1,0,9], [5,4,3,6,7,2,1,8,9,0]),
    vypis_pole.

% generuje prazdne hraci pole
pole([], _).
pole([X|SX], SY):-
    pole1(X, SY),
    pole(SX, SY).

pole1(_, []).
pole1(X, [Y|SY]):- 
    assert(p([X, Y], ' ')),
    pole1(X, SY).

% vykresluje hraci pole
vypis_pole:-
    findall(X, p([X, _], _), XL),
    sort(XL, XLS),
    findall(Y, p([_, Y], _), YL),
    sort(YL, YLS1),
    reverse(YLS1, YLS),
    write('   --- --- --- --- --- --- --- --- --- --- '), nl,
    board(XLS, YLS),
    write('    0   1   2   3   4   5   6   7   8   9  '), nl.

board(_, []).
board(SX, [Y|SY]):-
    write(Y), write(' | '), 
    board1(SX, Y), nl,
    write('   --- --- --- --- --- --- --- --- --- --- '), nl,
    board(SX, SY).

board1([], _).
board1([X|SX], Y):-
    p([X, Y], H), 
    write(H), write(' | '),
    board1(SX, Y).

% manualni vlozi vice x
vloz_x([]):-
    vypis_pole.
vloz_x([H|T]):-
    retract(p(H, _)),
    assert(p(H, x)),
    vloz_x(T).

% manualni vlozi vice o
vloz_o([]):-
    vypis_pole.
vloz_o([H|T]):-
    retract(p(H, _)),
    assert(p(H, o)),
    vloz_o(T).

% ---------------------------------------
% SPRAVA HRY
% ---------------------------------------

% ziskava momentalni stav pole
map(R):-
    findall([S, H], p(S, H), ML),
    sort(ML, R).

% uklada odehrany tah v dane pozici
mapuj(S, H):-
    map(M),
    assert(tah(S, H, M)).

% vybira vsechny tahy daneho hrace a uklada je do hry
vyber_tahy(x):-
    findall([S, M], tah(x, S, M), Game),
    assert(game(Game)).

vyber_tahy(o):-
    findall([S, M], tah(o, S, M), Game),
    prehod(Game, Game1),
    assert(game(Game1)).

% prehazuje krizky a kolecka ve hre
prehod([], []).
prehod([[S,M]|G], [[S,M1]|G1]):-
    prehod1(M, M1),
    prehod(G, G1).

prehod1([], []).
prehod1([[S, ' ']|G], [[S, ' ']|G1]):-
    prehod1(G,G1).
prehod1([[S, x]|G], [[S, o]|G1]):-
    prehod1(G,G1).
prehod1([[S, o]|G], [[S, x]|G1]):-
    prehod1(G,G1).

% ---------------------------------------
% HRA
% ---------------------------------------

% kontrola vyhry
vyhra(H, R):-
    p(S1, H),
    o(_, S1, S2, S3, S4, S5),
    p(S2, H),
    p(S3, H),
    p(S4, H),
    p(S5, H),
    R = [S1, S2, S3, S4, S5],
    vyber_tahy(H),
    write(['VYHRA', H, R]), nl.
vyhra(_, _).

% objekt petice
o(1, [X, Y], [X1, Y], [X2, Y], [X3, Y], [X4, Y]):-
    X1 is X+1,
    X2 is X+2,
    X3 is X+3,
    X4 is X+4.

o(2, [X, Y], [X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4]):-
    X1 is X+1,
    X2 is X+2,
    X3 is X+3,
    X4 is X+4,
    Y1 is Y+1,
    Y2 is Y+2,
    Y3 is Y+3,
    Y4 is Y+4.

o(3, [X, Y], [X, Y1], [X, Y2], [X, Y3], [X, Y4]):-
    Y1 is Y+1,
    Y2 is Y+2,
    Y3 is Y+3,
    Y4 is Y+4.

o(4, [X, Y], [X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4]):-
    X1 is X+1,
    X2 is X+2,
    X3 is X+3,
    X4 is X+4,
    Y1 is Y-1,
    Y2 is Y-2,
    Y3 is Y-3,
    Y4 is Y-4.

% objekt sestice
o6(1, [X, Y], [X1, Y], [X2, Y], [X3, Y], [X4, Y], [X5, Y]):-
    X1 is X+1,
    X2 is X+2,
    X3 is X+3,
    X4 is X+4,
    X5 is X+5.

o6(2, [X, Y], [X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4], [X5, Y5]):-
    X1 is X+1,
    X2 is X+2,
    X3 is X+3,
    X4 is X+4,
    X5 is X+5,
    Y1 is Y+1,
    Y2 is Y+2,
    Y3 is Y+3,
    Y4 is Y+4,
    Y5 is Y+5.

o6(3, [X, Y], [X, Y1], [X, Y2], [X, Y3], [X, Y4], [X, Y5]):-
    Y1 is Y+1,
    Y2 is Y+2,
    Y3 is Y+3,
    Y4 is Y+4,
    Y5 is Y+5.

o6(4, [X, Y], [X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4], [X5, Y5]):-
    X1 is X+1,
    X2 is X+2,
    X3 is X+3,
    X4 is X+4,
    X5 is X+5,
    Y1 is Y-1,
    Y2 is Y-2,
    Y3 is Y-3,
    Y4 is Y-4,
    Y5 is Y-5.

% objekt male L
% _x
% x

o_male_L(1, [X, Y], [X1, Y], [X, Y1]):-
    X1 is X+1,
    Y1 is Y+1.

o_male_L(1, [X, Y], [X1, Y], [X, Y1]):-
    X1 is X+1,
    Y1 is Y-1.

o_male_L(1, [X, Y], [X1, Y], [X, Y1]):-
    X1 is X-1,
    Y1 is Y+1.

o_male_L(1, [X, Y], [X1, Y], [X, Y1]):-
    X1 is X-1,
    Y1 is Y-1.

% ---------------------------------------
% TAHY
% ---------------------------------------

% provede tah a udela vsechny potrebne procedury na konci tahu
proved_tah(S, H, I):-
    mapuj(S, H),
    retract(p(S, ' ')),
    assert(p(S, H)),
    write([S, I]),nl,
    vyhra(H, _),
    vypis_pole.

% tah hrace
th(S):-
    p(S, ' '),
    proved_tah(S, o, 'tah hrace').

% TAHY POCITACE
% doplneni do 5
tp:-
    p(S1, x),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, x),
    p(S4, x),
    p(S5, ' '),
    proved_tah(S5, x, 'doplneni do 5 xxxxX').

tp:-
    p(S1, x),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, x),
    p(S4, ' '),
    p(S5, x),
    proved_tah(S4, x, 'doplneni do 5 xxxXx').

tp:-
    p(S1, x),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    p(S5, x),
    proved_tah(S3, x, 'doplneni do 5 xxXxx').

tp:-
    p(S1, x),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, x),
    p(S4, x),
    p(S5, x),
    proved_tah(S2, x, 'doplneni do 5 xXxxx').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, x),
    p(S4, x),
    p(S5, x),
    proved_tah(S1, x, 'doplneni do 5 Xxxxx').

% zabraneni doplneni do 5
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, o),
    p(S4, o),
    p(S5, o),
    proved_tah(S1, x, 'zabraneni doplneni do 5 Xoooo').

tp:-
    p(S1, o),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, o),
    p(S4, o),
    p(S5, o),
    proved_tah(S2, x, 'zabraneni doplneni do 5 oxooo').

tp:-
    p(S1, o),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, ' '),
    p(S4, o),
    p(S5, o),
    proved_tah(S3, x, 'zabraneni doplneni do 5 ooXoo').

tp:-
    p(S1, o),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, o),
    p(S4, ' '),
    p(S5, o),
    proved_tah(S4, x, 'zabraneni doplneni do 5 oooXo').

tp:-
    p(S1, o),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, o),
    p(S4, o),
    p(S5, ' '),
    proved_tah(S5, x, 'zabraneni doplneni do 5 ooooX').

% doplneni do 4
tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, ' '),
    p(S3, x),
    p(S4, x),
    p(S5, x),
    p(S6, ' '),
    proved_tah(S2, x, 'doplneni do 4 _Xxxx_').

tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    p(S5, x),
    p(S6, ' '),
    proved_tah(S3, x, 'doplneni do 4 _xXxx_').

tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, x),
    p(S3, x),
    p(S4, ' '),
    p(S5, x),
    p(S6, ' '),
    proved_tah(S4, x, 'doplneni do 4 _xxXx_').

tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, x),
    p(S3, x),
    p(S4, x),
    p(S5, ' '),
    p(S6, ' '),
    proved_tah(S5, x, 'doplneni do 4 _xxxX_').

% zabraneni doplneni do 4
tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, ' '),
    p(S3, o),
    p(S4, o),
    p(S5, o),
    p(S6, ' '),
    proved_tah(S2, x, 'zabraneni doplneni do 4 _Xooo_').

tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, o),
    p(S3, ' '),
    p(S4, o),
    p(S5, o),
    p(S6, ' '),
    proved_tah(S3, x, 'zabraneni doplneni do 4 _oXoo_').

tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, o),
    p(S3, o),
    p(S4, ' '),
    p(S5, o),
    p(S6, ' '),
    proved_tah(S4, x, 'zabraneni doplneni do 4 _ooXo_').

tp:-
    p(S1, ' '),
    o6(_, S1, S2, S3, S4, S5, S6),
    p(S2, o),
    p(S3, o),
    p(S4, o),
    p(S5, ' '),
    p(S6, ' '),
    proved_tah(S5, x, 'zabraneni doplneni do 4 _oooX_').

% kriz utok
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    not(p(S5, o)),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, x),
    p(S8, x),
    not(p(S9, o)),
    proved_tah(S3, x, 'kriz utok 1').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    not(p(S5, o)),
    p(S6, x),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, x),
    p(S8, x),
    not(p(S9, o)),
    proved_tah(S3, x, 'kriz utok 2').

tp:-
    p(S1, x),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    not(p(S5, o)),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, x),
    p(S8, x),
    not(p(S9, o)),
    proved_tah(S3, x, 'kriz utok 3').

tp:-
    p(S1, x),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    not(p(S5, o)),
    p(S6, x),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, x),
    p(S8, x),
    not(p(S9, o)),
    proved_tah(S3, x, 'kriz utok 4').

% L utok
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, x),
    p(S4, x),
    p(S5, ' '),
    p(S6, ' '),
    o(_, S6, S7, S8, S2, S9),
    p(S7, x),
    p(S8, x),
    p(S9, ' '),
    proved_tah(S2, x, 'L utok 1').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, x),
    p(S4, ' '),
    p(S5, ' '),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S7, S8, S4, S9),
    p(S7, x),
    p(S8, x),
    p(S9, ' '),
    proved_tah(S4, x, 'L utok 2').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, x),
    p(S4, x),
    p(S5, ' '),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S2, S7, S8, S9),
    p(S7, x),
    p(S8, x),
    p(S9, ' '),
    proved_tah(S2, x, 'L utok 3').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, x),
    p(S4, ' '),
    p(S5, ' '),
    p(S6, ' '),
    o(_, S6, S4, S7, S8, S9),
    p(S7, x),
    p(S8, x),
    p(S9, ' '),
    proved_tah(S4, x, 'L utok 4').

% kriz obrana
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, ' '),
    p(S4, o),
    not(p(S5, x)),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, o),
    p(S8, o),
    not(p(S9, x)),
    proved_tah(S3, x, 'kriz obrana 1').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, ' '),
    p(S4, o),
    not(p(S5, x)),
    p(S6, o),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, o),
    p(S8, o),
    not(p(S9, x)),
    proved_tah(S3, x, 'kriz obrana 2').

tp:-
    p(S1, o),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, ' '),
    p(S4, o),
    not(p(S5, x)),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, o),
    p(S8, o),
    not(p(S9, x)),
    proved_tah(S3, x, 'kriz obrana 3').

tp:-
    p(S1, o),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, ' '),
    p(S4, o),
    not(p(S5, x)),
    p(S6, o),
    S1 \= S6,
    o(_, S6, S7, S3, S8, S9),
    p(S7, o),
    p(S8, o),
    not(p(S9, x)),
    proved_tah(S3, x, 'kriz obrana 4').

% L obrana
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, o),
    p(S4, o),
    p(S5, ' '),
    p(S6, ' '),
    o(_, S6, S7, S8, S2, S9),
    p(S7, o),
    p(S8, o),
    p(S9, ' '),
    proved_tah(S2, x, 'L obrana 1').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, o),
    p(S4, ' '),
    p(S5, ' '),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S7, S8, S4, S9),
    p(S7, o),
    p(S8, o),
    p(S9, ' '),
    proved_tah(S4, x, 'L obrana 2').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, o),
    p(S4, o),
    p(S5, ' '),
    p(S6, ' '),
    S1 \= S6,
    o(_, S6, S2, S7, S8, S9),
    p(S7, o),
    p(S8, o),
    p(S9, ' '),
    proved_tah(S2, x, 'L obrana 3').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, o),
    p(S3, o),
    p(S4, ' '),
    p(S5, ' '),
    p(S6, ' '),
    o(_, S6, S4, S7, S8, S9),
    p(S7, o),
    p(S8, o),
    p(S9, ' '),
    proved_tah(S4, x, 'L obrana 4').

% ambiciozni trojice
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, x),
    p(S4, ' '),
    p(S5, ' '),
    proved_tah(S4, x, 'ambiciozni trojice _xxX_').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, x),
    p(S5, ' '),
    proved_tah(S3, x, 'ambiciozni trojice _xXx_').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, x),
    p(S4, x),
    p(S5, ' '),
    proved_tah(S2, x, 'ambiciozni trojice _Xxx_').

% male L
tp:-
    p(S1, ' '),
    o_male_L(_, S1, S2, S3),
    p(S2, x),
    p(S3, x),
    proved_tah(S1, x, 'male L 1').

tp:-
    p(S1, x),
    o_male_L(_, S1, S2, S3),
    p(S2, ' '),
    p(S3, x),
    proved_tah(S2, x, 'male L 2').

tp:-
    p(S1, x),
    o_male_L(_, S1, S2, S3),
    p(S2, x),
    p(S3, ' '),
    proved_tah(S3, x, 'male L 3').

% ambiciozni dvojice
tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, x),
    p(S3, ' '),
    p(S4, ' '),
    p(S5, ' '),
    proved_tah(S3, x, 'ambiciozni dvojice _xX__').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, x),
    p(S4, ' '),
    p(S5, ' '),
    proved_tah(S4, x, 'ambiciozni dvojice _xX__').

tp:-
    p(S1, ' '),
    o(_, S1, S2, S3, S4, S5),
    p(S2, ' '),
    p(S3, ' '),
    p(S4, x),
    p(S5, ' '),
    proved_tah(S3, x, 'ambiciozni dvojice __Xx_').

% empirie
tp:-
    map(R),
    game(G),
    member([S, R], G),
    proved_tah(S, x, 'empirie').

% nahodny tah
tp:-
    p(S, ' '),
    proved_tah(S, x, 'nahodny').
