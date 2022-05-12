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
    //Election.totalVotes = 538
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

     -- sum of states votes for candone should be = to received
    
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
        c.votesReceived >= 270 implies Election.winner = c
    }

    all c: Candidate | {
        -- if no one gets a majority, then there is no winner
        c.votesReceived < 270 implies Election.winner != c
    } 
}

/** 
noWinner + allSameVotes 
model different scenarios of potential election results.
*/
pred noWinner {
    all c: Candidate | {
        c.votesReceived < 270
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

// pred canWinWithoutPopularVote {
//     some c: Candidate | {
//         -- there is a candidate that won the election
//         Election.winner = c

//         some otherCand: Candidate | {
//             -- some other candidate received more popular votes than the winner
//             c != otherCand
//             c.popularVotesReceived < otherCand.popularVotesReceived
//         }
//     }
// }

pred traces {
    wellformed
    //findWinner
    statesVotes
}

// test expect {
//     vacuity: {traces} for exactly 11 Int, exactly 2 Candidate is sat
//     oneCandidate: {
//         traces
//         #{c: Candidate | c in Election.candidates} = 1

//     }
// }

// inst partial {
//     Election = `Election0
//     totalVotes in Election -> (
//         0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 +
//         10 + 11 + 12 + 13 + 14 + 15 + 16 + 17 + 18 + 19 +
//         20 + 21 + 22 + 23 + 24 + 25 + 26 + 27 + 28 + 29 +
//         30 + 31 + 32 + 33 + 34 + 35 + 36 + 37 + 38 + 39 +
//         40 + 41 + 42 + 43 + 44 + 45 + 46 + 47 + 48 + 49 +
//         50 + 51 + 52 + 53 + 54 + 55 + 56 + 57 + 58 + 59 +
//         60 + 61 + 62 + 63 + 64 + 65 + 66 + 67 + 68 + 69 +
//         70 + 71 + 72 + 73 + 74 + 75 + 76 + 77 + 78 + 79 +
//         80 + 81 + 82 + 83 + 84 + 85 + 86 + 87 + 88 + 89 +
//         90 + 91 + 92 + 93 + 94 + 95 + 96 + 97 + 98 + 99 +
//         100 + 101 + 102 + 103 + 104 + 105 + 106 + 107 + 108 + 109 +
//         110 + 111 + 112 + 113 + 114 + 115 + 116 + 117 + 118 + 119 +
//         120 + 121 + 122 + 123 + 124 + 125 + 126 + 127 + 128 + 129 +
//         130 + 131 + 132 + 133 + 134 + 135 + 136 + 137 + 138 + 139 +
//         140 + 141 + 142 + 143 + 144 + 145 + 146 + 147 + 148 + 149 +
//         150 + 151 + 152 + 153 + 154 + 155 + 156 + 157 + 158 + 159 +
//         160 + 161 + 162 + 163 + 164 + 165 + 166 + 167 + 168 + 169 +
//         170 + 171 + 172 + 173 + 174 + 175 + 176 + 177 + 178 + 179 +
//         180 + 181 + 182 + 183 + 184 + 185 + 186 + 187 + 188 + 189 +
//         190 + 191 + 192 + 193 + 194 + 195 + 196 + 197 + 198 + 199 +
//         200 + 201 + 202 + 203 + 204 + 205 + 206 + 207 + 208 + 209 +
//         210 + 211 + 212 + 213 + 214 + 215 + 216 + 217 + 218 + 219 +
//         220 + 221 + 222 + 223 + 224 + 225 + 226 + 227 + 228 + 229 +
//         230 + 231 + 232 + 233 + 234 + 235 + 236 + 237 + 238 + 239 +
//         240 + 241 + 242 + 243 + 244 + 245 + 246 + 247 + 248 + 249 +
//         250 + 251 + 252 + 253 + 254 + 255 + 256 + 257 + 258 + 259 +
//         260 + 261 + 262 + 263 + 264 + 265 + 266 + 267 + 268 + 269 +
//         270 + 271 + 272 + 273 + 274 + 275 + 276 + 277 + 278 + 279 +
//         280 + 281 + 282 + 283 + 284 + 285 + 286 + 287 + 288 + 289 +
//         290 + 291 + 292 + 293 + 294 + 295 + 296 + 297 + 298 + 299 +   
//         300 + 301 + 302 + 303 + 304 + 305 + 306 + 307 + 308 + 309 +
//         310 + 311 + 312 + 313 + 314 + 315 + 316 + 317 + 318 + 319 +
//         320 + 321 + 322 + 323 + 324 + 325 + 326 + 327 + 328 + 329 +
//         330 + 331 + 332 + 333 + 334 + 335 + 336 + 337 + 338 + 339 +
//         340 + 341 + 342 + 343 + 344 + 345 + 346 + 347 + 348 + 349 +
//         350 + 351 + 352 + 353 + 354 + 355 + 356 + 357 + 358 + 359 +
//         360 + 361 + 362 + 363 + 364 + 365 + 366 + 367 + 368 + 369 +
//         370 + 371 + 372 + 373 + 374 + 375 + 376 + 377 + 378 + 379 +
//         380 + 381 + 382 + 383 + 384 + 385 + 386 + 387 + 388 + 389 +
//         390 + 391 + 392 + 393 + 394 + 395 + 396 + 397 + 398 + 399 +
//         400 + 401 + 402 + 403 + 404 + 405 + 406 + 407 + 408 + 409 +
//         410 + 411 + 412 + 413 + 414 + 415 + 416 + 417 + 418 + 419 +
//         420 + 421 + 422 + 423 + 424 + 425 + 426 + 427 + 428 + 429 +
//         430 + 431 + 432 + 433 + 434 + 435 + 436 + 437 + 438 + 439 +
//         440 + 441 + 442 + 443 + 444 + 445 + 446 + 447 + 448 + 449 +
//         450 + 451 + 452 + 453 + 454 + 455 + 456 + 457 + 458 + 459 +
//         460 + 461 + 462 + 463 + 464 + 465 + 466 + 467 + 468 + 469 +
//         470 + 471 + 472 + 473 + 474 + 475 + 476 + 477 + 478 + 479 +
//         480 + 481 + 482 + 483 + 484 + 485 + 486 + 487 + 488 + 489 +
//         490 + 491 + 492 + 493 + 494 + 495 + 496 + 497 + 498 + 499 +
//         490 + 491 + 492 + 493 + 494 + 495 + 496 + 497 + 498 + 499 +
//         500 + 501 + 502 + 503 + 504 + 505 + 506 + 507 + 508 + 509 +
//         510 + 511 + 512 + 513 + 514 + 515 + 516 + 517 + 518 + 519 +
//         520 + 521 + 522 + 523 + 524 + 525 + 526 + 527 + 528 + 529 +
//         530 + 531 + 532 + 533 + 534 + 535 + 536 + 537 + 538)

//         Candidate = `Candidate0 + `Candidate1
//         Alabama = `Alabama0
//         Alaska = `Alaska0
//         Arizona = `Arizona0
//         Arkansas = `Arkansas0
//         California = `California0
//         Colorado = `Colorado0
//         Connecticut = `Connecticut0
//         Delaware = `Delaware0
//         Florida = `Florida0
//         Georgia = `Georgia0
//         Hawaii = `Hawaii0
//         Idaho = `Idaho0
//         Illinois = `Illinois0
//         Indiana = `Indiana0
//         Iowa = `Iowa0
//         Kansas = `Kansas0
//         Kentucky = `Kentucky0
//         Louisiana = `Louisiana0
//         Maine = `Maine0
//         Maryland = `Maryland0
//         Massachusetts = `Massachusetts0
//         Michigan = `Michigan0
//         Minnesota = `Minnesota0
//         Mississippi = `Mississippi0
//         Missouri = `Missouri0
//         Montana = `Montana0
//         Nebraska = `Nebraska0
//         Nevada = `Nevada0
//         NewHampshire = `NewHampshire0
//         NewJersey = `NewJersey0
//         NewMexico = `NewMexico0
//         NewYork = `NewYork0
//         NorthCarolina = `NorthCarolina0
//         NorthDakota = `NorthDakota0
//         Ohio = `Ohio0
//         Oklahoma = `Oklahoma0
//         Oregon = `Oregon0
//         Pennsylvania = `Pennsylvania0
//         RhodeIsland = `RhodeIsland0
//         SouthCarolina = `SouthCarolina0
//         SouthDakota = `SouthDakota0
//         Tennessee = `Tennessee0
//         Texas = `Texas0
//         Utah = `Utah0
//         Vermont = `Vermont0
//         Virginia = `Virginia0
//         Washington = `Washington0
//         WestVirginia = `WestVirginia0
//         Wisconsin = `Wisconsin0
//         Wyoming = `Wyoming0
//         DC = `DC0

//         State = `Alabama0 +
//                 `Alaska0 +
//                 `Arizona0 +
//                 `Arkansas0 +
//                 `California0 +
//                 `Colorado0 +
//                 `Connecticut0 +
//                 `Delaware0 +
//                 `Florida0 +
//                 `Georgia0 +
//                 `Hawaii0 +
//                 `Idaho0 +
//                 `Illinois0 +
//                 `Indiana0 +
//                 `Iowa0 +
//                 `Kansas0 +
//                 `Kentucky0 +
//                 `Louisiana0 +
//                 `Maine0 +
//                 `Maryland0 +
//                 `Massachusetts0 +
//                 `Michigan0 +
//                 `Minnesota0 +
//                 `Mississippi0 +
//                 `Missouri0 +
//                 `Montana0 +
//                 `Nebraska0 +
//                 `Nevada0 +
//                 `NewHampshire0 +
//                 `NewJersey0 +
//                 `NewMexico0 +
//                 `NewYork0 +
//                 `NorthCarolina0 +
//                 `NorthDakota0 +
//                 `Ohio0 +
//                 `Oklahoma0 +
//                 `Oregon0 +
//                 `Pennsylvania0 +
//                 `RhodeIsland0 +
//                 `SouthCarolina0 +
//                 `SouthDakota0 +
//                 `Tennessee0 +
//                 `Texas0 +
//                 `Utah0 +
//                 `Vermont0 +
//                 `Virginia0 +
//                 `Washington0 +
//                 `WestVirginia0 +
//                 `Wisconsin0 +
//                 `Wyoming0 +
//                 `DC0 

//         population in State -> (
//             0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 +
//             10 + 11 + 12 + 13 + 14 + 15 + 16 + 17 + 18 + 19 +
//             20 + 21 + 22 + 23 + 24 + 25 + 26 + 27 + 28 + 29 +
//             30 + 31 + 32 + 33 + 34 + 35 + 36 + 37 + 38 + 39 +
//             40 + 41 + 42 + 43 + 44 + 45 + 46 + 47 + 48 + 49 +
//             50 + 51 + 52 + 53 + 54 + 55 + 56 + 57 + 58 + 59 +
//             60 + 61 + 62 + 63 + 64 + 65 + 66 + 67 + 68 + 69 +
//             70 + 71 + 72 + 73 + 74 + 75 + 76 + 77 + 78 + 79 +
//             80 + 81 + 82 + 83 + 84 + 85 + 86 + 87 + 88 + 89 +
//             90 + 91 + 92 + 93 + 94 + 95 + 96 + 97 + 98 + 99 +
//             100 + 101 + 102 + 103 + 104 + 105 + 106 + 107 + 108 + 109 +
//             110 + 111 + 112 + 113 + 114 + 115 + 116 + 117 + 118 + 119 +
//             120 + 121 + 122 + 123 + 124 + 125 + 126 + 127 + 128 + 129 +
//             130 + 131 + 132 + 133 + 134 + 135 + 136 + 137 + 138 + 139 +
//             140 + 141 + 142 + 143 + 144 + 145 + 146 + 147 + 148 + 149 +
//             150 + 151 + 152 + 153 + 154 + 155 + 156 + 157 + 158 + 159 +
//             160 + 161 + 162 + 163 + 164 + 165 + 166 + 167 + 168 + 169 +
//             170 + 171 + 172 + 173 + 174 + 175 + 176 + 177 + 178 + 179 +
//             180 + 181 + 182 + 183 + 184 + 185 + 186 + 187 + 188 + 189 +
//             190 + 191 + 192 + 193 + 194 + 195 + 196 + 197 + 198 + 199 +
//             200 + 201 + 202 + 203 + 204 + 205 + 206 + 207 + 208 + 209 +
//             210 + 211 + 212 + 213 + 214 + 215 + 216 + 217 + 218 + 219 +
//             220 + 221 + 222 + 223 + 224 + 225 + 226 + 227 + 228 + 229 +
//             230 + 231 + 232 + 233 + 234 + 235 + 236 + 237 + 238 + 239 +
//             240 + 241 + 242 + 243 + 244 + 245 + 246 + 247 + 248 + 249 +
//             250 + 251 + 252 + 253 + 254 + 255 + 256 + 257 + 258 + 259 +
//             260 + 261 + 262 + 263 + 264 + 265 + 266 + 267 + 268 + 269 +
//             270 + 271 + 272 + 273 + 274 + 275 + 276 + 277 + 278 + 279 +
//             280 + 281 + 282 + 283 + 284 + 285 + 286 + 287 + 288 + 289 +
//             290 + 291 + 292 + 293 + 294 + 295 + 296 + 297 + 298 + 299 +   
//             300 + 301 + 302 + 303 + 304 + 305 + 306 + 307 + 308 + 309 +
//             310 + 311 + 312 + 313 + 314 + 315 + 316 + 317 + 318 + 319 +
//             320 + 321 + 322 + 323 + 324 + 325 + 326 + 327 + 328 + 329 +
//             330 + 331 + 332 + 333 + 334 + 335 + 336 + 337 + 338 + 339 +
//             340 + 341 + 342 + 343 + 344 + 345 + 346 + 347 + 348 + 349 +
//             350 + 351 + 352 + 353 + 354 + 355 + 356 + 357 + 358 + 359 +
//             360 + 361 + 362 + 363 + 364 + 365 + 366 + 367 + 368 + 369 +
//             370 + 371 + 372 + 373 + 374 + 375 + 376 + 377 + 378 + 379 +
//             380 + 381 + 382 + 383 + 384 + 385 + 386 + 387 + 388 + 389 +
//             390 + 391 + 392 + 393 + 394 + 395 + 396 + 397 + 398 + 399 +
//             400
//         )

//         votes in State -> (
//             0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 +
//             10 + 11 + 12 + 13 + 14 + 15 + 16 + 17 + 18 + 19 +
//             20 + 21 + 22 + 23 + 24 + 25 + 26 + 27 + 28 + 29 +
//             30 + 31 + 32 + 33 + 34 + 35 + 36 + 37 + 38 + 39 +
//             40 + 41 + 42 + 43 + 44 + 45 + 46 + 47 + 48 + 49 +
//             50 + 51 + 52 + 53 + 54
//         )
// }

// test expect {
//     canWinWithoutPopVote: {
//         traces
//         canWinWithoutPopularVote
//     } for exactly 11 Int for partial is sat
// }

run {
    traces
    // canWinWithoutPopularVote
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