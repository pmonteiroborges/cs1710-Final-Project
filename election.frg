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