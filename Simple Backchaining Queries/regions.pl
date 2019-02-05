/*
 *	500777986 Fahim Nadeem
 *	500760649 Sanval Sohail
 *	500761803 Jonathan cruz
 */

/*	                  Q2                  */

% Note that in the figure there are no isolated regions,
% i.e., every region is connected to at least one other region.

connected(r1,r1). connected(r2,r2). connected(r3,r3).
connected(r4,r4). connected(r5,r5). connected(r6,r6).
connected(r7,r7). connected(r8,r8). connected(r9,r9).
connected(r10,r10). 
connected(r14,r14). connected(r24,r24). connected(r34,r34).

/* 
We need a few additional regions to characterize geometric relations 
between those regions which are explicitly named on the figure
*/ 
/* r1left is the left edge of r1 */
connected(r1left,r1left).
/* r14bot is the bottom edge of r14 */
connected(r14bot,r14bot). 
/* r14right is the right edge of r14 */
connected(r14right,r14right). 
/* r14bl is the bottom-left corner of r14 */
connected(r14bl,r14bl). 
/* r14ur is the upper-right corner of r14 */
connected(r14ur,r14ur). 


/* r2bt is the bottom edge of r2 */
connected(r2bt,r2bt). 

/* r24mid is the middle point of r24 */
connected(r24mid,r24mid). 

/* r3right is the right-most edge of r3 */
connected(r3right,r3right).
/* r34bot is the bottom edge of r34 */
connected(r34bot,r34bot). 
/* r34left is the left edge of r34 */
connected(r34left,r34left). 
/* r34br is the bottom-right corner of r34 */
connected(r34br,r34br). 
/* r34ul is the upper-left corner of r34 */
connected(r34ul,r34ul). 

/* r6mid is the line across of r6 from left to right: this line touches r5 */
connected(r6mid,r6mid).
/* r6midX is the intersection point of r6mid with the right edge of r6 */
connected(r6midX,r6midX).
/* r7bottom is a region on the bottom of r7 */
connected(r7bottom,r7bottom).
/* r8bord is a region on the border of r8 and disconnected from r7 */
connected(r8bord,r8bord).
/* r10up is an upper part of r10 */
connected(r10up,r10up).

/* pairwise connections between regions */
connected(r1,r1left).  connected(r1left,r1).
connected(r1,r4). connected(r4,r1).
connected(r1,r14). connected(r14,r1). connected(r4,r14). connected(r14,r4). 

connected(r1,r14bot).  connected(r14bot,r1).
connected(r4,r14bot).  connected(r14bot,r4).
connected(r14,r14bot).  connected(r14bot,r14).

connected(r1,r14right).  connected(r14right,r1).
connected(r4,r14right).  connected(r14right,r4).
connected(r14,r14right).  connected(r14right,r14).

connected(r14right,r14bot). connected(r14bot,r14right). 

connected(r1,r14bl).  connected(r14bl,r1).
connected(r4,r14bl).  connected(r14bl,r4).
connected(r14,r14bl).  connected(r14bl,r14).
connected(r14bot,r14bl). connected(r14bl,r14bot).  
connected(r1,r14ur).  connected(r14ur,r1).
connected(r4,r14ur).  connected(r14ur,r4).
connected(r14,r14ur).  connected(r14ur,r14).
connected(r14right,r14ur). connected(r14ur,r14right).
 


connected(r2,r4). connected(r4,r2).
connected(r24,r2). connected(r2,r24).
connected(r24,r4). connected(r4,r24).
connected(r2bt,r2). connected(r2,r2bt).
connected(r24mid,r2). connected(r2,r24mid). 
connected(r24,r24mid). connected(r24mid,r24). 
connected(r24mid,r4). connected(r4,r24mid). 

connected(r3,r3right). connected(r3right,r3).
connected(r3,r4). connected(r4,r3).
connected(r3,r34). connected(r34,r3). connected(r4,r34). connected(r34,r4). 

connected(r3,r34bot). connected(r34bot,r3).
connected(r4,r34bot). connected(r34bot,r4).
connected(r34,r34bot). connected(r34bot,r34).

connected(r3,r34left). connected(r34left,r3).
connected(r4,r34left). connected(r34left,r4).
connected(r34,r34left). connected(r34left,r34).

connected(r34bot,r34left). connected(r34left,r34bot).

connected(r3,r34br). connected(r34br,r3).
connected(r4,r34br). connected(r34br,r4).
connected(r34,r34br). connected(r34br,r34).
connected(r34bot,r34br). connected(r34br,r34bot). 
connected(r3,r34ul). connected(r34ul,r3).
connected(r4,r34ul). connected(r34ul,r4).
connected(r34,r34ul). connected(r34ul,r34).
connected(r34left,r34ul). connected(r34ul,r34left). 



connected(r7,r8). connected(r8,r7).
connected(r7,r7bottom). connected(r7bottom,r7).
connected(r8,r7bottom). connected(r7bottom,r8).
connected(r8,r8bord). connected(r8bord,r8).
connected(r5,r6). connected(r6,r5).
connected(r5,r9). connected(r9,r5). connected(r6,r9). connected(r9,r6).
connected(r6,r6mid). connected(r6mid,r6).
connected(r5,r6mid). connected(r6mid,r5).
connected(r6midX,r6). connected(r6,r6midX).
connected(r6midX,r6mid). connected(r6mid,r6midX).

connected(r10,r6). connected(r6,r10).
connected(r10up,r10). connected(r10,r10up).

dc(X,Y) :- not connected(X,Y).

related(X,Y) :- connected(X,Y).
related(X,Y) :- connected(X,Z), connected(Z,Y).

partOf(X,Y) :- not (connected(Z,X), not connected(Z,Y)).

overlaps(X,Y) :- connected(X,Z), connected(Y,Z), test(X,Y,Z).
test(X,Y,Z) :- partOf(Z,X), partOf(Z,Y).

touch(X,Y):- connected(X,Y), not overlaps(X,Y).

tangentPartOf(X,Y) :- partOf(X,Y), overlaps(X,Y).

inside(X,Y) :- overlaps(X,Y), not touch(X,Y).
