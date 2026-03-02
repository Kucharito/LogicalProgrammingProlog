fib(1,1).
fib(2,1).
fib(N,F):-N>2,
N1 is N-1,
N2 is N-2,
fib(N1,F1),
fib(N2,F2),
F is F1 + F2.

h(a,e).
h(a,b).
h(c,d).
h(e,d).
h(b,c).

cesta(Z,Do):- h(Z,Do).
cesta(Z,Do):- h(Z,Z1), cesta(Z1,Do).


pocet([],0).
pocet([_|T],N):- pocet(T,N1),
    N is N1+1.

prvok(X,[X|_]).
prvok(X,[_|T]):-
      prvok(X,T).

licha_cisla([],[]).
licha_cisla([X|T], [X|T1]):- X mod 2 =:= 1, licha_cisla(T,T1).
licha_cisla([X|T], T1):- X mod 2 =:= 0, licha_cisla(T,T1).

sude_cisla([],[]).
sude_cisla([X|T], [X|T1]):- X mod 2 =:= 0, sude_cisla(T,T1).
sude_cisla([X|T], T1):- X mod 2 =:= 1, sude_cisla(T,T1). 

max([X],X).
max([H|T],M):- max(T,M1),
    M is max(H,M1).

min([X],X).
min([H|T],M):- min(T,M1),
    M is min(H,M1).

sucet_prvkov([],0).
sucet_prvkov([H|T],S):- sucet_prvkov(T,S1),
    S is S1+H.

reverse_list([],[]).
reverse_list([H|T],R):- reverse_list(T,R1),
    append(R1,[H],R).

gcd(X,0,X).
gcd(X,Y,G):- Y>0,
    R is X mod Y,
    gcd(Y,R,G).