#lang forge

abstract sig Human {    
    age: one Int
}
one sig Person0 extends Human {}
one sig Person1 extends Human {}


inst optimizer {
    -- don't try this
    --Int = 0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 +
    --      10 + 11 + 12 + 13 + 14 + 15 + 16 + 17 + 18 + 19
    -- but this works
    Person0 = `Person0
    Person1 = `Person1

    Human = Person0 + Person1
    age in Human -> (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9)
}


run {
    
} for exactly 2 Human