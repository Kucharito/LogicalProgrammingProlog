% zena (kto).
zena(alena).
zena(jana).
zena(tereza).
zena(eva).
zena(ivana).
% muz(kto).
muz(tomas).
muz(olda).
muz(honza).
muz(patrik).
muz(peter).


rodic(alena,tereza).
rodic(alena,honza).
rodic(tomas,tereza).
rodic(tomas,honza).
rodic(jana,eva).
rodic(jana,patrik).
rodic(olda,eva).
rodic(olda,patrik).
rodic(honza,ivana).
rodic(honza,peter).
rodic(eva,ivana).
rodic(eva,peter).
% matka(kto,koho)

matka(X,Y):-zena(X), rodic(X,Y).
otec(X,Y):- muz(X), rodic(X,Y).

babka(X,Y):-matka(X,Z), rodic(Z,Y).
dedko(X,Y):- otec(X,Z), rodic(Z,Y).

brat(X,Y):- muz(X), rodic(Z,X), rodic(Z,Y), X\=Y.
sestra(X,Y):- zena(X), rodic(Z,X), rodic(Z,Y), X\=Y.

stryc(X,Y):- brat(X,Z), rodic(Z,Y).
teta(X,Y):- sestra(X,Z), rodic(Z,Y).

pradedko(X,Y):- dedko(X,Z), rodic(Z,Y).
prababka(X,Y):- babka(X,Z), rodic(Z,Y).

b(1).
b(2).
b(3).
b(4).
obarvi(A,B,C,D,E,F,G):- 
    b(A),b(B), A\=B,
    b(C), A\=C,
    b(D), A\=D, B\=D, C\=D,
    b(E), B\=E, D\=E,
    b(F), C\=F, D\=F,
    b(G), D\=G, F\=G, E\=G.

vypln(A,B,C,D,E,F,G,H,I):- 
    b(A),b(B),b(C),
    R1 is A+B+C,
    b(D),b(G),
    R1 is A+D+G,
    b(E),b(F),
    R2 is D+E+F,
    b(H),
    R2 is B+E+H,
    b(I),
    R3 is C+F+I,
    R3 is G+H+I.

fakt(0,1).
fakt(N,F):
    N>0,
    N1 is N-1,
    fakt(N1,F1),
    F is N*F1.