/* Sanval Sohail  500760649
 * Johnathan Cruz 500761803
 * Fahim Nadeem   500777986
 */

/* Question 2.1 */

everyOther([],[]).

everyOther([List1],[List1]).

everyOther([X,_|List1], [X|List2]) :- everyOther(List1,List2).

/* Question 2.2
 * the below is_member is not my code but a copy of the member code from the
 * standard predicates included with prolog I re-wrote it because thats what 
 * it said to do in the assignment page 
 */

is_member(X,[X|_]).

is_member(X,[_Y|T]) :- is_member(X,T).

removeDups([],[]).

removeDups([Head|List1],List2) :- is_member(Head,List1), removeDups(List1,List2).

removeDups([Head|List1], [Head|List2]) :- not(is_member(Head,List1)), removeDups(List1, List2).

/* Question 2.3 */

sameFirstLast([Head,Head]).

sameFirstLast([Head,_|List]) :- sameFirstLast([Head|List]).



