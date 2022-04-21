#lang forge

sig Candidate {
    votesReceived: one Int
}

one sig Election {
    candidates: set Candidate,
    winner: one Candidate,
    totalVotes: one Int -- number of votes in system (538 for America)
}

sig State {
    votes: one Int
}

pred init {
    #{all s: State | s.v} = Election.totalVotes
}


potential ideas:
have electors for each state(that do the actual voting for cand) or simplify
potentially see how multiple parties affects the electoral college(instead of the common two(2))

future:
set up simple constraints to have the correct winner(confirming they won majority electoral votes, only one winner, tiebreaks(?))
have each state keep dict of cand -> num votes which helps with visualization, adding other scenarios, etc.
add constraints to have scenarios where winner has popular vote v. doesn't(and others)
visualization!! 
