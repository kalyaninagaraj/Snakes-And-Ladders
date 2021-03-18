"""
OBJECTIVE
=========
This code anayzes the single-player game of snakes and ladders as a
discrete-time Markov chain with a single absorbing state, and calculates
[1] the expected number of turns to complete a game,
[2] the probability that a player ever moves to cell j, given that she started
    in cell j,
[3] the least number of moves (turns) to complete the game,
[4] the most likely path (or, sequence of board moves) to complete the game, and
[5] the probability that a player completes the game in k moves, k = 1, 2, ...


CHOICE OF BOARD
===============
[1] https://en.wikipedia.org/wiki/File:Cnl03.jpg
Input files: numberofcells.tx, snakes.txt, ladders.txt

[2] https://www.etsy.com/listing/764625917/snakes-ladders-vintage-game-board-png
Input files: numberofcells.txt, snakes_vintage.txt, ladders_vintage.txt


RESOURCES
=========
Online forums:
[1] https://math.stackexchange.com/questions/691494/expected-number-of-steps-between-states-in-a-markov-chain
[2] https://www.quora.com/What-is-the-expected-number-of-moves-required-to-finish-a-snakes-and-ladders-game
[3] https://en.wikipedia.org/wiki/Discrete_phase-type_distribution
[4] https://math.stackexchange.com/questions/1695191/markov-chain-snakes-and-ladders
[5] https://stackoverflow.com/questions/38894477/find-the-path-with-the-max-likelihood-between-two-vertices-in-markov-model
[6] https://mathematica.stackexchange.com/questions/19457/finding-the-likeliest-path-in-a-markov-process
[7] https://math.stackexchange.com/questions/3281928/what-is-the-distribution-of-time-to-absorption-for-an-absorbing-markov-chain

Lecture notes, videos, and book chapters:
[8] https://ocw.mit.edu/resources/res-6-012-introduction-to-probability-spring-2018/part-iii-random-processes/expected-time-to-absorption/
[9] http://www2.imm.dtu.dk/courses/02407/lectnotes/ftf.pdf
[10] Introduction to Probability Models, 11th Ed., Sheldon M. Ross, Section 4.6
[11] Introductionto Probability, 2nd Ed., Charles M. Grinstead and
     J. Laurie Snell, Chapter 11
     https://math.dartmouth.edu/~prob/prob/prob.pdf


AUTHOR
======
Kalyani Nagaraj
September 18, 2019


KEYWORDS
========
Snakes and ladders, Markov chain, discrete phase-type distribution, Dijkstra's
shortest path algorithm
"""

# 1. INCLUDE PACKAGES
# -------------------
using LinearAlgebra, Graphs
using DelimitedFiles

# 2. READ BOARD GAME DATA FROM FILE, CREATE A DICTIONARY
# ------------------------------------------------------
num_cells = readdlm("Data/numberofcells.txt", Int64);
num_states = num_cells[1] + 1;
# First column of s  : locations of snake heads
# Second column of s : locations of snake tails
s = readdlm("Data/snakes_vintage.txt", Int64);
# First column of l  : location of bottom of ladder
# Second column of l : location of top of ladder
l = readdlm("Data/ladders_vintage.txt", Int64);
# Create a dictionary whose keys are path sources and whose corresponding
# values are path destination implied by the snakes and ladders
snakes  = [ [ s[i,1] s[i,2] ] for i in 1:size(s,1)]
ladders = [ [ l[i,1] l[i,2] ] for i in 1:size(l,1)]
dictJumps = Dict([la[1] => la[2] for la in ladders])
merge!(dictJumps, Dict([sn[1] => sn[2] for sn in snakes]))


# 3. GENERATE THE STATE TRANSITION MATRIX P USING BOARD GAME DATA
# ---------------------------------------------------------------
P = zeros(num_states, num_states)  # Initialize a 101 X 101 1-step transition
                                   # probability matrix
                                   # The game begins from cell 0
for k = 1:(num_states-1)-5   # Loops from 1 to 95
   for j = k+1:k+6           # Fill in the transition probs. for a fair die
      P[k,j] = 1/6
   end
end
for k = (num_states-1)-4:num_states    # Loops from 96 to 101
                                       # Player must roll an exact number to
                                       # reach cell 100
   for j = k+1:num_states
      P[k,j] = 1/6
   end
   P[k,k] = (k + 6 - num_states)/6  # If player overshoots cell 100, she remains
                                    # in cell k with probability (k+6-101)/6
end
# Now, adjust the transition matrix to account for jumps in position due snakes
# or ladders
for k in keys(dictJumps)
   P[:, dictJumps[k]+1] += P[:, k+1]
end
# Notice that P[i, j] = 0 if either cell i or cell j has a snake's head or the
# bottom of a ladder. So we can safely delete columns and rows corresponding to
# the start of "jumps", without affecting our analysis.
# This matrix truncation (naturally) reduces the size of the P,
# which in turn will make the matrix inversion operation go faster.
P = P[setdiff(collect(1:num_states), collect(keys(dictJumps)) .+ 1),
  setdiff(collect(1:num_states), collect(keys(dictJumps)) .+ 1)]



# 4. CALULATE THE EXPECTED NUMBER OF TURN TO COMPLETE THE GAME
# ------------------------------------------------------------
# P is a one-step transition matrix that corresponds to a discrete-time
# Markov chain with a single absorbing state.
# P = [T t;
#      0 1]
# Remove the last row and column to get the non-singular matrix T.
# The expected number of moves to complete the game (i.e., absorption times),
# when starting from cells 0 to 99 (minus the cells that were removed while
# truncating P), are given by E[Time] = inv(I - P) * vec(1).
T  = P[1:end-1, 1:end-1]
N  = size(T, 1)
IN = Matrix{Float64}(I, N, N)  # IN is the identity matrix of size N
M  = IN - T
S  = inv(M)  # Matrix of mean times s_ij the Markov chain is in state j given
             # that it starts in state i
A = S*ones(N) # Vector of mean absorption times a_i when starting in state i
println("Mean number of moves to complete the game = ", A[1], ".")


# 5. CALCULATE THE PROBABILITIES f_ij THAT THE MARKOV CHAIN EVER TRANSITIONS TO
# STATE j, GIVEN THAT ITS STARTS IN STATE i.
# -----------------------------------------------------------------------------
# f_ij = (s_ij - delta_ij) / s_jj,
# where delta_ij = 1 if i=j, 0 otherwise.
# Note that the matrix F is made up of probabilities only for the transient
# states.
F = (S .- IN) * diagm(0 => (1 ./ diag(S)))


# 6. FIND THE SMALLEST NUMBER OF MOVES TO COMPLETE THE GAME BY SOLVING A
# SHORTEST PATH PROBLEM (APPLY DIJKSTRA'S ALGORITHM)
# ----------------------------------------------------------------------
# 7. FIND THE MOST LIKELY PATH (AND THE LIKELIHOOD) TO COMPLETE THE GAME BY
# SOLVING ANOTHER SHORTEST PATH PROBLEM WITH EDGE WEIGHTS = -log(P[i, j])
# -------------------------------------------------------------------------
vnames = setdiff(collect(0:num_states-1), collect(keys(dictJumps))) # graph vertices
g = inclist(vnames, is_directed=true)
                            # Initialize a simple directed graph with vertex list
                            # `vnames` and no edges
                            # Note that vnames does not include the bottoms of
                            # ladders and the heads of snakes
AdjMat = Int.(sign.(P))     # Construct the adjacency matrix of graph g.
ne = sum(AdjMat)            # Count the number of edges from the adj. matrix.
dists = zeros(ne)           # Intialize each edge weight to 0.
k = 0
for i = 1:size(P,1)         # Loop to add an edge whenever trans. prob P_ij>0
   for j = 1:size(P,2)
      if P[i,j] > 0         # add edge from vnames[i] to vnames[j]
         add_edge!(g, vnames[i], vnames[j])
         global k = k + 1
         dists[k] = P[i,j] < 1 ? -log(P[i,j]) : 0.0
                                   # weight of the egde = - log(P_ij)
      end
   end
end
r1 = dijkstra_shortest_paths(g, 0) # Find smallest number of moves to go from
                                   # cell 0 to cells 0, 1, 2, ..., 100
                                   # All edge weights equal 1
r2 = dijkstra_shortest_paths(g, dists, 0) # Find the most likely path from
                                          # cell 0 to cells 0, 1, 2, ... 100
                                          # when edge weights = - log(P_ij)
# Enumerate the shortest paths from cell 0 to all other vertices:
enpath_1 = enumerate_paths(vertices(g), r1.parent_indices)
enpath_2 = enumerate_paths(vertices(g), r2.parent_indices)
# When all edge weights equal one:
println("\nThe game can be completed in a minimum of ", r1.dists[end], " moves.")
println("One such set of moves is ", enpath_1[end], ".\n")
# When edge weights equal negative log of one-step transition probabilities:
println("\nThe most likely path from cell 0 to cell ", num_states-1, " is ", enpath_2[end], ".")
println("This path requires ", length(enpath_2[end])-1,
        " moves and is achieved with probility ", exp(-r2.dists[end]), ".")


# 8. COMPUTE THE PMF AND CDF OF RANDOM VARIABLE N, TIME TO COMPLETE THE GAME
# --------------------------------------------------------------------------
# Define the initial distribution tau
tau = zeros(size(T,1)); tau[1] = 1;
T0 = P[1:end-1, end]
pmf_phasetypedist = zeros(300);
cdf_phasetypedist = zeros(300);
for n=1:300
    pmf_phasetypedist[n] = transpose(tau) * T^(n-1) * T0;
    cdf_phasetypedist[n] = 1 - transpose(tau) * T^n * ones(size(T,1))
end


using Plots
cdfplot = Plots.plot(0:300, [0;cdf_phasetypedist], linetype=:steppre, title = "Discrete Phase-Type Distribution", label = "", lw = 1)
xlabel!("Number of moves to complete game")
ylabel!("CDF")
display(cdfplot)

pmfplot = Plots.scatter(1:300, pmf_phasetypedist, title = "Discrete Phase-Type Distribution", label = "", lw = 1)
xlabel!("Number of moves to complete game")
ylabel!("PMF")
display(pmfplot)
