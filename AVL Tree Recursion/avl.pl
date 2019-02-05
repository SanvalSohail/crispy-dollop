/* Sanval Sohail  500760649
 * Johnathan Cruz 500761803
 * Fahim Nadeem   500777986
 */
%unfinished
tree(void).
tree(Elim, Left, Right).
height(void, 0 ).
height(tree(_,Left,Right), H) :-
height(Left, LH),
height(Right, RH),
H is max(LH, RH) + 1.
