# cs1710-Final-Project

## Election Model

We wanted to model the United States election system to better understand different scenarios possible. 


## HOW TO USE:

1) Uncomment states(sigs, setUpStateVotes, and setUpStatePopulation) you want to model. Make sure the same states are uncommented in the state sigs and two predicates!

2) Model! If too many states are chosen, the modeling time may be dramatically increased and/or bit-wdith may need to be larger if UNSAT.

3) Edit the visualizer array `const stateNames` to include the states you modeled to better see votes for candidates, votedFor, etc. 

 **The candidate that has the most electoral votes won the election!**

Notes: 

- For the visualizer, you may need to change the dimensions of "viewBox"(at the top) to better fit the dimensions of your screen.

- This is mentioned in the **Struggles** section: The model can only model fixed number of candidates as adding a `func Candidate -> Int` inside of each state made it practically impossible to model.


## Struggles:

- Modeling all 50 states at once WITH the population included led to a long modeling time(we don't know how long - we've waited at most ~20 minutes).

- Adding a function mapping to candidates -> int increased modeling time dramatically, so extensability became an issue for > 2 Candidates