%prechod grafom
% h (odkud,kam)
h(a,e).
h(a,b).
h(c,d).
h(e,d).
h(b,c).

% cesta (Z,Do)
cesta(Z,Do):- h(Z,Do).
cesta(Z,Do):- h(Z,Z1), cesta(Z1,Do).

%prechod ohodnotenym grafom
% h(odkud,kam)

h(a,e,4).
h(a,b,1).
h(c,d,3).
h(e,d,5).
h(b,c,2).

%cesta(z,do,cena).

cesta(Z,Do):- h(Z,Do,_).
cesta(Z,Do):- h(Z,Z1,_), cesta(Z1,Do).
cesta(Z,Do,Cena):-h(Z,Do,Cena).
cesta(Z,Do,Cena):- 
    h(Z,Z1,Cena1),
    cesta(Z1,Do,Cena2),
    Cena is Cena1+Cena2.

%cesta(z,do,cena,cez co).
cesta(Z,Do,Cena,[]):- h(Z,Do,Cena).
cesta(Z,Do,Cena,[Z1|Cez]):- 
    h(Z,Z1,Cena1),
    cesta(Z1,Do,Cena2,Cez),
    Cena is Cena1+Cena2.

%prirodzene cislo
% nat(N) tak vrati true, ak N je prirodzene cislo ak dam zaporne cislo tak vrati false
nat(0).
nat(N):- N>0, N1 is N-1, nat(N1).

% generovanie prirodzenych cisel
nat_gen(0).
nat_gen(N):- nat_gen(N1), N is N1+1.

%konecne automaty

i(1).
f([3]).
d(1,a,3).
d(1,a,2).
d(2,b,2).
d(2,a,1).

ka(S,[]):- 
    f(FS), %f je hore zadefinovany ako 3, teda 3 stavy
    member(S,FS), % S je prvok zoznamu FS
    nl,
    write('END').

ka(S,[H|T]):- 
    nl,
    write(S), % vypisuje aktualny stav
    write(': '), 
    atom_chars(W, [H|T]),
    write(W),
    d(S,H,S1), % zo stavu S po znaku H do stavu S1
    write('->'),
    write(S1), % vypise stav S1
    ka(S1,T).


%append([a,b,c],[d,e],X).

start:- 
    write('Zadaj slovo: '),
    read(W),
    atom_chars(W, WL),
    i(S),
    ka(S,WL).
    
% length([a,b,c],N). N=3
% zo vstupneho slova urcite prefix 
% zadat treba prefix(abcd,2,x)
% tak da ze x je ab
prefix(W,L,P):- 
    atom_chars(W, WL),      % premení atom (slovo) W na zoznam znakov WL
                            % napr. W = abcd → WL = [a,b,c,d]

    append(PW, _, WL),      % rozdelí WL na dve časti: PW + niečo
                            % PW bude prefix zoznamu WL
                            % _ znamená že zvyšok nás nezaujíma

    length(PW, L),          % vyberie taký prefix PW, ktorý má dĺžku L

    atom_chars(P, PW).      % premení zoznam znakov PW späť na atom P
                            % napr. [a,b] → P = ab

% pozicia(cd,abcd,X).
% pozicia(co,kde,N)
%atom_chars(Co,CoL),
%atom_chars(Kde,KdeL),
%append(P,S,kdeL),
%append(Col,X,S),
%length(P,P1),
%N is P1+1.
% X=3

%toto je spravne
pozice(Co,Kde,N):-
    atom_chars(Co,CoL),     % premení podreťazec Co na zoznam znakov
                            % napr. Co = cd → CoL = [c,d]

    atom_chars(Kde,KdeL),   % premení celé slovo Kde na zoznam znakov
                            % napr. Kde = abcd → KdeL = [a,b,c,d]

    append(P,S,KdeL),       % rozdelí KdeL na prefix P a suffix S
                            % KdeL = P + S

    append(CoL,_,S),        % kontroluje či suffix S začína CoL
                            % teda či sa podreťazec nachádza na tej pozícii

    length(P,N1),           % zistí dĺžku prefixu P
                            % to je počet znakov pred výskytom

    N is N1+1.              % pozícia je o 1 väčšia (Prolog počíta od 0)

%zamena(Co,Zaco,kde,Result).
%zmena(ab,b,abc,X)
%X=aabc
zamen(Co,Zaco,Kde,Result):-
    atom_chars(Co,CoL),       % premení náhradný reťazec Co na zoznam znakov
                              % napr. Co = ab → CoL = [a,b]

    atom_chars(Zaco,ZacoL),   % premení hľadaný reťazec Zaco na zoznam znakov
                              % napr. Zaco = b → ZacoL = [b]

    atom_chars(Kde,KdeL),     % premení celé slovo Kde na zoznam znakov
                              % napr. Kde = abc → KdeL = [a,b,c]

    append(P,S,KdeL),         % rozdelí slovo na prefix P a suffix S
                              % KdeL = P + S

    append(ZacoL,X,S),        % kontroluje či suffix S začína hľadaným reťazcom
                              % S = ZacoL + X
                              % teda sme našli výskyt Zaco

    append(P,CoL,R),          % vytvorí začiatok nového slova
                              % prefix + nový reťazec

    append(R,X,ResultL),      % pripojí zvyšok slova za náhradou

    atom_chars(Result,ResultL). % premení zoznam znakov späť na atom