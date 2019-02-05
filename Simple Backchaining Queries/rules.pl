/* 500777986 Fahim Nadeem
 * 500760649 Sanval Sohail
 * 500761803 Jonathan cruz
 */
hasBall(r3).
pathClear(r1,goal).
pathClear(r2,r1).
pathClear(r3,r2).
pathClear(r3,goal).
pathClear(r3,r1).
canScore(R) :- hasBall(R),open(R).
canScore(R) :- canAssist(R1,R),open(R).
canAssist(R1,R2) :- hasBall(R1), pathClear(R1,R2).
canAssist(R1,R2) :- pathClear(R3,R2),canAssist(R1,R3).
open(R) :- pathClear(R,goal).


