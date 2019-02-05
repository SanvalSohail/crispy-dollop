
washer(w1).     dryer(d1).

clothes(cl1).   clothes(cl2). hamper(h1).     hamper(h2).

soap(p1).       soap(p2).
cupboard(cbd1). cupboard(cbd2).

softener(sft1). softener(sft2). 

in(cl1,h1,[]).  in(cl2,h2,[]).

in(p1,cbd1,[]).
in(p2,cbd2,[]). 

in(sft1,cbd1,[]).       in(sft2,cbd2,[]).



/* Goal 1 */

 goal_state(S) :- clean(cl1,S).


/* Goal 2 */

%goal_state(S) :- clean(cl1,S), not wet(cl1,S).


/* Goal 3 */

%goal_state(S):- clean(cl1,S), not wet(cl1,S), folded(cl1,S), in(cl1,dresser,S).



/*
goal_state(S) :- clean(cl1,S), clean(cl2,S), not wet(cl1,S), not wet(cl2,S),
        folded(cl1,S), folded(cl2,S), in(cl1,dresser,S), in(cl2,dresser,S).
*/
