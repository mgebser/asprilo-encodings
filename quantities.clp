#include <csp>. 

&dom{N..N}              = ordered(O,A,0) :- init(object(order,O),   value(line,(A,N))).
&dom{0..ordered(O,A,0)} = ordered(O,A,T) :- ordered(O,A), time(T).
&dom{N..N}              = shelved(S,A,0) :- init(object(product,A), value(on,  (S,N))).
&dom{0..shelved(S,A,0)} = shelved(S,A,T) :- shelved(S,A), time(T).

&dom{0..ordered(O,A,0)} = process(A,O,S,T) :- ordered(O,A), shelved(S,A), time(T).

{ process(A,O,S,T) : ordered(O,A), shelved(S,A) } 1 :- time(T). % process one article at a time at one processing station (via order)

:- process(_,O,_,T), target(O,P), not serves(_,P,T).
:- process(A,O,S,T), target(O,P),     serves(R,P,T), not carries(R,S,T).
:- process(A,O,S,T), &sum{ shelved(S,A,T-1); -process(A,O,S,T) } < 0.

:-     process(A,O,S,T), shelved(S,A),               &sum{ shelved(S,A,T-1); -shelved(S,A,T); -process(A,O,S,T) } != 0.
:-     process(A,O,S,T),               ordered(O,A), &sum{ ordered(O,A,T-1); -ordered(O,A,T); -process(A,O,S,T) } != 0.
:-     process(A,O,S,T),                             &sum{                                     process(A,O,S,T) }  = 0.

:- not process(A,_,S,T), shelved(S,A),               &sum{ shelved(S,A,T-1); -shelved(S,A,T)                    } != 0, time(T).
:- not process(A,O,_,T),               ordered(O,A), &sum{ ordered(O,A,T-1); -ordered(O,A,T)                    } != 0, time(T). % >>> REPORT MAX!!! <<<
:- not process(A,O,S,T), shelved(S,A), ordered(O,A), &sum{                                     process(A,O,S,T) } != 0, time(T).







%*
:-                    shelved(S,A),               &sum{ shelved(S,A,T-1); -shelved(S,A,T)                         }  < 0, time(T).
:-                                  ordered(O,A), &sum{ ordered(O,A,T-1); -ordered(O,A,T)                         }  < 0, time(T).
*%
