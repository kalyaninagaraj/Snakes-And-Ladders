
# <img src="https://raw.githack.com/FortAwesome/Font-Awesome/master/svgs/solid/dice.svg" card_color="#222222" width="50" height="50" style="vertical-align:bottom"/> Snakes And Ladders
The Julia code `snakes_and_ladders.jl` analyzes the single-player game of snakes and ladders as a discrete-time Markov chain with a single absorbing state, and calculates
1. the expected number of turns till the game finishes,
2. the probability that a player ever moves to a square `i` on the board, given that she started the game in square `j` (`i` and `j` can take on any integer value from 0 to 100),  
3. the least number of moves (or, turns) to complete the game,
4. the most likely path (or, sequence of board moves) to complete the game, and
5. the probability that a player completes the game in exactly `k` moves, where `k` can  equal 1, or 2, or 3, and so on. 

We assume that the game begins from a initial position (and not the first square on the board) that we call square 0. A player rolls a fair die before each move, and game is said to end when the player lands on the last square (or square 100). 

In keeping with tradition, a player on one of the squares 94 to 99 must roll a exact number to land on the last square, or remain in the same position if she overshoots 100. 

## Choice Of Board
1. Data for the [Milton Bradley version](https://en.wikipedia.org/wiki/File:Cnl03.jpg), is saved in `numberofsquares.txt`, `snakes.txt`, and `ladders.txt` under `Data`.
2. To play this [highly punitive version](https://www.etsy.com/listing/764625917/snakes-ladders-vintage-game-board-png), change the input files to `snakes_punitive.txt` and `ladders_punitive.txt`. 

## Example
Running `snakes_and_ladders.jl` for the punitive board will generate the following output. 

```
Mean number of moves to complete the game = 54.4735849242718.

The game can be completed in a minimum of 6.0 moves.
One such set of moves is [0, 6, 26, 32, 38, 77, 100].


The most likely path from square 0 to square 100 is [0, 6, 26, 32, 38, 77, 100].
This path requires 6 moves and is achieved with probility 2.1433470507544607e-5.
```
The random variable representing the number of moves to complete the game (starting from square 0) follows a discrete phase-type distribution, whose probability mass function and density are saved under `Plots`. 

## Code Credits
[@kalyaninagaraj](https://github.com/kalyaninagaraj/)

## Resources
### Lecture notes, videos, and book chapters:
1. Introduction to Probability Models, 11th Ed., Sheldon M. Ross, Section 4.6
2. Introduction to Probability, 2nd Ed., Charles M. Grinstead and J. Laurie Snell, Chapter 11 [[pdf](https://math.dartmouth.edu/~prob/prob/prob.pdf)]
3. Lecture on Expected Time to Absorption by John Tsitsiklis, RES.6-012 Introduction to Probability. Spring 2018. Massachusetts Institute of Technology: MIT OpenCourseWare  [[video](https://ocw.mit.edu/resources/res-6-012-introduction-to-probability-spring-2018/part-iii-random-processes/expected-time-to-absorption/)]
4. Lecture notes for Professor Bo Friis Nielsen's course on Stochastic Processes, DTU Compute, Denmark, Course 02407, Fall 2020 [[pdf](http://www2.imm.dtu.dk/courses/02407/lectnotes/ftf.pdf)] [[course homepage](http://www2.imm.dtu.dk/courses/02407/)]
