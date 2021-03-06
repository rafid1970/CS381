% Name: Rikki Gibson
% ONID: gibsonri
% Name: Benjamin Narin
% ONID: narinb

% Here are a bunch of facts describing the Simpson's family tree.
% Don't change them!

female(mona).
female(jackie).
female(marge).
female(patty).
female(selma).
female(lisa).
female(maggie).
female(ling).

male(abe).
male(clancy).
male(herb).
male(homer).
male(bart).

married_(abe,mona).
married_(clancy,jackie).
married_(homer,marge).

married(X,Y) :- married_(X,Y).
married(X,Y) :- married_(Y,X).

parent(abe,herb).
parent(abe,homer).
parent(mona,homer).

parent(clancy,marge).
parent(jackie,marge).
parent(clancy,patty).
parent(jackie,patty).
parent(clancy,selma).
parent(jackie,selma).

parent(homer,bart).
parent(marge,bart).
parent(homer,lisa).
parent(marge,lisa).
parent(homer,maggie).
parent(marge,maggie).

parent(selma,ling).



%%
% Part 1. Family relations
%%

% 1. Define a predicate `child/2` that inverts the parent relationship.
child(X,Y) :- parent(Y,X).

% 2. Define two predicates `isMother/1` and `isFather/1`.
isMother(X) :- parent(X,_), female(X).
isFather(X) :- parent(X,_), male(X).

% 3. Define a predicate `grandparent/2`.
grandparent(X,Z) :- parent(X,Y), parent(Y,Z).

% 4. Define a predicate `sibling/2`. Siblings share at least one parent.
sibling(X,Y) :- parent(Z,X), parent(Z,Y), X \= Y.

% 5. Define two predicates `brother/2` and `sister/2`.
brother(X,Y) :- male(X), sibling(X,Y).
sister(X,Y) :- female(X), sibling(X,Y).

% 6. Define a predicate `siblingInLaw/2`. A sibling-in-law is either married to
%    a sibling or the sibling of a spouse.
siblingInLaw(X,Y) :- married(X,Z), sibling(Y,Z).
siblingInLaw(X,Y) :- sibling(X,Z), married(Y,Z).

% 7. Define two predicates `aunt/2` and `uncle/2`. Your definitions of these
%    predicates should include aunts and uncles by marriage.
% An aunt is a sibling or sibling-in-law of a parent.
aunt(X,Y) :- parent(Z,Y), (siblingInLaw(X,Z) ; sibling(X,Z)), female(X).
uncle(X,Y) :- parent(Z,Y), (siblingInLaw(X,Z) ; sibling(X,Z)), male(X).

% 8. Define the predicate `cousin/2`.
% A cousin is a child of an aunt or uncle.
cousin(X,Y) :- parent(T,X), parent(U,Y), sibling(T,U).

% 9. Define the predicate `ancestor/2`.
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(Z,Y), ancestor(X,Z).

% Extra credit: Define the predicate `related/2`.


%%
% Part 2. Language implementation (see course web page)
%%

bool(t).
bool(f).

literal(X) :- number(X).
literal(X) :- string(X).
literal(X) :- bool(X).

% `cmd/3`: the predicate cmd(C,S1,S2) means that executing command C with stack S1 produces stack S2.
cmd(E,S1,S2) :- literal(E), S2 = [E|S1].
cmd(add,[E1,E2|S1],S2) :- Res is E1 + E2, S2 = [Res|S1].
cmd(lte,[E1,E2|S1],S2) :- is_lte(E1,E2,B), S2 = [B|S1].
cmd(if(Then,_), [t|S1], S2) :- prog(Then, S1, S2).
cmd(if(_,Else), [f|S1], S2) :- prog(Else, S1, S2).

is_lte(X, Y, t) :- X =< Y.
is_lte(X, Y, f) :- X > Y.

% `prog/3`: prog(P,S1,S2) means that executing program P with stack S1 produces stack S2.
prog([], S, S).
prog([C|CS], S1, S2) :- cmd(C, S1, S_), prog(CS, S_, S2).
