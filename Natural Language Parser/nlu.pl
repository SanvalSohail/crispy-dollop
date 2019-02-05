/******************* database **********************/
hasBook(indigo, levesque, thinking_as_computation, 75).
hasBook(indigo, norvig, artificial_intelligence, 75).
hasBook(indigo, rowling, harry_potter, 30).
hasBook(indigo, golding, lord_of_the_flies, 120).
hasBook(indigo, golding, lord_of_the_flies_2, 120).
hasBook(amazon, rowling, harry_potter, 60).
hasBook(amazon, norvig, artificial_intelligence, 75).
hasBook(amazon, levesque, thinking_as_computation, 75).
hasBook(amazon, poole, computational_intelligence, 60).
hasBook(chapters, rowling, harry_potter_2, 10).
hasBook(chapters, sanval, guide_to_success, 200).
hasBook(chapters, cruz, smalltalk_is_the_best, 2).
hasBook(chapters, nikolas, book_2_the_bookening, 2).
shipping(indigo, ottawa, 9).
shipping(indigo, toronto, 7).
shipping(indigo, new_york, 3).
shipping(indigo, vancouver, 15).
shipping(amazon, ottawa, 7).
shipping(amazon, toronto, 1).
shipping(amazon, vancouver, 12).
shipping(amazon, new_york, 9).
shipping(amazon, markham, 2).
shipping(chapters, toronto, 2).
shipping(chapters, ottawa, 7).
lives(sanval, milton).
lives(cruz, markham).
lives(nikolas, toronto).
lives(levesque, new_york).
lives(golding, new_york).
lives(norvig , vancouver).
lives(poole, mississauga).
lives(rowling, ottawa).
lives(zork, andromeda).
lives(blork, messier_81).
lives(chiss, milky_way).
price(thinking_as_computation, medium).
price(artificial_intelligence, medium).
price(harry_potter, low).
price(lord_of_the_flies, high).
price(lord_of_the_flies_2, high).
price(harry_potter_2, low).
price(guide_to_success, high).
price(smalltalk_is_the_best, low).
price(book_2_the_bookening, low).
price(ottawa, high).
price(toronto, low).
price(new_york, medium).
price(vancouver, high).
price(markham, low).
a(X,Y):- hasBook(X,_,Y,_). 
an(X, Y):- hasBook(X,_,Y,_).
an(X, Y):- hasBook(_,_,X,Y).
a(X,Y):- hasBook(_,_,X,Y). 
a(X,Y):- shipping(X,Y,_). 
/******************* lexicon **********************/
article(a).
article(an).
common_noun(city,X) :- shipping(_Bookstore,X,_Price).
common_noun(person,X) :- lives(X,City).
common_noun(author,X) :- hasBook(_Bookstore,X,_Title,_Price).
common_noun(bookstore,X) :- hasBook(X,_Author,_Title,_Price).
common_noun(book,X) :- hasBook(_Bookstore,_Author,X,_Price).
common_noun(title,X) :- hasBook(_Bookstore,_Author,X,_Price).
common_noun(shipping,X) :- shipping(_Bookstore,_City,X).
common_noun(price,X) :- hasBook(_Bookstore,_Author,_Title,X).
adjective(cheap,X) :- price(X,low).
adjective(expensive,X) :- price(X,high).
adjective(low,X) :- price(X,low).
adjective(high,X) :- price(X,high).
adjective(moderate,X) :- price(X,medium).
preposition(with,X,Y) :- a(X,Y).
preposition(with,X,Y) :- an(X,Y).
preposition(of,X,Y):- hasBook(_,X,Y,_).
preposition(of,X,Y):- hasBook(_,_,Y,X).
preposition(for,X,Y) :- hasBook(_,_,X,Y).
preposition(from,X,Y) :- hasBook(Y,_,X,_).
preposition(from,X,Y) :- shipping(X,Y,_).
preposition(from,X,Y) :- lives(X,Y).
preposition(to,X,Y) :-  shipping(X,Y,_).
preposition(by,X,Y) :- hasBook(_,Y,X,_).
preposition(at,X,Y) :- hasBook(Y,X,_,_).
preposition(at,X,Y) :- hasBook(_,X,Y,_).
preposition(at,X,Y) :- hasBook(Y,_,X,_).
proper_noun(toronto).
proper_noun(new_york).
proper_noun(markham).
proper_noun(milton).
proper_noun(ottawa).
proper_noun(messier_81).
proper_noun(andromeda).
proper_noun(milky_way).
proper_noun(vancouver).
proper_noun(toronto).
proper_noun(montreal).
proper_noun(poole).
proper_noun(levesque).
proper_noun(norvig).
proper_noun(golding).
proper_noun(harry_potter).
proper_noun(guide_to_success).
proper_noun(smalltalk_is_the_best).
proper_noun(book_2_the_bookening).
proper_noun(thinking_as_computation).
proper_noun(artificial_intelligence).
proper_noun(computational_intelligence).
proper_noun(lord_of_the_flies).
proper_noun(lord_of_the_flies_2).
proper_noun(amazon).
proper_noun(indigo).
proper_noun(chapters).
/******************* parser **********************/

who(Words, Ref) :- np(Words, Ref).

/* checks for something that is not a reference which is not a person */
what(Words, Ref) :- np(Words, Ref).

/* Noun phrase can be a proper name or can start with an article */

np([Name],Name) :- proper_noun(Name).
np([Art|Rest], Who) :- article(Art), np2(Rest, Who).


/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

np2([Adj|Rest],Who) :- adjective(Adj,Who), np2(Rest, Who).
np2([Noun|Rest], Who) :- common_noun(Noun, Who), mods(Rest,Who).


/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, Who) :-
	appendLists(Start, End, Words),
	prepPhrase(Start, Who),	mods(End, Who).

prepPhrase([Prep|Rest], Who) :-
	preposition(Prep, Who, Ref), np(Rest, Ref).

appendLists([], L, L).
appendLists([H|L1], L2, [H|L3]) :-  appendLists(L1, L2, L3).
