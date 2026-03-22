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