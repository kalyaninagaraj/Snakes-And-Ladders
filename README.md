
# <img src="https://raw.githack.com/FortAwesome/Font-Awesome/master/svgs/solid/broadcast-tower.svg" card_color="#222222" width="50" height="50" style="vertical-align:bottom"/> Snakes And Ladders
Analyze the game of snakes and ladders as a discrete-time Markov chain with a single absorbing state.


## OBJECTIVE
This code anayzes the single-player game of snakes and ladders as a
discrete-time Markov chain with a single absorbing state, and calculates
[1] the expected number of turns to complete a game,
[2] the probability that a player ever moves to cell j, given that she started
    in cell j,
[3] the least number of moves (turns) to complete the game,
[4] the most likely path (or, sequence of board moves) to complete the game, and
[5] the probability that a player completes the game in k moves, k = 1, 2, ...

## CHOICE OF BOARD
[1] https://en.wikipedia.org/wiki/File:Cnl03.jpg
Input files: numberofcells.tx, snakes.txt, ladders.txt
[2] https://www.etsy.com/listing/764625917/snakes-ladders-vintage-game-board-png
Input files: numberofcells.txt, snakes_vintage.txt, ladders_vintage.txt

## RESOURCES
### Online forums
[1] https://math.stackexchange.com/questions/691494/expected-number-of-steps-between-states-in-a-markov-chain
[2] https://www.quora.com/What-is-the-expected-number-of-moves-required-to-finish-a-snakes-and-ladders-game
[3] https://en.wikipedia.org/wiki/Discrete_phase-type_distribution
[4] https://math.stackexchange.com/questions/1695191/markov-chain-snakes-and-ladders
[5] https://stackoverflow.com/questions/38894477/find-the-path-with-the-max-likelihood-between-two-vertices-in-markov-model
[6] https://mathematica.stackexchange.com/questions/19457/finding-the-likeliest-path-in-a-markov-process
[7] https://math.stackexchange.com/questions/3281928/what-is-the-distribution-of-time-to-absorption-for-an-absorbing-markov-chain

### Lecture notes, videos, and book chapters:
[1] https://ocw.mit.edu/resources/res-6-012-introduction-to-probability-spring-2018/part-iii-random-processes/expected-time-to-absorption/
[2] http://www2.imm.dtu.dk/courses/02407/lectnotes/ftf.pdf
[3] Introduction to Probability Models, 11th Ed., Sheldon M. Ross, Section 4.6
[4] Introductionto Probability, 2nd Ed., Charles M. Grinstead and J. Laurie Snell, Chapter 11
    https://math.dartmouth.edu/~prob/prob/prob.pdf
