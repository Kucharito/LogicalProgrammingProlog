% naprogramovat, predikat (proceduru) napriklad vyber(seznam_cisel,Result).
% a v tom resulte bude zase zoznam s fibonaciho cislami, ktore su
% odpovedaju pozicii cisel v zozname
% takze napriklad vyber([2,4,1,3],Result) R = [1,2,0,1]
%fibonacciho cisla su 0,1,1,2,3,5,8

fib(1,0).
fib(2,1).
fib(N,F):-N>2,
N1 is N-1,
N2 is N-2,
fib(N1,F1),
fib(N2,F2),
F is F1 + F2.

vyber([],[]).
vyber([H|T],[F|R]):- fib(H,F), vyber(T,R).

