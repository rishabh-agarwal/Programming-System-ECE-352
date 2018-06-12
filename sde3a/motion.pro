/**
This program, SDE #3, implements an image based tracking algorithm in SWI-Prolog by designing, implementing and testing a number of speficied Prolog functions.

Copyright (C) 2015 Amit Jain 

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any late version. 

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.  

You should have received a copy of the GNU General Public License along with this program;  if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  
*/

/*      Print Image     */ 
printImage([]).
printImage([A|B]):- separate(A), nl, printImage(B). 	

/* seprating Row from list */
separate([]).                					    
separate([A|B]):- write(A), write(' '), separate(B).


/*		diffElement        */
diffElement(A,B,C) :- C is B - A.
/*    DiffRow   */ 
diffImRow([],[],[]).
diffImRow([A|B],[C|D],[E|F]) :- diffElement(A,C,E), diffImRow(B,D,F).
/*     Diff Image   */
diffIm([],[],[]).
diffIm([A|B],[C|D],[E|F]) :-  diffImRow(A, C, E), diffIm(B, D, F).


/*     isDiff       */
rr([]).
rr([E|F]):- element(E), rr(F).
element([]).
element([H|L]) :- H=0,!, element(L).
isDiff([A|B],[C|D]):- diffIm([A|B],[C|D],[E|F]), not(rr([E|F])).

/*     rowmask      */
msk( _, _, 0, I1MRH, I2MRH ) :- I1MRH is 0, I2MRH is 0.
msk( I1RH, I2RH, DIRH, I1MRH, I2MRH ) :-( DIRH < 0, I1MRH is I1RH, I2MRH is 0 ) ;
( DIRH > 0, I2MRH is I2RH, I1MRH is 0 ).


rowmask( [], [], [], [], [] ).
rowmask( [I1RH|I1RT], [I2RH|I2RT], [DIRH|DIRT], [I1MRH|I1MRT], [I2MRH|I2MRT] ) :-
msk( I1RH, I2RH, DIRH, I1MRH, I2MRH ),
rowmask( I1RT, I2RT, DIRT, I1MRT, I2MRT ), !.


/*      mask        */
/* mask(+Image1,+Image2,+DiffIm,-I1masked,-I2masked) */
mask( [], [], [], _, _ ).
mask( [A|B], [C|D], [E|F], [G|H], [I|J] ) :-
rowmask( A, C, E, G, I ), mask( B, D, F, H, J ).


%centImRow(+Image,+Start_j,-CIR)
centImRow([], _, CIR) :- CIR is 0.
centImRow([A|B], Start_j, CIR) :- centImRowRow(A, Start_j, F), centImRow(B, Start_j, S), CIR is F + S.
centImRowRow([], _, CIR) :- CIR is 0.
centImRowRow([A|B], Start_j, CIR) :- centImRowRow(B, Start_j + 1, F), CIR is F+A*Start_j.


centCol([], _, X) :-X is 0.
centCol([A|B], J, CIR) :-Value is (J * A),
centCol(B, J, Val),CIR is (Value + Val).
centImCol([], _, X) :-X is 0.
centImCol([A|B], J, CIR) :-centCol(A, J, Row),
Index is (J + 1),centImCol(B, Index, Rest),CIR is (Row + Rest).


sumImage([], Sum) :- Sum is 0.
sumImage([[]|C], Sum) :- sumImage(C, X),!, Sum is X.
sumImage([[A|B]|C], Sum) :- sumImage([B|C], X), Sum is A + X.


icent(Mask, Cent) :- centImCol(Mask, 1, X), sumImage(Mask, Sum), Cent is float(X) / float(Sum).
jcent(Mask, Cent) :- centImRow(Mask, 1, X), sumImage(Mask, Sum), Cent is float(X) / float(Sum).


motion(Image1, Image2,_,_) :-
not(isDiff(Image1, Image2)),write('***** No Motion in This Case *****'),nl,!.

%motion(+Image1,+Image2,-Moti,-Motj)
motion(Image1,Image2,Moti,Motj) :-
  diffIm(Image1, Image2, Diff),
  mask(Image1, Image2, Diff, I1Masked, I2Masked),
  icent(I2Masked, I2icent),
  icent(I1Masked, I1icent),
  jcent(I2Masked, I2jcent),
  jcent(I1Masked, I1jcent),
  Moti is I2icent - I1icent,
  Motj is I2jcent - I1jcent.



