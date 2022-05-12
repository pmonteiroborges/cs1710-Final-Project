#lang forge

sig Candidate {
    votesReceived: one Int,
    popularVotesReceived: one Int
}

one sig CandidateOne extends Candidate {
}

one sig CandidateTwo extends Candidate {
}

one sig Election {
    candidates: set Candidate,
    winner: lone Candidate, -- there may be no winner if no one gets a majority of the vote
    totalVotes: one Int -- number of votes in system (538 for America)
}

abstract sig State {
    votes: one Int, -- number of electoral votes
    population: one Int, -- rounded down, in hundreds of thousands
    candOneVotes: one Int,
    candTwoVotes: one Int,
    chosenCandidate: one Candidate
    // candVotes: func Candidate -> Int -- maps candidates to how many votes they received.
}

// one sig Alabama extends State {}
// one sig Alaska extends State {}
// one sig Arizona extends State {}
// one sig Arkansas extends State {}
// one sig California extends State {}
// one sig Colorado extends State {}
one sig Connecticut extends State {}
one sig Delaware extends State {}
// one sig Florida extends State {}
one sig Georgia extends State {}
// one sig Hawaii extends State {}
// one sig Idaho extends State {}
// one sig Illinois extends State {}
// one sig Indiana extends State {}
// one sig Iowa extends State {}
// one sig Kansas extends State {}
// one sig Kentucky extends State {}
// one sig Louisiana extends State {}
// one sig Maine extends State {}
one sig Maryland extends State {}
one sig Massachusetts extends State {}
// one sig Michigan extends State {}
// one sig Minnesota extends State {}
// one sig Mississippi extends State {}
// one sig Missouri extends State {}
// one sig Montana extends State {}
// one sig Nebraska extends State {}
//one sig Nevada extends State {}
one sig NewHampshire extends State {}
one sig NewJersey extends State {}
// one sig NewMexico extends State {}
one sig NewYork extends State {}
one sig NorthCarolina extends State {}
// one sig NorthDakota extends State {}
// one sig Ohio extends State {}
// one sig Oklahoma extends State {}
// one sig Oregon extends State {}
one sig Pennsylvania extends State {}
one sig RhodeIsland extends State {}
one sig SouthCarolina extends State {}
// one sig SouthDakota extends State {}
// one sig Tennessee extends State {}
// one sig Texas extends State {}
// one sig Utah extends State {}
// one sig Vermont extends State {}
one sig Virginia extends State {}
// one sig Washington extends State {}
// one sig WestVirginia extends State {}
// one sig Wisconsin extends State {}
// one sig Wyoming extends State {}
// one sig DC extends State {} -- from the Electoral College's perspective, DC is a state

pred setUpStateVotes {
    -- based on 2020 state electoral votes (https://www.270towin.com)
    // Alabama.votes = 9
    // Alaska.votes = 3
    // Arizona.votes = 11
    // Arkansas.votes = 6
    // California.votes = 54
    // Colorado.votes = 10
    Connecticut.votes = 7
    Delaware.votes = 3
    // Florida.votes = 30
    Georgia.votes = 16
    // Hawaii.votes = 4
    // Idaho.votes = 4
    // Illinois.votes = 19
    // Indiana.votes = 11
    // Iowa.votes = 6
    // Kansas.votes = 6
    // Kentucky.votes = 8
    // Louisiana.votes = 8
    // Maine.votes = 4
    Maryland.votes = 10
    Massachusetts.votes = 11
    // Michigan.votes = 15
    // Minnesota.votes = 10
    // Mississippi.votes = 6
    // Missouri.votes = 10
    // Montana.votes = 4
    // Nebraska.votes = 5
    // Nevada.votes = 6
    NewHampshire.votes = 4
    NewJersey.votes = 14
    // NewMexico.votes = 5
    NewYork.votes = 28
    NorthCarolina.votes = 16
    // NorthDakota.votes = 3
    // Ohio.votes = 17
    // Oklahoma.votes = 7
    // Oregon.votes = 8
    Pennsylvania.votes = 19
    RhodeIsland.votes = 4
    SouthCarolina.votes = 9
    // SouthDakota.votes = 3
    // Tennessee.votes = 11
    // Texas.votes = 40
    // Utah.votes = 6
    //Vermont.votes = 3
    Virginia.votes = 13
    // Washington.votes = 12
    // WestVirginia.votes = 4
    // Wisconsin.votes = 10
    // Wyoming.votes = 3
    // DC.votes = 3
}


pred setUpStatePopulation {
    -- based on 2022 population (https://worldpopulationreview.com/states)
    -- we divided actual populations by 4 for efficiency
    // Alabama.population = 11
    // Alaska.population = 2
    // Arizona.population = 19
    // Arkansas.population = 8
    // California.population = 100
    // Colorado.population = 15
    Connecticut.population = 9
    Delaware.population = 3
    // Florida.population = 55
    Georgia.population = 28
    // Hawaii.population = 4
    // Idaho.population = 4
    // Illinois.population = 31
    // Indiana.population = 17
    // Iowa.population = 8
    // Kansas.population = 7
    // Kentucky.population = 11
    // Louisiana.population = 12
    // Maine.population = 4
    Maryland.population = 15
    Massachusetts.population = 18
    // Michigan.population = 25
    // Minnesota.population = 14
    // Mississippi.population = 8
    // Missouri.population = 16
    // Montana.population = 3
    // Nebraska.population = 5
    // Nevada.population = 8
    NewHampshire.population = 4
    NewJersey.population = 22
    // NewMexico.population = 5
    NewYork.population = 48
    NorthCarolina.population = 27
    // NorthDakota.population = 2
    // Ohio.population = 29
    // Oklahoma.population = 10
    // Oregon.population = 11
    Pennsylvania.population = 32
    RhodeIsland.population = 3
    SouthCarolina.population = 13
    // SouthDakota.population = 2
    // Tennessee.population = 18
    // Texas.population = 75
    // Utah.population = 9
    // Vermont.population = 1
    Virginia.population = 22
    // Washington.population = 20
    // WestVirginia.population = 5
    // Wisconsin.population = 15
    // Wyoming.population = 2
    // DC.population = 2
}

pred init {
    setUpStateVotes
    setUpStatePopulation
    -- the sum of the states' votes should equal the election votes
    (sum s: State | s.votes) = Election.totalVotes
}

pred wellformed {
    init
    all c: Candidate | {
        -- every candidate should be running in the election
        c in Election.candidates

        -- candidates can only get up to the total number of votes in the election
        c.votesReceived >= 0
        c.votesReceived <= Election.totalVotes
    }

    -- the sum of the number of votes each candidate gets should be the total number of votes in the election
    (sum c: Candidate | c.votesReceived) = Election.totalVotes

     -- sum of states votes for can done should be = to received
    
    (sum s: State | s.candOneVotes) = CandidateOne.popularVotesReceived
    (sum s: State | s.candTwoVotes) = CandidateTwo.popularVotesReceived

    all s: State {
        s.candOneVotes >= 0 
        s.candOneVotes <= s.population
        s.candTwoVotes >= 0 
        s.candTwoVotes <= s.population
        add[s.candOneVotes, s.candTwoVotes] = s.population

        // make sure that whoever is more votes is chosen candidate.
        s.candOneVotes > s.candTwoVotes => s.chosenCandidate = CandidateOne
        s.candTwoVotes > s.candOneVotes => s.chosenCandidate = CandidateTwo
    }
}

pred findWinner {
    all c: Candidate | {
        -- a candidate wins if they get more than 270 votes
        c.votesReceived >= add[divide[Election.totalVotes, 2], 1] implies Election.winner = c
    }

    all c: Candidate | {
        -- if no one gets a majority, then there is no winner
        c.votesReceived < add[divide[Election.totalVotes, 2], 1] implies Election.winner != c
    } 
}

/** 
noWinner + allSameVotes 
model different scenarios of potential election results.
*/
pred noWinner {
    all c: Candidate | {
        c.votesReceived < add[divide[Election.totalVotes, 2], 1]
    }
}

pred allSameVotes {
    all disj c1, c2: Candidate | {
        c1.votesReceived = c2.votesReceived
    }
}

pred statesVotes {
    all c: Candidate | {
        let statesThatVotedForCandidate = (State - {s: State | s.chosenCandidate != c}) | {
            -- the number of votes a candidate gets should be equal to the sum
            -- of the votes of states that voted for them
            (sum s: statesThatVotedForCandidate | s.votes) = c.votesReceived
        }
    }
}

pred canWinWithoutPopularVote {
    some c: Candidate | {
        -- there is a candidate that won the election
        Election.winner = c

        some otherCand: Candidate | {
            -- some other candidate received more popular votes than the winner
            c != otherCand
            c.popularVotesReceived < otherCand.popularVotesReceived
        }
    }
}

pred traces {
    wellformed
    findWinner
    statesVotes
}

// test expect {
//     vacuity: {traces} for exactly 11 Int, exactly 2 Candidate is sat
//     oneCandidate: {
//         traces
//         #{c: Candidate | c in Election.candidates} = 1
//     }
// }

run {
    traces
    canWinWithoutPopularVote
} for exactly 9 Int, exactly 2 Candidate

/*
potential ideas:
have electors for each state(that do the actual voting for cand) or simplify
potentially see how multiple parties affects the electoral college(instead of the common two(2))
future:
set up simple constraints to have the correct winner(confirming they won majority electoral votes, only one winner, tiebreaks(?))
have each state keep dict of cand -> num votes which helps with visualization, adding other scenarios, etc.
add constraints to have scenarios where winner has popular vote v. doesn't(and others)
visualization!! 
*/