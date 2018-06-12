/*Following function used for multiplying 2 numbers*/
ismult(A,B,W) :- W is A*B.

/*my is, just like discussed in class*/
op(X,Y):-Y is X.

/*decrement 2 numbers using my is*/
dec(X,Y):-op(X-1,Y).

/*assigning 0 to a variable used in hopTrainAstate*/
produce(A):-A=0.

/*Used to add all the elements in the list*/
lsum([], 0).
lsum([H|T], Tsum) :-lsum(T, Sum1), op(H+Sum1,Tsum).

/*Simple multiplication of elements of two lists*/
mul2([],[],[]).
mul2([H1|T1],[H2|T2],[W1|W2]) :- ismult(H1,H2,W1),mul2(T1,T2,W2).

/*netAll using mul2 and lsum*/
netAll(_,[],[]).
netAll(S,[H3|T3],[W3|W4]) :- mul2(S,H3,Z),lsum(Z,W3),netAll(S,T3,W4),!.

/*energy function is made using the formula, using mul2, lsum and ismult*/
energy([],[],[]).
energy(S,[S2|P2],W) :- netAll(S,[S2|P2],R), mul2(S,R,Z), lsum(Z,Y), ismult(-0.5,Y,W).

/*netUnit function made using mul2, lsum. multiplies list and returns its sum*/
netUnit(S1,S2,W):-mul2(S1,S2,R),lsum(R,W).

/*Following function is implemented using simple comparison. Returns -1 if N<A, -1 if N>A and O if N=A*/
hop11Activation(N,A,_,-1):-N<A,!.
hop11Activation(N,A,_,1):-N>A,!.
hop11Activation(N,A,O,O):-N=A,!.

/*nextstate implemented using mul2 and lsum, and then the resultant value is squashed*/
nextState([_|_],[],_,[]).
nextState([S|P],[H3|T3],At,[W3|W4]) :- mul2([S|P],H3,Z),lsum(Z,R),squash(R,At,W3),nextState([S|P],T3,At,W4),!.

/*Squashing, returns -1 if N<A, 1 if N>A, 0 if N=A*/
squash(N,A,-1):-N<A,!.
squash(N,A,1):-N>A,!.
squash(N,A,0):-N=A,!.

/*Assigning a list to a variable*/
make([],[]).
make([H|T],[RH|RT]):-op(H,RH),make(T,RT).

/*updateN runs nextState R number of times and returns when 0 is encountered*/
updateN(G,_,_,0,W):-make(G,W),!.
updateN(Os,H,Al,R,W):-nextState(Os,H,Al,G),dec(R,Z),updateN(G,H,Al,Z,W),!.

/*check function for findsEquilibrium*/
check(S,P,true):-S=P.
check(_,_,false).

/*compares the value returned by updateN R and R-1 times using the check function*/
findsEquilibrium(Os,H,Al,R,W):-updateN(Os,H,Al,R,A),dec(R,Nr),updateN(Os,H,Al,Nr,B),check(A,B,W),!.

/*checkh function used for hopmul for assigning 0 values*/
checkh(_,A,B,0.0):-A=B.
checkh(W,_,_,W).

/*top level multiplication for hopTrainAstate which multiplies 2 lists and returns a list with 0 elements*/
hopmul(_,[],_,_,[]).
hopmul(H,[H1|T1],A,B,[W1|W2]) :- ismult(H,H1,P),checkh(P,A,B,W1),op(B+1,C),hopmul(H,T1,A,C,W2),!.

/*second level multiplication for hopTrainAstate which calls hopmul till list is empty*/
hopmul2(_,[],_,_,[]).
hopmul2(Os,[S|P],A,B,[WH|WT]):-hopmul(S,Os,A,B,WH),op(A+1,C),hopmul2(Os,P,C,B,WT),!.

/*Sending two values A and B into hopTrainAstate so that 0 values can be inputted in the result*/
hopTrainAstate(Os,W):-produce(A),produce(B),hopmul2(Os,Os,A,B,W).

/*first level add for hopTrain to add 2 lists and return one list*/
hopAdd([],[],[]).
hopAdd([H1|T1],[H2|T2],[WH|WT]):-op(H1+H2,WH),hopAdd(T1,T2,WT).

/*second level add for hopTrain to add 2 list of list and return one list of list*/
hopAdd2([],[],[]).
hopAdd2([H1|T1],[H2|T2],[WH|WT]):-hopAdd(H1,H2,WH),hopAdd2(T1,T2,WT).

/*This function just adds 2 list of list inside a list of list of list and returns a final list of list*/
hopReturn([H1|T1],H1):-T1=[].
hopReturn([H1,H2|T1],W):-hopAdd2(H1,H2,C),hopReturn([C|T1],W),!.

/*makes hoptrainAstate for each lists and returns a list of list of list*/
hopT([],[]).
hopT([OH|OT],[WH|WT]):-hopTrainAstate(OH,WH),hopT(OT,WT).

/*Congratulations*/
hopTrain(Os,W):-hopT(Os,P),hopReturn(P,W),!.

/*Implemented using the hop11Activation*/
hop11ActAll([],_,[],[]).
hop11ActAll([H1|T1],A,[H2|T2],[WH|WT]):-hop11Activation(H1,A,H2,WH),hop11ActAll(T1,A,T2,WT),!.