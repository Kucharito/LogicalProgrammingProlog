% pruchod cyklickym grafom
%a-b,b-c,c-d,a-e,b-e,e-d

%h(a,b).
%h(b,c).
%h(c,d).
%h(a,e).
%h(b,e).
%h(e,d).

e(X,Y):- h(X,Y).
e(X,Y):- h(Y,X).

cestaa(X,Y,P):- cestaa(X,Y,[],P). % [] je ten akumulator
%cestaa(X,X,A,P):- reverse(A,P). % ked sa dostaneme do toho isteho uzla, tak revertneme akumulator a vratime ho ako cestu
cestaa(X,X,A,P):- reverse([X|A],P).
cestaa(X,Y,A,P):- e(X,Z), not(member(Z,A)), cestaa(Z,Y,[X|A],P).


vypis([]).
vypis([H|T]):- write(H), nl, vypis(T).


%findall(P, cestaa(a,d,P),PL),vypis(PL).

%findall([X,Y],e(X,Y),EL),vypis(EL).

%urobit program pri overeni ci je program jednotaska resp. eulerov graf
h(a,b).
h(a,c).
h(a,d).
h(b,c).
h(b,d).
h(c,d).
h(c,e).
h(d,e).


euler(R):-
    findall([X,Y], e(X,Y), EL),
    member(H, EL),
    tah(H, EL, [], R).

tah(H, [], A, R):-
    reverse([H|A], R).
tah([X,Y], EL, A, R):-
    member([Y,Z], EL),
    Z \= X,
    odstran(EL, [[X,Y], [Y,X], [Y,Z], [Z,Y]], EL1),
    tah([Y,Z], EL1, [[X,Y]|A], R).

odstran([], _, []).
odstran([H|L1], L2, L3):-
    member(H, L2),
    odstran(L1, L2, L3).
odstran([H|L1], L2, [H|L3]):-
    not(member(H, L2)),
    odstran(L1, L2, L3).

%potrebujem zistit kolko tam je jednotasek, teda kolko je hran s rovnakymi koncami
% findall(R,euler(R),RL), length(RL,N),vypis(RL).


%kam([0,0],[1,2])
p([0,0]).
p([0,1]).
p([0,2]).
p([1,0]).
p([1,1]).
p([1,2]).
p([2,0]).
p([2,1]).
p([2,2]).

tah1([X,Y], [X1,Y1]):-
    X1 is X+1, Y1 is Y+2;
    X1 is X+2, Y1 is Y+1;
    X1 is X-1, Y1 is Y+2;
    X1 is X-2, Y1 is Y+1;
    X1 is X-1, Y1 is Y-2;
    X1 is X-2, Y1 is Y-1;
    X1 is X+1, Y1 is Y-2;
    X1 is X+2, Y1 is Y-1.

kon(X,Y,R):-
    kon(X,Y,[],R).
kon(X,X,A,R):-
    reverse([X|A], R).
kon(X,Y,A,R):-
    tah1(X,Z),
    p(Z),
    not(member(Z,A)),
    kon(Z,Y,[X|A],R).

%9 pole a pohyb kona
%
%