% ocisluj od 1-4 a cislo tam bolo prave jedno
% ocisluj(A....D).
% A=1, B=2, C=3, D=4

b(1).
b(2).
b(3).
b(4).

ocisluj(A,B,C,D):-
    b(A),b(B),b(C),b(D),
    A\=B, A\=C, A\=D,
    B\=C, B\=D,
    C\=D.
