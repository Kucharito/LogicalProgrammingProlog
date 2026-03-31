p([0,0], 7).
p([0,1], 4).
p([0,2], 1).
p([1,0], 8).
p([1,1], 5).
p([1,2], 2).
p([2,0], 9).
p([2,1], 6).
p([2,2], 3).

tah1([X,Y], [X1,Y1]) :- X1 is X+1, Y1 is Y+2.
tah1([X,Y], [X1,Y1]) :- X1 is X+2, Y1 is Y+1.
tah1([X,Y], [X1,Y1]) :- X1 is X-1, Y1 is Y+2.
tah1([X,Y], [X1,Y1]) :- X1 is X-2, Y1 is Y+1.
tah1([X,Y], [X1,Y1]) :- X1 is X-1, Y1 is Y-2.
tah1([X,Y], [X1,Y1]) :- X1 is X-2, Y1 is Y-1.
tah1([X,Y], [X1,Y1]) :- X1 is X+1, Y1 is Y-2.
tah1([X,Y], [X1,Y1]) :- X1 is X+2, Y1 is Y-1.

kon_cesta(Start, Ciel, Cesta, Sucet) :-
    kon_cesta(Start, Ciel, [Start], Cesta),
    sucet_cesty(Cesta, Sucet).

kon_cesta(Ciel, Ciel, Navstivene, Cesta) :-
    reverse(Navstivene, Cesta).

kon_cesta(Akt, Ciel, Navstivene, Cesta) :-
    tah1(Akt, Dalsie),
    p(Dalsie, _),
    \+ member(Dalsie, Navstivene),
    kon_cesta(Dalsie, Ciel, [Dalsie|Navstivene], Cesta).

sucet_cesty([], 0).
sucet_cesty([Pole|Zvysok], Sucet) :-
    p(Pole, Hodnota),
    sucet_cesty(Zvysok, S1),
    Sucet is Hodnota + S1.