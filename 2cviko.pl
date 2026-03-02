:- discontiguous cesta/2.

% fibonacii
% fib(N,F)
fib(1,0).
fib(2,1).
fib(N,F):-N>2,
N1 is N-1,
N2 is N-2,
fib(N1,F1),
fib(N2,F2),
F is F1 + F2.

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

%datova struktura seznam

pocet([],0).
pocet([_|T],N):- pocet(T,N1),
    N is N1+1.

%prvok(a,[b,c,a]). true

prvok(X,[X|_]).
prvok(X,[_|T]):-
      prvok(X,T).

%parne pozicie v zozname
sude_pozice([],[]).
sude_pozice([_],[]).
sude_pozice([_,B|T1],[B|T2]):- sude_pozice(T1,T2).

%liche cisla
licha_cisla([],[]).
licha_cisla([H|T],[H|T1]):-1 is H mod 2, licha_cisla(T,T1).
licha_cisla([H|T],T1):- 0 is H mod 2, licha_cisla(T,T1).



