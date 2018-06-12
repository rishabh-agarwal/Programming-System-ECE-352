/*		diffEl        */
diffEl(E1,E2,D) :- D is E2 - E1.


/*    DiffRow   */ 
diffRow([],[],[]).
diffRow([A|B],[C|D],[E|F]) :- diffEl(A,C,E), diffRow(B,D,F).


/*     Diff Image   */
diffIm([],[],[]).
diffIm([A|B],[C|D],[E|F]) :-  diffRow(A, C, E), diffIm(B, D, F).


/*      Print Image     */ 
printImage([]).
printImage([E|L]):- sepelem(E), nl, printImage(L). 	/* seprating Row from list */
sepelem([]).                					    /* seprating element from row */
sepelem([X|Y]):- write(X), sepelem(Y).


/*     isDiff       */
seprow([]).
seprow([E|F]):- elemsep(E), seprow(F).
elemsep([]).
elemsep([H|L]) :- H=0,!, elemsep(L).
isDiff([A|B],[C|D]):- diffIm([A|B],[C|D],[E|F]), not(seprow([E|F])).

/*     Rowmask      */
rowmask([],[],[],[],[]).
rowmask([A|B],[C|D],[E|F],[G|H],[I|J]):-  makeImask([A|B],[C|D],E,[G|H],[I|J]),rowmask(B,D,F,H,J),!.
makeImask([_|_],[_|_],E,[G|_],[I|_]):- E=0 , G is 0,I is 0.      
makeImask([_|_],[C|_],E,[G|_],[I|_]):- E>1 , G is 0,I is C. 
makeImask([A|_],[_|_],E,[G|_],[I|_]):- E<1 , G is A,I is 0.



/*      Mask        */ 
mask([],[],[],[],[]).
mask([A|B],[C|D],[E|F],[G|H],[I|J]):- rowmask(A,C,E,G,I),mask(B,D,F,H,J).



/*     fnzRowE1    */
fnzRowEl([],_).
fnzRowEl([A|B],W):- nth1(W,[A|B],E),not(E is 0).



/*    firstNonZero  */

fnzRowEl1([A|B],W):- nth1(W,[A|B],E),not(E is 0),!.
fnzRowEl1([A|B],_):- E is 0,nth1(_,[A|B],E),!.

first([],_).
first([A|B],Col):-fnzRowEl1(A,Col),first(B,Col).

incrCol(D, C) :- C is D+1.
fnzRowEl2([_],1).
fnzRowEl2([A|_],_):- not(A=0),!.
fnzRowEl2([_|B],C):-fnzRowEl2(B,D), incrCol(D, C),!.

incrRow(Rown, Row):- Row is Rown+1.
firstNonZero([A|_],1,Col):- fnzRowEl(A,Col),not(A=[]),!.
firstNonZero([A|B],Row,Col) :-fnzRowEl1(A,Col),firstNonZero(B,Rown,Col), incrRow(Rown, Row).


/*     Motion      */
motion([],[],_,_).
motion([A|B],[C|D],Moti,Motj):- diffIm([A|B],[C|D],Diff),mask([A|B],[C|D],Diff,Mask1,Mask2),printImage(Mask1),printImage(Mask2),firstNonZero(Mask1,Row1,Col1),firstNonZero(Mask2,Row2,Col2),Moti is Row2-Row1, Motj is Col2-Col1,!.
motion(_,_,Moti,Motj) :- not(Moti==0),not(Motj==0),nl,nl,nl,nl,write('***** No Motion in This Case *****'),nl,nl,nl,nl,!.



