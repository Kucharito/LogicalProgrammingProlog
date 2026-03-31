% predstavte si ze mate pole o velkosti 9 prvkov 3x3, kazde pole bude mat nejaku hodnotu, od 1 do 9 to su hodnoty polia,
%mame upravit kod skakanim konom, tak ze ja zadam pociatocnu a koncovu suradnicu a vrati sa mi ci tam moze doskakkat a sucet policok cez ktore ide je vaha, 
% musim modifikovat pole [0][0] hodnota je tam 7 atd, sucet vsetkych policok cez ktore isiel

% jedine co mi treba urobit je modifikovat pole a potom upravit kod aby to fungovalo, ze sa bude skakat konom a bude to hladat cestu a sucet hodnot policok cez ktore ide

% hodnoty policok
p([0,0], 7).
p([0,1], 4).
p([0,2], 1).
p([1,0], 8).
p([1,1], 5).
p([1,2], 2).
p([2,0], 9).
p([2,1], 6).
p([2,2], 3).

tah_kona([X,Y], [X1,Y1]) :-
    X1 is X+1, Y1 is Y+2.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X+2, Y1 is Y+1.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X-1, Y1 is Y+2.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X-2, Y1 is Y+1.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X-1, Y1 is Y-2.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X-2, Y1 is Y-1.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X+1, Y1 is Y-2.
tah_kona([X,Y], [X1,Y1]) :-
    X1 is X+2, Y1 is Y-1.


najdi_cestu(X,Y,R):-
    najdi_cestu(X,Y,[],R).
najdi_cestu(X,X,A,R):-
    reverse([X|A], R).
najdi_cestu(X,Y,A,R):-
    tah_kona(X,Z),
    p(Z, _),
    not(member(Z,A)),
    najdi_cestu(Z,Y,[X|A],R).

cena_cesty([], 0).
cena_cesty([H|T], Cena):-
    p(H, Hodnota),
    cena_cesty(T, Cena1),
    Cena is Cena1 + Hodnota.

cena_preskoku(X, Y, Cena):-
    najdi_cestu(X, Y, R),
    cena_cesty(R, Cena).



