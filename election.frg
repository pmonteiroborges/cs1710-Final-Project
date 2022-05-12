#lang forge

sig Candidate {
    votesReceived: one Int
}

one sig Election {
    candidates: set Candidate,
    winner: lone Candidate, -- there may be no winner if no one gets a majority of the vote
    totalVotes: one Int -- number of votes in system (538 for America)
}

abstract sig State {
    votes: one Int,
    population: one Int, -- rounded, in hundreds of thousands
    chosenCandidate: one Candidate
}

one sig Alabama extends State {}
one sig Alaska extends State {}
one sig Arizona extends State {}
one sig Arkansas extends State {}
one sig California extends State {}
one sig Colorado extends State {}
one sig Connecticut extends State {}
one sig Delaware extends State {}
one sig Florida extends State {}
one sig Georgia extends State {}
one sig Hawaii extends State {}
one sig Idaho extends State {}
one sig Illinois extends State {}
one sig Indiana extends State {}
one sig Iowa extends State {}
one sig Kansas extends State {}
one sig Kentucky extends State {}
one sig Louisiana extends State {}
one sig Maine extends State {}
one sig Maryland extends State {}
one sig Massachusetts extends State {}
one sig Michigan extends State {}
one sig Minnesota extends State {}
one sig Mississippi extends State {}
one sig Missouri extends State {}
one sig Montana extends State {}
one sig Nebraska extends State {}
one sig Nevada extends State {}
one sig NewHampshire extends State {}
one sig NewJersey extends State {}
one sig NewMexico extends State {}
one sig NewYork extends State {}
one sig NorthCarolina extends State {}
one sig NorthDakota extends State {}
one sig Ohio extends State {}
one sig Oklahoma extends State {}
one sig Oregon extends State {}
one sig Pennsylvania extends State {}
one sig RhodeIsland extends State {}
one sig SouthCarolina extends State {}
one sig SouthDakota extends State {}
one sig Tennessee extends State {}
one sig Texas extends State {}
one sig Utah extends State {}
one sig Vermont extends State {}
one sig Virginia extends State {}
one sig Washington extends State {}
one sig WestVirginia extends State {}
one sig Wisconsin extends State {}
one sig Wyoming extends State {}
one sig DC extends State {} -- from the Electoral College's perspective, DC is a state

pred setUpStateVotes {
    -- based on 2020 state electoral votes (https://www.270towin.com)
    Alabama.votes = 9
    Alaska.votes = 3
    Arizona.votes = 11
    Arkansas.votes = 6
    California.votes = 54
    Colorado.votes = 10
    Connecticut.votes = 7
    Delaware.votes = 3
    Florida.votes = 30
    Georgia.votes = 16
    Hawaii.votes = 4
    Idaho.votes = 4
    Illinois.votes = 19
    Indiana.votes = 11
    Iowa.votes = 6
    Kansas.votes = 6
    Kentucky.votes = 8
    Louisiana.votes = 8
    Maine.votes = 4
    Maryland.votes = 10
    Massachusetts.votes = 11
    Michigan.votes = 15
    Minnesota.votes = 10
    Mississippi.votes = 6
    Missouri.votes = 10
    Montana.votes = 4
    Nebraska.votes = 5
    Nevada.votes = 6
    NewHampshire.votes = 4
    NewJersey.votes = 14
    NewMexico.votes = 5
    NewYork.votes = 28
    NorthCarolina.votes = 16
    NorthDakota.votes = 3
    Ohio.votes = 17
    Oklahoma.votes = 7
    Oregon.votes = 8
    Pennsylvania.votes = 19
    RhodeIsland.votes = 4
    SouthCarolina.votes = 9
    SouthDakota.votes = 3
    Tennessee.votes = 11
    Texas.votes = 40
    Utah.votes = 6
    Vermont.votes = 3
    Virginia.votes = 13
    Washington.votes = 12
    WestVirginia.votes = 4
    Wisconsin.votes = 10
    Wyoming.votes = 3
    DC.votes = 3
}

pred setUpStatePopulation {
    -- based on 2022 population (https://worldpopulationreview.com/states)
    Alabama.population = 45
    Alaska.population = 7
    Arizona.population = 76
    Arkansas.population = 30
    California.population = 400
    Colorado.population = 60
    Connecticut.population = 35
    Delaware.population = 10
    Florida.population = 221
    Georgia.population = 110
    Hawaii.population = 14
    Idaho.population = 19
    Illinois.population = 123
    Indiana.population = 68
    Iowa.population = 31
    Kansas.population = 29
    Kentucky.population = 45
    Louisiana.population = 46
    Maine.population = 14
    Maryland.population = 60
    Massachusetts.population = 70
    Michigan.population = 100
    Minnesota.population = 57
    Mississippi.population = 30
    Missouri.population = 62
    Montana.population = 11
    Nebraska.population = 20
    Nevada.population = 33
    NewHampshire.population = 14
    NewJersey.population = 89
    NewMexico.population = 21
    NewYork.population = 192
    NorthCarolina.population = 108
    NorthDakota.population = 8
    Ohio.population = 117
    Oklahoma.population = 40
    Oregon.population = 43
    Pennsylvania.population = 128
    RhodeIsland.population = 10
    SouthCarolina.population = 53
    SouthDakota.population = 9
    Tennessee.population = 70
    Texas.population = 301
    Utah.population = 34
    Vermont.population = 6
    Virginia.population = 86
    Washington.population = 79
    WestVirginia.population = 18
    Wisconsin.population = 59
    Wyoming.population = 6
    DC.population = 6
}

pred init {
    setUpStateVotes
    setUpStatePopulation
    Election.totalVotes = 538
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
}

pred findWinner {
    all c: Candidate | {
        -- a candidate wins if they get more than 270 votes
        c.votesReceived >= 270 implies Election.winner = c
    }

    all c: Candidate | {
        -- if no one gets a majority, then there is no winner
        c.votesReceived < 270 implies Election.winner != c
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

    // all s: State | {
    //     all c: Candidate | {
    //         (sum votes: s.candidateVotes[c] | votes) = s.votes
    //     }
    // }
}

pred traces {
    wellformed
    findWinner
    statesVotes
}

// test expect {
//     vacuity: {traces} for exactly 11 Int is sat
//     tieCanExist: {
//         traces
//         no Election.winner
//     } for exactly 11 Int is sat

//     winnerCanExist: {
//         traces
//         some Election.winner
//     } for exactly 11 Int is sat
// }

run {
    traces
} for exactly 11 Int, exactly 3 Candidate
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