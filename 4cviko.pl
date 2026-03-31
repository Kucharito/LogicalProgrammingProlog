:- dynamic p/2.
:- discontiguous p/1.
% pruchod cyklickym grafom
%a-b,b-c,c-d,a-e,b-e,e-d

%h(a,b).
%h(b,c).
%h(c,d).
%h(a,e).
%h(b,e).
%h(e,d).
e(X,Y):- h(X,Y).              % Hrana z X do Y existuje priamo.
e(X,Y):- h(Y,X).              % Hrana z X do Y existuje aj opačným smerom.

cestaa(X,Y,P):- cestaa(X,Y,[],P).   % Spustí hľadanie cesty s prázdnym akumulátorom navštívených uzlov.

%cestaa(X,X,A,P):- reverse(A,P).    % Pôvodná verzia: po dosiahnutí cieľa otočí akumulátor.
cestaa(X,X,A,P):- reverse([X|A],P). % Ak sme v cieli, pridáme X do cesty a otočíme poradie.

cestaa(X,Y,A,P):-                   % Rekurzívne hľadanie cesty z X do Y.
    e(X,Z),                         % Nájde susedný uzol Z z aktuálneho uzla X.
    not(member(Z,A)),               % Skontroluje, že Z ešte nebol navštívený.
    cestaa(Z,Y,[X|A],P).            % Pokračuje ďalej zo Z, pričom X uloží do akumulátora.

vypis([]).                          % Ak je zoznam prázdny, nič sa nevypisuje.
vypis([H|T]):-                      % Rozdelí zoznam na hlavu H a chvost T.
    write(H),                       % Vypíše prvý prvok zoznamu.
    nl,                             % Prejde na nový riadok.
    vypis(T).                       % Rekurzívne vypíše zvyšok zoznamu.


%findall(P, cestaa(a,d,P),PL),vypis(PL).

%findall([X,Y],e(X,Y),EL),vypis(EL).

%urobit program pri overeni ci je program jednotaska resp. eulerov graf
% Pokus o overenie/jdenie Eulerovho ťahu v grafe

h(a,b).   % Hrana medzi a a b
h(a,c).   % Hrana medzi a a c
h(a,d).   % Hrana medzi a a d
h(b,c).   % Hrana medzi b a c
h(b,d).   % Hrana medzi b a d
h(c,d).   % Hrana medzi c a d
h(c,e).   % Hrana medzi c a e
h(d,e).   % Hrana medzi d a e

euler(R):-                             % Nájde jednu možnú trasu R
    findall([X,Y], e(X,Y), EL),        % Vytvorí zoznam všetkých orientovaných hrán
    member(H, EL),                     % Vyberie začiatočnú hranu
    tah(H, EL, [], R).                 % Spustí rekurzívne budovanie trasy

tah(H, [], A, R):-                     % Ak už nezostali hrany
    reverse([H|A], R).                 % Vráti výslednú trasu v správnom poradí

tah([X,Y], EL, A, R):-                 % Aktuálna hrana je X->Y
    member([Y,Z], EL),                 % Nájde ďalšiu hranu začínajúcu v Y
    Z \= X,                            % Zakáže okamžitý návrat do X
    odstran(EL, [[X,Y], [Y,X], [Y,Z], [Z,Y]], EL1), % Odstráni použité hrany
    tah([Y,Z], EL1, [[X,Y]|A], R).     % Pokračuje ďalej z Y do Z

odstran([], _, []).                    % Z prázdneho zoznamu nič neostane
odstran([H|L1], L2, L3):-              % Ak je H v zozname na odstránenie
    member(H, L2),                     % overí sa, že tam patrí
    odstran(L1, L2, L3).               % a H sa vynechá

odstran([H|L1], L2, [H|L3]):-          % Ak H netreba odstrániť
    not(member(H, L2)),                % overí sa, že nie je v L2
    odstran(L1, L2, L3).               % H sa ponechá vo výsledku

%potrebujem zistit kolko tam je jednotasek, teda kolko je hran s rovnakymi koncami
% findall(R,euler(R),RL), length(RL,N),vypis(RL).


%kam([0,0],[1,2])
p([0,0]).  % Pole (0,0) existuje na šachovnici
p([0,1]).  % Pole (0,1) existuje
p([0,2]).  % Pole (0,2) existuje
p([1,0]).  % Pole (1,0) existuje
p([1,1]).  % Pole (1,1) existuje
p([1,2]).  % Pole (1,2) existuje
p([2,0]).  % Pole (2,0) existuje
p([2,1]).  % Pole (2,1) existuje
p([2,2]).  % Pole (2,2) existuje

tah1([X,Y], [X1,Y1]):-   % Definícia všetkých možných ťahov koňa z [X,Y] na [X1,Y1]
    X1 is X+1, Y1 is Y+2;  % ťah: +1 v X, +2 v Y
    X1 is X+2, Y1 is Y+1;  % ťah: +2 v X, +1 v Y
    X1 is X-1, Y1 is Y+2;  % ťah: -1 v X, +2 v Y
    X1 is X-2, Y1 is Y+1;  % ťah: -2 v X, +1 v Y
    X1 is X-1, Y1 is Y-2;  % ťah: -1 v X, -2 v Y
    X1 is X-2, Y1 is Y-1;  % ťah: -2 v X, -1 v Y
    X1 is X+1, Y1 is Y-2;  % ťah: +1 v X, -2 v Y
    X1 is X+2, Y1 is Y-1.  % ťah: +2 v X, -1 v Y

kon(X,Y,R):-              % Hlavný predikát: nájde cestu z X do Y
    kon(X,Y,[],R).        % Spustí pomocnú verziu s prázdnym zoznamom navštívených

kon(X,X,A,R):-            % Ak sme už v cieľovom poli
    reverse([X|A], R).    % pridáme X do cesty a otočíme ju do správneho poradia

kon(X,Y,A,R):-            % Rekurzívne hľadanie cesty
    tah1(X,Z),            % nájde možný ťah koňa z X na Z
    p(Z),                 % overí, že Z je platné pole na šachovnici
    not(member(Z,A)),     % zabezpečí, že Z sme ešte nenavštívili
    kon(Z,Y,[X|A],R).     % pokračuje z Z, pričom X uloží do cesty
%
%Program hľadá cestu koňa po šachovnici tak, že skúša všetky možné ťahy, kontroluje platné polia, nevracia sa na už navštívené a keď dosiahne cieľ, vráti celú cestu.
%


%predstavte si ze mate pole ktore ma nejake suradnice p([0,0]) az p([2,2]) prvy je vzdy x a druha je vzdy y suradnica, treba zrobit prikaz ktory zisti vsetky xove a yove suradnice
% coordinates(X,Y). vrati 
%= X[0,1,2]
% Y = [2,1,0] mozme pouzit prikazy findall sort a reverse, najprv si vsetky suradnice musim nadefinovat, zoberiem si vsetky suradnice pomocou findall usporiadam ich pomocou sort a potom ich rozdelim na xove a yove suradnice, nakoniec ich mozem vratit v poradi od 0 do 2 alebo od 2 do 

p([0,0]). 
p([0,1]). 
p([0,2]). 
p([1,0]).  
p([1,1]).  
p([1,2]).  
p([2,0]).  
p([2,1]).  
p([2,2]). 

coordinates(Xs, Ys):-
    findall(X, p([X,_]), XAll),
    sort(XAll, Xs),
    findall(Y, p([_,Y]), YAll),
    sort(YAll, YsAsc),
    reverse(YsAsc, Ys).

% proceduru ktora vyplni pole 3x3 tak ze objekt 1 bude vyzerat ze 3 na suradniciach [0][0], [0][1], [0][2] a objekt 2 bude vyzerat [0][0],[1][0],[2][0] a objekt 3 bude vyzerat [0][0],[0][1],[1][1]
%objekt 4 je na poziciach [2][0],[2][1],[1][1], objekt 5 na [0][0], [1][0], [0][1], objekt 6 je [1][0], [1][0], [1][1]

objekt(1, [X,Y],[X,Y1],[X,Y2]):- Y1 is Y+1, Y2 is Y+2. % Objekt 1: 3 na řádku
objekt(2, [X,Y],[X1,Y],[X2,Y]):- X1 is X+1, X2 is X+2. % Objekt 2: 3 na sloupci
objekt(3, [X,Y],[X,Y1],[X1,Y1]):- Y1 is Y+1, X1 is X+1. % Objekt 3: [X,Y],[X,Y+1],[X+1,Y+1]
objekt(4, [X,Y],[X,Y1],[X1,Y1]):- Y1 is Y+1, X1 is X-1. % Objekt 4: [X,Y],[X,Y+1],[X-1,Y+1]
objekt(5, [X,Y],[X1,Y],[X,Y1]):- X1 is X+1, Y1 is Y+1. % Objekt 5: 2 na řádku a 2 na sloupci
objekt(6, [X,Y],[X1,Y],[X1,Y1]):- X1 is X+1, Y1 is Y+1. % Objekt 6: 2 na řádku a 2 na sloupci

vypln(R):- 
    findall(S,p(S),SL),
    vypln1(SL,R),
    vypis(R).

vypln1([],[]).
vypln1(SL,[[ID,S1,S2,S3]|R]):- 
    member(S1,SL), 
    objekt(ID, S1, S2, S3), 
    member(S2,SL), 
    member(S3,SL),
    odstran(SL, [S1,S2,S3], SL1), 
    vypln1(SL1,R).
% nefugnuje mi to spravne pozriet od peta

%vlavo je 0 0 a vpravo hore 9 9 pri piskovrkach

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
reset:-
    retractall(p(_, _)),          % vymaze vsetky existujuce policka z databazy
    pole([0,1,2,3,4,5,6,7,8,9],   % vytvori vsetky X suradnice 0..9
         [0,1,2,3,4,5,6,7,8,9]),  % a pre kazde X vsetky Y suradnice 0..9
    vypis_pole.                   % vypise cele pole
                                  % poznamka: neskor sa da upravit tak,
                                  % aby suradnice zacinali od stredu,
                                  % nie od [0,0] v lavom hornom rohu

pole([],_).                       % ak uz nezostali ziadne X suradnice, koniec

pole([X|SX], SY):- 
    pole1(X, SY),                 % pre aktualne X vytvori vsetky body [X,Y]
    pole(SX, SY).                 % potom pokracuje so zvyskom X suradnic

pole1(_,[]).                      % ak uz nezostali ziadne Y suradnice, koniec

pole1(X,[Y|SY]):- 
    assert(p([X,Y],' ')),         % ulozi do databazy jedno prazdne policko
                                  % na pozicii [X,Y]
    pole1(X,SY).                  % pokracuje dalsim Y pre rovnake X


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

board(_,[]).                          % ak uz nie su dalsie riadky Y, vypis sa skonci

board(SX,[Y|SY]):-
    write(Y),                         % vypise cislo aktualneho riadku
    write(' | '),                     % vypise oddelovac za cislom riadku
    board1(SX,Y),                     % vypise obsah vsetkych policok v riadku Y
    nl,                               % novy riadok
    write('   --- --- --- --- --- --- --- --- --- ---'), % vodorovna ciara pod riadkom
    nl,
    board(SX,SY).                     % pokracuje na dalsi riadok

board1([],_).                         % ak uz nie su dalsie stlpce X, skonci vypis riadku

board1([X|SX],Y):- 
    p([X,Y],H),                       % zisti obsah policka na suradnici [X,Y]
    write(H),                         % vypise obsah policka
    write(' | '),                     % vypise oddelovac medzi stlpcami
    board1(SX,Y).                     % pokracuje na dalsi stlpec v tom istom riadku

% Tah hraca
th(S):- 
    p(S,' '),                         % overi, ze zadane policko je prazdne
    retract(p(S,' ')),                % odstrani fakt, ze policko je prazdne
    assert(p(S,'o')),                 % zapise na dane policko znak o
    vypis_pole,                       % vypise aktualny stav pola
    nl,
    write(S).                         % vypise suradnicu vykonaneho tahu

x([]):- vypis_pole.
x([H|T]):- 
    retract(p(H,' ')), 
    assert(p(H,'x')), 
    x(T).

tp:-
    pravidlo_vyhra_x(S, Pravidlo),
    urob_tah_x(S, Pravidlo),
    !.

tp:-
    pravidlo_blokuj_vyhru_o(S, Pravidlo),
    urob_tah_x(S, Pravidlo),
    !.

tp:-
    pravidlo_vytvor_hrozbu_x(S, Pravidlo),
    urob_tah_x(S, Pravidlo),
    !.

tp:-
    pravidlo_blokuj_hrozbu_o(S, Pravidlo),
    urob_tah_x(S, Pravidlo),
    !.

tp:-
    pravidlo_stred(S, Pravidlo),
    urob_tah_x(S, Pravidlo),
    !.

tp:-
    p(S,' '),                         % fallback: prve volne policko
    urob_tah_x(S, 'fallback prve volne').

urob_tah_x(S, Pravidlo):-
    retract(p(S,' ')),
    assert(p(S,'x')),
    vypis_pole,
    nl,
    write([S, Pravidlo]), nl,
    (vyhra('x', _) -> true ; true).

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

jedna_prazdna_styri(H, [A,B,C,D,E], A):- p(A,' '), p(B,H), p(C,H), p(D,H), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], B):- p(A,H), p(B,' '), p(C,H), p(D,H), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], C):- p(A,H), p(B,H), p(C,' '), p(D,H), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], D):- p(A,H), p(B,H), p(C,H), p(D,' '), p(E,H).
jedna_prazdna_styri(H, [A,B,C,D,E], E):- p(A,H), p(B,H), p(C,H), p(D,H), p(E,' ').

% vrati koncove volne pole pre vzor _HHH_
otvorena_trojica(H, [A,B,C,D,E], A):- p(A,' '), p(B,H), p(C,H), p(D,H), p(E,' ').
otvorena_trojica(H, [A,B,C,D,E], E):- p(A,' '), p(B,H), p(C,H), p(D,H), p(E,' ').

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
% kazdy nas tah bude vypsany pod tabulkou kde isiel a dalej pre moje dobro, si tam dame informaciu podla akeho pravidla taha, 
% ale musi sa vypisat suradnice na ktorej tahal pocita, hrac hraje koleckom, pocitac bude hrat krizikom

vyhra(H,R):- 
    p(S1,H),
    o(_,S1,S2,S3,S4,S5), 
    p(S2,H),
    p(S3,H),
    p(S4,H),
    p(S5,H),
    R=[S1,S2,S3,S4,S5], 
    write(['vyhra:',H,R]), nl.

o(1,[X,Y],[X1,Y],[X2,Y],[X3,Y],[X4,Y]):- X1 is X+1, X2 is X+2, X3 is X+3, X4 is X+4. % ->
o(2,[X,Y],[X1,Y1],[X2,Y2],[X3,Y3],[X4,Y4]):- X1 is X+1, Y1 is Y+1, X2 is X+2, Y2 is Y+2, X3 is X+3, Y3 is Y+3, X4 is X+4, Y4 is Y+4. % 5 na diagonále HORE
o(3,[X,Y],[X,Y1],[X,Y2],[X,Y3],[X,Y4]):- Y1 is Y+1, Y2 is Y+2, Y3 is Y+3, Y4 is Y+4. % | STLPEC SMER HORE
o(4,[X,Y],[X1,Y1],[X2,Y2],[X3,Y3],[X4,Y4]):- X1 is X+1, Y1 is Y-1, X2 is X+2, Y2 is Y-2, X3 is X+3, Y3 is Y-3, X4 is X+4, Y4 is Y-4. % 5 na diagonále dole

% naprogramovat si nejake 4-5 pravidiel, podla ktorych sa bude hrat, do buducej hodiny
% potom je dobre si vykusat 
% 8 a 9 tyzden budem robit cisto len pravidla na piskvorky, potom nam povie kto bude proti sebe hrat a v 10. tyzdni bude generalka, kazdy s kazdym bude hrat, vsetci budeme mat swi prolog
% vsetci budeme na pocitacoch v ucebne na prologu
% ci budeme musiet prist 7:15 alebo staci prist na 8, lebo 1 tyzden uz bude turnaj, potom bude moznost dorobit si projekty aby sme mali body od 100
% doporucuje generovat suradnice od stredku von, teda od [4,4] a potom sa bude generovat von, aby sme mali lepsiu predstavu o tom kde sa nachadzame, lebo v piskvorkach je to dost dolezite, ze v strede je vacsinou vacsia sanca na vyhru, pretoze tam je viac moznosti ako sa moze tahat, ale samozrejme to nie je pravidlo, ale je to dobra taktika
% MUSIME MAT 5 PRAVIDIEL NA DALSI TYZDEN ABY TO HRALO, naprogramovanych