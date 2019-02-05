	/* CPS721: Assignment 5, Part 2, file philosophers.pl */
        
/* This is necessary if rules with the same predicate in the head are not
 consecutive in your program. Read handout about Eclipse Prolog 6 for details. */
:- dynamic thinking/2 , waiting/2 , eating/2, available/2 , has/3.

	/* Universal situations and fluents based planner  */

solve_problem(N,Plan)  :-  Cin is cputime,      % initial cputime time is Cin
                max_length(Plan,N), 
                reachable(S,Plan), goal_state(S),
                Cf is cputime, D is Cf - Cin, nl, % final cputime is Cf
                write('Elapsed time (sec): '), write(D), nl.  % D is duration

reachable(S,[]) :- initial_state(S).

reachable(S2, [M | History]) :- reachable(S1,History),
                        legal_move(S2,M,S1).

/*  Remove comments if you want to solve the bonus question
reachable(S2, [M | History]) :- reachable(S1,History),
                        legal_move(S2,M,S1),
                        not useless(M,History).
*/
legal_move([A | S], A, S) :- poss(A,S).

initial_state([]).

max_length([],N) :- N >= 0.
max_length([First | L],N1) :- N1 > 0, N is N1 - 1, max_length(L,N).

/*                 Precondition Axioms                    */

%% write your precondition rules here
poss(pickUp(P,F),S) :- philosopher(P), fork(F), available(F,S), between(P,F,_).
poss(putDown(P,F),S) :- philosopher(P), fork(F), has(P,F,S).
poss(tryToEat(P),S) :- philsopher(P), has(P,F1,S), has(P,F2,S), not F1 = F2.
	
/*                   Successor State Axioms                */	

%% write your successor state rules here

/*                  Initial and Goal States                    */

:- [ 'philosophersInit' ].

/* This is to compile the file philosophersInits.pl  before you run a query. 
   Do NOT insert this file here because your program will be tested 
   using different initial and goal states. Both this file and philosophersInit
   must be in the same folder on your computer.
*/

/*             Declarative Heuristics                    */

/* This part is not mandatory. It is only for students who would like
to try solving a bonus questions. Write your declarative heuristics here, 
but save the file as bonus.pl    
*/

