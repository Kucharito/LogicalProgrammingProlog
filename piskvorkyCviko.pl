:- dynamic p/2.
:- discontiguous p/1.
:- dynamic tah/3.
:- dynamic game/1.
p([0,0],' ').
p([0,1],' ').
p([0,2],' ').
p([0,3],' ').
p([0,4],' ').
p([0,5],' ').
p([0,6],' ').
p([0,7],' ').
p([0,8],' ').
p([0,9],' ').

p([1,0],' ').
p([1,1],' ').
p([1,2],' ').
p([1,3],' ').
p([1,4],' ').
p([1,5],' ').
p([1,6],' ').
p([1,7],' ').
p([1,8],' ').
p([1,9],' ').

p([2,0],' ').
p([2,1],' ').
p([2,2],' ').
p([2,3],' ').
p([2,4],' ').
p([2,5],' ').
p([2,6],' ').
p([2,7],' ').
p([2,8],' ').
p([2,9],' ').

p([3,0],' ').
p([3,1],' ').
p([3,2],' ').
p([3,3],' ').
p([3,4],' ').
p([3,5],' ').
p([3,6],' ').
p([3,7],' ').
p([3,8],' ').
p([3,9],' ').

p([4,0],' ').
p([4,1],' ').
p([4,2],' ').
p([4,3],' ').
p([4,4],' ').
p([4,5],' ').
p([4,6],' ').
p([4,7],' ').
p([4,8],' ').
p([4,9],' ').

p([5,0],' ').
p([5,1],' ').
p([5,2],' ').
p([5,3],' ').
p([5,4],' ').
p([5,5],' ').
p([5,6],' ').
p([5,7],' ').
p([5,8],' ').
p([5,9],' ').

p([6,0],' ').
p([6,1],' ').
p([6,2],' ').
p([6,3],' ').
p([6,4],' ').
p([6,5],' ').
p([6,6],' ').
p([6,7],' ').
p([6,8],' ').
p([6,9],' ').

p([7,0],' ').
p([7,1],' ').
p([7,2],' ').
p([7,3],' ').
p([7,4],' ').
p([7,5],' ').
p([7,6],' ').
p([7,7],' ').
p([7,8],' ').
p([7,9],' ').

p([8,0],' ').
p([8,1],' ').
p([8,2],' ').
p([8,3],' ').
p([8,4],' ').
p([8,5],' ').
p([8,6],' ').
p([8,7],' ').
p([8,8],' ').
p([8,9],' ').

p([9,0],' ').
p([9,1],' ').
p([9,2],' ').
p([9,3],' ').
p([9,4],' ').
p([9,5],' ').
p([9,6],' ').
p([9,7],' ').
p([9,8],' ').
p([9,9],' ').


% :- dynamic p /2
% reset:- pole([0,1,2,3,4,5,6,7,8,9], [0,1,2,3,4,5,6,7,8,9]),

% reset je vytvorenie prazdnej hracej plochy
 % deklarace predikátu p/3 jako dynamického, aby bylo možné přidávat a odebírat fakta během běhu programu

 % Odstraní všechna fakta p/2 a p/3, aby se zajistilo čisté prostředí pro reset
% Resetne hraciu plochu a historiu tahov.
reset:-
    retractall(p(_, _)),          % vymaze vsetky existujuce policka z databazy
    pole([0,1,2,3,4,5,6,7,8,9],   % vytvori vsetky X suradnice 0..9
         [0,1,2,3,4,5,6,7,8,9]),  % a pre kazde X vsetky Y suradnice 0..9
    retractall(tah(_,_,_)),
    vypis_pole.                   % vypise cele pole
                                  % poznamka: neskor sa da upravit tak,
                                  % aby suradnice zacinali od stredu,
                                  % nie od [0,0] v lavom hornom rohu

% Vytvori vsetky body pre zoznam X suradnic.
pole([],_).                       % ak uz nezostali ziadne X suradnice, koniec

pole([X|SX], SY):-
    pole1(X, SY),                 % pre aktualne X vytvori vsetky body [X,Y]
    pole(SX, SY).                 % potom pokracuje so zvyskom X suradnic

% Vytvori body pre jedno X a vsetky Y suradnice.
pole1(_,[]).                      % ak uz nezostali ziadne Y suradnice, koniec

pole1(X,[Y|SY]):-
    assert(p([X,Y],' ')),         % ulozi do databazy jedno prazdne policko
                                  % na pozicii [X,Y]
    pole1(X,SY).                  % pokracuje dalsim Y pre rovnake X


% Vypise celu tabulku hraceho pola.
vypis_pole:-
    findall(X, p([X,_],_), XL),         % zozbiera vsetky X suradnice z faktov p([X,Y], Hodnota)
    sort(XL, XLS),                      % zoradi X suradnice a zaroven odstrani duplicity

    findall(Y, p([_,Y],_), YL),         % zozbiera vsetky Y suradnice
    sort(YL, YLS),                      % zoradi Y suradnice a odstrani duplicity
    reverse(YLS, YLS1),                 % otoci poradie Y, aby sa vypisovalo zhora nadol

    write('   --- --- --- --- --- --- --- --- --- ---'), % horna ciara tabulky
    nl,                                 % novy riadok

    board(XLS, YLS1),                   % vypise samotne riadky pola podla X a Y suradnic

    write('    0   1   2   3   4   5   6   7   8   9').  % spodny riadok s oznacenim stlpcov

% Vypise jeden riadok tabulky pre konkretne Y.
board(_,[]).                          % ak uz nie su dalsie riadky Y, vypis sa skonci

board(SX,[Y|SY]):-
    write(Y),                         % vypise cislo aktualneho riadku
    write(' | '),                     % vypise oddelovac za cislom riadku
    board1(SX,Y),                     % vypise obsah vsetkych policok v riadku Y
    nl,                               % novy riadok
    write('   --- --- --- --- --- --- --- --- --- ---'), % vodorovna ciara pod riadkom
    nl,
    board(SX,SY).                     % pokracuje na dalsi riadok

% Vypise obsah riadku po stlpcoch.
board1([],_).                         % ak uz nie su dalsie stlpce X, skonci vypis riadku

board1([X|SX],Y):-
    p([X,Y],H),                       % zisti obsah policka na suradnici [X,Y]
    write(H),                         % vypise obsah policka
    write(' | '),                     % vypise oddelovac medzi stlpcami
    board1(SX,Y).                     % pokracuje na dalsi stlpec v tom istom riadku

% Tah hraca
% Vykona tah hraca o a skontroluje vyhru.
th(S):-
    p(S,' '),                         % overi, ze zadane policko je prazdne
    mapuj(S,o),
    retract(p(S,' ')),                % odstrani fakt, ze policko je prazdne
    assert(p(S,'o')),                 % zapise na dane policko znak o
    vypis_pole,                       % vypise aktualny stav pola
    nl,
    write(S),                         % vypise suradnicu vykonaneho tahu
    vyhra('o', _).  % ak vyhra o, ulozi sa hra cez vyber_tahy(o)

% Pomocny predikat na hromadne vlozenie x (testovanie).
x([]):- vypis_pole.
x([H|T]):-
    retract(p(H,' ')),
    assert(p(H,'x')),
    x(T).

% Hlavny vyber tahu pocitaca podla priorit pravidiel.
tp:-
    pravidlo_vyhra_x(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    pravidlo_blokuj_vyhru_o(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    pravidlo_vytvor_hrozbu_x(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    pravidlo_blokuj_hrozbu_o(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    pravidlo_rozsir_na_stvorku_x(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    pravidlo_blokuj_rozsirenie_o(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    pravidlo_stred(S, Pravidlo),
    mapuj(S,x),
    urob_tah_x(S, Pravidlo).

tp:-
    map(R),
    game(G),
    member([S,R],G),
    p(S,' '),
    mapuj(S,x),
    urob_tah_x(S, 'learned tah').


tp:-
    p(S,' '),
    mapuj(S,x),
    urob_tah_x(S, 'fallback prve volne').

% Vykona vybrany tah pocitaca a vypise pouzite pravidlo.
urob_tah_x(S, Pravidlo):-
    retract(p(S,' ')),
    assert(p(S,'x')),
    vypis_pole,
    nl,
    write([S, Pravidlo]), nl,
    vyhra('x', _).

% pravidlo 1: ak vieme hned vyhrat (xxxx_ alebo _xxxx), tak zahraj vyherne policko
pravidlo_vyhra_x(S, 'R1 vyhra hned'):-
    p(A,_),
    o(_,A,B,C,D,E),
    jedna_prazdna_styri('x', [A,B,C,D,E], S).

% pravidlo 2: ak super (o) vie hned vyhrat, zablokuj to
pravidlo_blokuj_vyhru_o(S, 'R2 blok supera 4v rade'):-
    p(A,_),
    o(_,A,B,C,D,E),
    jedna_prazdna_styri('o', [A,B,C,D,E], S).

% pravidlo 3: vytvor otvorenu trojicu _xxx_
pravidlo_vytvor_hrozbu_x(S, 'R3 vytvor otvorenu trojicu'):-
    p(A,_),
    o(_,A,B,C,D,E),
    otvorena_trojica('x', [A,B,C,D,E], S).

% pravidlo 4: zablokuj otvorenu trojicu supera _ooo_
pravidlo_blokuj_hrozbu_o(S, 'R4 blok otvorenej trojice'):-
    p(A,_),
    o(_,A,B,C,D,E),
    otvorena_trojica('o', [A,B,C,D,E], S).

% pravidlo 5: hraj od stredu von
pravidlo_stred(S, 'R5 stred-von'):-
    kandidat_stred(S),
    p(S,' ').

% pravidlo 6: rozsir svoju trojicu na stvorku (bez okamzitej vyhry)
pravidlo_rozsir_na_stvorku_x(S, 'R6 rozsirenie na 4'):-
    p(A,_),
    o(_,A,B,C,D,E),
    dopln_na_stvorku('x', [A,B,C,D,E], S),
    nie_je_tah_z_otvorenej_trojice('x', S).

% pravidlo 7: zablokuj supera, ked si vie rozsirit trojicu na stvorku
pravidlo_blokuj_rozsirenie_o(S, 'R7 blok rozsirenia supera na 4'):-
    p(A,_),
    o(_,A,B,C,D,E),
    dopln_na_stvorku('o', [A,B,C,D,E], S),
    nie_je_tah_z_otvorenej_trojice('o', S).

% Volitelne pravidlo R8: momentalne vypnute, aby nemenilo poradie tahov.
pravidlo_hraj_pri_x(_, _) :-
    fail.


% Najde miesto, kde v patici chyba presne jeden kamen H.
jedna_prazdna_styri(H, [A,B,C,D,E], A):- p(A,' '), p(B,H), p(C,H), p(D,H), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], B):- p(A,H), p(B,' '), p(C,H), p(D,H), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], C):- p(A,H), p(B,H), p(C,' '), p(D,H), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], D):- p(A,H), p(B,H), p(C,H), p(D,' '), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], E):- p(A,H), p(B,H), p(C,H), p(D,H), p(E,' ').

% vrati koncove volne pole pre vzor _HHH_
otvorena_trojica(H, [A,B,C,D,E], A):- p(A,' '), p(B,H), p(C,H), p(D,H), p(E,' ').
otvorena_trojica(H, [A,B,C,D,E], E):- p(A,' '), p(B,H), p(C,H), p(D,H), p(E,' ').

% Overi, ci dany tah nepatri do vzoru otvorenej trojice.
nie_je_tah_z_otvorenej_trojice(H, S):-
    not((
        p(A,_),
        o(_,A,B,C,D,E),
        otvorena_trojica(H, [A,B,C,D,E], S)
    )).

% Najde doplnenie na stvorku v lubovolnom 4-polickovom okne z patice.
dopln_na_stvorku(H, [A,B,C,D,_E], S):- jedna_prazdna_zo_styroch(H, [A,B,C,D], S).
dopln_na_stvorku(H, [_A,B,C,D,E], S):- jedna_prazdna_zo_styroch(H, [B,C,D,E], S).

% Najde miesto, kde v stvorici chyba presne jeden kamen H.
jedna_prazdna_zo_styroch(H, [A,B,C,D], A):- p(A,' '), p(B,H), p(C,H), p(D,H).
jedna_prazdna_zo_styroch(H, [A,B,C,D], B):- p(A,H), p(B,' '), p(C,H), p(D,H).
jedna_prazdna_zo_styroch(H, [A,B,C,D], C):- p(A,H), p(B,H), p(C,' '), p(D,H).
jedna_prazdna_zo_styroch(H, [A,B,C,D], D):- p(A,H), p(B,H), p(C,H), p(D,' ').

% Vypocita 8-susedstvo policka.
sused([X,Y],[X1,Y1]):- X1 is X+1, Y1 is Y.
sused([X,Y],[X1,Y1]):- X1 is X-1, Y1 is Y.
sused([X,Y],[X1,Y1]):- X1 is X, Y1 is Y+1.
sused([X,Y],[X1,Y1]):- X1 is X, Y1 is Y-1.
sused([X,Y],[X1,Y1]):- X1 is X+1, Y1 is Y+1.
sused([X,Y],[X1,Y1]):- X1 is X+1, Y1 is Y-1.
sused([X,Y],[X1,Y1]):- X1 is X-1, Y1 is Y+1.
sused([X,Y],[X1,Y1]):- X1 is X-1, Y1 is Y-1.

% Preddefinovane stredove kandidatne policka.
kandidat_stred([4,4]).
kandidat_stred([5,5]).
kandidat_stred([4,5]).
kandidat_stred([5,4]).
kandidat_stred([3,3]).
kandidat_stred([6,6]).
kandidat_stred([3,4]).
kandidat_stred([4,3]).
kandidat_stred([6,5]).
kandidat_stred([5,6]).
kandidat_stred([2,2]).
kandidat_stred([7,7]).


% Overi vyhru hraca H a ulozi naucene tahy.
vyhra(H,R):-
    p(S1,H),
    o(_,S1,S2,S3,S4,S5),
    p(S2,H),
    p(S3,H),
    p(S4,H),
    p(S5,H),
    R=[S1,S2,S3,S4,S5],
    write(['vyhra:',H,R]), nl,
    vyber_tahy(H).

% Fallback klauzula: ak nie je vyhra, predikat uspie.
vyhra(_, _).

% Zozbiera tahy hraca x do jedneho zaznamu hry.
vyber_tahy(x):- findall([S,M],tah(x,S,M),Game),
    assert(game(Game)).

% Zozbiera tahy hraca o, prehodi znacky a ulozi ako pohlad x.
vyber_tahy(o):- findall([S,M],tah(o,S,M),Game),
    prehod(Game,Game1),
    assert(game(Game1)).

% Prehodi znacky v celej historii jednej hry.
prehod([],[]).
prehod([[S,M]|G],[[S,M1]|G2]):-
    prehod1(M,M1),
    prehod(G,G2).

% Prehodi jednu mapu: x<->o, prazdne polia ponecha.
prehod1([],[]).
prehod1([[S,' ']|G],[[S,' ']|G1]):-
    prehod1(G,G1).
prehod1([[S,x]|G],[[S,o]|G1]):-
    prehod1(G,G1).
prehod1([[S,o]|G],[[S,x]|G1]):-
    prehod1(G,G1).


% Generuje 5-polickove useky v 4 smeroch.
o(1,[X,Y],[X1,Y],[X2,Y],[X3,Y],[X4,Y]):- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4. % ->
o(2,[X,Y],[X1,Y1],[X2,Y2],[X3,Y3],[X4,Y4]):- X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2, X3 is X+3, Y3 is Y+3, X4 is X+4, Y4 is Y+4. % 5 na diagonále HORE
o(3,[X,Y],[X,Y1],[X,Y2],[X,Y3],[X,Y4]):- Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4. % | STLPEC SMER HORE
o(4,[X,Y],[X1,Y1],[X2,Y2],[X3,Y3],[X4,Y4]):- X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2, X3 is X+3, Y3 is Y-3, X4 is X+4, Y4 is Y-4. % 5 na diagonále dole


% Vrati aktualnu mapu hraceho pola v zoradenom tvare.
map(R):- findall([S,H],p(S,H),ML),sort(ML,R).

% Ulozi tah H na suradnici S spolu so stavom mapy pred tahom.
mapuj(S,H):- map(Mapa),
    assert(tah(H,S,Mapa)).

%tell('C:\\Users\\kuc0396\\Desktop\\cvikoText.txt'), listing(game),told.

% vytvorit si obranne pravidlo pre diagonaly pretoze v diagonale vzdy ked uz je 3 a 3 tak uz to je gg pre mna uz neubranim 
/*
   --- --- --- --- --- --- --- --- --- ---
9 |   |   |   |   |   | x |   |   |   |   |
   --- --- --- --- --- --- --- --- --- ---
8 |   |   |   |   | x | o | x | x |   |   |
   --- --- --- --- --- --- --- --- --- ---
7 |   |   |   |   | x | o | o | o |   |   |
   --- --- --- --- --- --- --- --- --- ---
6 |   |   |   | x | o | o | o | o | x |   |
   --- --- --- --- --- --- --- --- --- ---
5 |   |   |   | o | o | x | o | o |   |   |
   --- --- --- --- --- --- --- --- --- ---
4 |   |   | o | x | x | x | x | o |   |   |
   --- --- --- --- --- --- --- --- --- ---
3 |   | x |   |   |   |   |   | o | x |   |
   --- --- --- --- --- --- --- --- --- ---
2 |   |   |   |   |   |   |   | x |   |   |
   --- --- --- --- --- --- --- --- --- ---
1 |   |   |   |   |   |   |   |   |   |   |
   --- --- --- --- --- --- --- --- --- ---
0 |   |   |   |   |   |   |   |   |   |   |
   --- --- --- --- --- --- --- --- --- ---
    0   1   2   3   4   5   6   7   8   9
[7,7][vyhra:,o,[[7,3],[7,4],[7,5],[7,6],[7,7]]]
true .*/

%takto som prehral dvakrat