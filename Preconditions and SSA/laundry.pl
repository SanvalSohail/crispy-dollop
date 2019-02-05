  /* Iterative deepening situations and fluents based planner from CPS721 */
		
:- dynamic clean/2.
:- dynamic wet/2.
:- dynamic folded/2.
:- dynamic holding/2.
:- dynamic hasSoap/2.
:- dynamic hasSoftener/2.
:- dynamic hasLint/2.
:- dynamic in/3.

/* These rules say that the rules with a predicate can be not consecutive in 
   your program. The number "2" (or "3") is the arity of your fluent.
*/

% We are looking for a list of actions represented by a variable Plan
% such that executing actions in Plan leads from the initial state
% to a reachable state where a goal condition is true.

solve_problem(Bound,Plan)  :-  C0 is cputime,     % C0 is time when program starts %
          max_length(Plan,Bound),          % Bound is the maximal length of Plan   %
          reachable(S,Plan),
          goal_state(S),           % A situation S must be a solution of the problem %
          Cf is cputime, Diff is Cf - C0, nl,     % Cf is time when program finishes  %
          write('Elapsed time (sec): '), write(Diff), nl.

max_length([],N) :- N >= 0.
max_length([First | L],N1) :- N1 > 0, N is N1 - 1, max_length(L,N).

reachable(S,[]) :- initial_state(S).

/* The following rule is for the simplest instances of your planning domain.
   Use it when you debug your precondition and other rules and
   when you test whether your program can solve easy planning problems. 
   Comment it out, when solving planning problems with heuristics. Instead, 
   use the other rule provided below.
*/
reachable(S2, [M | List]) :- reachable(S1,List), legal_move(S2,M,S1).

/* Recall that situation argument S is the list of previously executed actions.
   In the list [Move | S], Move represents the most recent action.      */

/*The following rule uses declarative heuristics to cut search: remove comments
   and write your rules to implement the predicate useless(M,List) (see below).
   You can use this when solving more complex instances in the planning domain.
   Note that the predicate "useless(M,S)" is the only innovation with respect 
   to clauses in the Problem Solving section, page 11.

reachable(S2, [M | ListOfPastActions]) :- reachable(S1,ListOfPastActions),
                    legal_move(S2,M,S1),
                    not useless(M,ListOfPastActions).
*/
/* The following 2 clauses are from the Problem Solving section, page 31. */

legal_move([A|S], A, S) :- poss(A,S).
initial_state([]).

        	/* Precondition axioms */
/* 
Write precondition axioms for all actions in your domain. Recall that to avoid
potential problems with negation in Prolog, you should not start bodies of your
rules with negated predicates. Make sure that all variables in a predicate 
are instantiated by constants before you apply negation to the predicate that 
mentions these variables. 
*/
% write your precondition rules here: you have to provide brief comments %

poss(putAway(O,C), S) :- cupboard(C), holding(O,S), not in(O,C,S).
poss(fetch(O,C), S) :-  cupboard(C), not holding(O,S), in(O,C,S). 
poss(addSoap(P,W), S) :- holding(P,S), not hasSoap(W,S), washer(W), soap(P).
poss(addSoftener(T,W), S) :-washer(W),softener(T), holding(T,S), not hasSoftener(W,S).
poss(removeLint(D), S) :- dryer(D), hasLint(D,S).
poss(washClothes(C,W),S) :- washer(W),clothes(C), in(C,W,S), hasSoftener(W,S), hasSoap(W,S), not clean(C,S).
poss(dryClothes(C,D),S) :- in(C,D,S), wet(C,S),  not hasLint(D,S), dryer(D), clothes(C).
poss(fold(C), S) :- clean(C,S), not wet(C,S), not holding(_,S), clothes(C).
poss(wear(C), S) :- folded(C,S), clothes(C).
poss(move(C,F,T), S) :- in(C,F,S), not in(C,T,S),clothes(C),container(T),container(F), not F = T. 

container(dresser).
container(X) :- washer(X).
container(X) :- dryer(X).
container(X) :- cupboard(X).
container(X) :- hamper(X).

        	/* Successor state axioms */
/* 
Write successor-state axioms that characterize how the truth value of all 
fluents change from the current situation S to the next situation [A | S]. 
You will need two types of rules for each fluent: 
	(a) rules that characterize when a fluent becomes true in the next situation 
	as a result of the last action, and
	(b) rules that characterize when a fluent remains true in the next situation,
	unless the most recent action changes it to false.
When you write successor state axioms, you can sometimes start bodies of rules 
with negation of a predicate, e.g., with negation of equality. This can help 
to make them a bit more efficient.
*/
% write your successor state rules here: you have to write brief comments %
in(O,C,[putAway(O,C)|S]).
in(O,C,[move(O,F,C)|S]).
in(O,C,[A|S]) :-  not A = fetch(O,C), not A = move(O,C,F), in(O,C,S).
holding(O,[fetch(O,_)|S]).
holding(O,[A|S]) :- not A = putAway(O,_), not A = addSoap(O,_), not A = addSoftener(O,_), holding(O,S).
hasSoap(W,[addSoap(_,W)|S]).
hasSoap(W,[A|S]) :-  not A = washClothes(_,W),hasSoap(W,S).
hasSoftener(W,[addSoftener(_,W)|S]).
hasSoftener(W,[A|S]) :- not A = washClothes(_,W), hasSoftener(W,S).
hasLint(D,[dryClothes(_,D)|S]).
hasLint(D,[A|S]) :- not A = removeLint(D), hasLint(D,S).
clean(C,[washClothes(C,_)|S]).
clean(C,[A|S]) :- not A = wear(C), clean(C,S).
wet(C,[washClothes(C,_)|S]).
wet(C,[A|S]):- not A = dryClothes(C,_), wet(C,S). 
folded(C,[fold(C)|S]).
folded(C,[A|S]):- not A = wear(C), folded(C,S).


	/* ---------- Heuristics To Cut Search ------------- */
/* The predicate useless(A,ListOfPastActions) is true if an action A is useless
given the list of previously performed actions. The predicate useless(A,ListOfPastActions)
helps to solve the planning problem by providing declarative heuristics to 
the planner. If this predicate is correctly defined using a few rules, then it 
helps to speed-up the search that your program is doing to find a list of actions
that solves a planning problem. Write as many rules that define this predicate
as you can: think about useless repetitions you would like to avoid, and about 
order of execution (i.e., use common sense properties of the application domain). 
Your rules have to be general enough to be applicable to any problem in your domain,
in other words, they have to help in solving a planning problem for any instance
(i.e., any initial and goal states).
*/	
% write your rules implementing the predicate  useless(Action,History) here. %


:- [laundryInit].
/* This last line compiles also the file laundryInit.pl  that should be in same
   directory as this file. Do NOT insert this file here because it will be easier
   for you to test different initial and goal states if they are defined
   in a different file. Recall that the initial state is defined by a set of
   atomic statements about the values of the fluents wrt [] that represents 
   the initial situation in PROLOG. Recall also that the goal state is defined
   by rules with the predicate  goal_state(S)  in the head, and the body of 
   the rules should say what should be true or false in the goal state S.  
*/

