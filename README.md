
# <img src="https://raw.githack.com/FortAwesome/Font-Awesome/master/svgs/solid/dice.svg" card_color="#222222" width="50" height="50" style="vertical-align:bottom"/> Snakes And Ladders
Julia code to analyze the single-player game of snakes and ladders as a
discrete-time Markov chain with a single absorbing state, and calculate
1. the expected number of turns to complete a game,
2. the probability that a player ever moves to cell j, given that she started
    in cell j,
3. the least number of moves (turns) to complete the game,
4. the most likely path (or, sequence of board moves) to complete the game, and
5. the probability that a player completes the game in k moves, k = 1, 2, 3, ...

We will assume that the game begins from a initial position (and not position 1 on the board) that we shall call *cell 0*. The player rolls a fair die before each move, and game is said to end when the player lands on *cell 100*. 

## Choice Of Board
1. For the [Milton Bradley version](https://en.wikipedia.org/wiki/File:Cnl03.jpg), use data files `numberofcells.txt`, `snakes.txt`, and `ladders.txt`.
2. Data for a [highly punitive version](https://www.etsy.com/listing/764625917/snakes-ladders-vintage-game-board-png) is saved to `numberofcells.txt`, `snakes_punitive.txt`, and `ladders_punitive.txt`. 

## Example
Running `snakes_and_ladders.jl` for the punitive board will generate the following output

```
Mean number of moves to complete the game = 54.4735849242718.

The game can be completed in a minimum of 6.0 moves.
One such set of moves is [0, 6, 26, 32, 38, 77, 100].


The most likely path from cell 0 to cell 100 is [0, 6, 26, 32, 38, 77, 100].
This path requires 6 moves and is achieved with probility 2.1433470507544607e-5.
```
Time to complete the game follows a discrete phase-type distribution, whose mass function and density are plotted 
## Online (mostly) resources
### Lecture notes, videos, and book chapters:
1. Introduction to Probability Models, 11th Ed., Sheldon M. Ross, Section 4.6
2. Introductionto Probability, 2nd Ed., Charles M. Grinstead and J. Laurie Snell, Chapter 11
    https://math.dartmouth.edu/~prob/prob/prob.pdf
3. https://ocw.mit.edu/resources/res-6-012-introduction-to-probability-spring-2018/part-iii-random-processes/expected-time-to-absorption/
4. http://www2.imm.dtu.dk/courses/02407/lectnotes/ftf.pdf

### Online forums
1. https://math.stackexchange.com/questions/691494/expected-number-of-steps-between-states-in-a-markov-chain
2. https://www.quora.com/What-is-the-expected-number-of-moves-required-to-finish-a-snakes-and-ladders-game
3. https://en.wikipedia.org/wiki/Discrete_phase-type_distribution
4. https://math.stackexchange.com/questions/1695191/markov-chain-snakes-and-ladders
5. https://stackoverflow.com/questions/38894477/find-the-path-with-the-max-likelihood-between-two-vertices-in-markov-model
6. https://mathematica.stackexchange.com/questions/19457/finding-the-likeliest-path-in-a-markov-process
7. https://math.stackexchange.com/questions/3281928/what-is-the-distribution-of-time-to-absorption-for-an-absorbing-markov-chain
