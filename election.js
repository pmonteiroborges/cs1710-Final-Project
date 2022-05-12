d3 = require('d3')
d3.selectAll("svg > *").remove();

d3.select(svg)
  .attr("viewBox", "0 70 600 700")

// ONLY INCLUDE STATE NAMES YOU HAVE MODELING
/** 
const stateNames = [
  'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
  'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas',
  'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'NewHampshire', 'NewJersey', 
  'NewMexico', 'NewYork', 'NorthCarolina', 'NorthDakota', 'Ohio', 'Oklahoma', 'Oregon',
  'Pennsylvania', 'RhodeIsland', 'SouthCarolina', 'SouthDakota', 'Tennessee', 'Texas', 'Utah', 
  'Vermont', 'Virginia', 'Washington', 'WestVirginia', 'Wisconsin', 'Wyoming'
];
*/

// sample one: 
// const stateNames = [
//   'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
//   'Delaware', 'Florida'
// ];

//sample two:
// 13 colonies
const stateNames = [
  'Connecticut',
  'Delaware',
  'Georgia',
  'Maryland',
  'Massachusetts',
  'NewHampshire',
  'NewJersey',
  'NewYork',
  'NorthCarolina',
  'Pennsylvania',
  'RhodeIsland',
  'SouthCarolina',
  'Virginia'
];

function printBoard() {

  y = 0
  x = 0
  
  for(i = 0; i < stateNames.length; i++) {

  d3.select(svg)
    .append('rect')
    .attr('x', x)
    .attr('y', y)
    .attr('width', 150)
    .attr('height', 150)
    .attr('stroke-width', 1)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
    
  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .style("font-size", "11px")
    .attr("x", x)
    .attr("y", y+15)
    .text(State.atom(stateNames[i]+'0').toString().substring(0, stateNames[i].length));

  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .style("font-size", "11px")
    .attr("x", x)
    .attr("y", y+30)
    .text("Voted for: " + State.atom(stateNames[i]+'0').chosenCandidate.toString());



    d3.select(svg)
    .append("text")
    .style("font-size", "11px")
    .style("fill", "black")
    .attr("x", x)
    .attr("y", y+40)
    .text("Electoral Votes: " + State.atom(stateNames[i]+'0').votes.toString());

    d3.select(svg)
    .append("text")
    .style("font-size", "11px")
    .style("fill", "black")
    .attr("x", x)
    .attr("y", y+50)
    .text("Population: " + State.atom(stateNames[i]+'0').population.toString());


        d3.select(svg)
    .append("text")
    .style("font-size", "11px")
    .style("fill", "black")
    .attr("x", x)
    .attr("y", y+60)
    .text("Vote for C1: " + State.atom(stateNames[i]+'0').candOneVotes.toString());

        d3.select(svg)
    .append("text")
    .style("font-size", "11px")
    .style("fill", "black")
    .attr("x", x)
    .attr("y", y+70)
    .text("Vote for C2: " + State.atom(stateNames[i]+'0').candTwoVotes.toString());
    y += 75
    if(y > 600) {
        y = 0
        x += 150
    }
  }
}

function printCandidates(numCandidates) {
  candidate = Election.atom("Election0").candidates.toString()
  x = 430
  y = 0

  for(i = 0; i < numCandidates; i++) {
  d3.select(svg)
    .append('rect')
    .attr('x', x)
    .attr('y', y)
    .attr('width', 110)
    .attr('height', 100)
    .attr('stroke-width', 1)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');

    d3.select(svg)
    .append('text')
    .attr('x', x+20)
    .attr('y', y+14)
    .attr('width', 100)
    .attr('height', 100)
    .style("font-size", "12px")
    .text("Candidate "+(i+1));

  if(i == 0) {
  d3.select(svg)
    .append('text')
    .attr('x', x+5)
    .attr('y', y+35)
    .attr('width', 100)
    .attr('height', 100)
    .style("font-size", "10px")
    .text("Total Elec. Votes: " + Candidate.atom("CandidateOne"+0).votesReceived.toString());

  d3.select(svg)
    .append('text')
    .attr('x', x+5)
    .attr('y', y+55)
    .attr('width', 100)
    .attr('height', 100)
    .style("font-size", "10px")
    .text("Total Pop. Votes: " + Candidate.atom("CandidateOne"+0).popularVotesReceived.toString());

    
  } else {
    d3.select(svg)
    .append('text')
    .attr('x', x+5)
    .attr('y', y+35)
    .attr('width', 100)
    .attr('height', 100)
    .style("font-size", "10px")
    .text("Total Elec. Votes: " + Candidate.atom("CandidateTwo"+0).votesReceived.toString());

    d3.select(svg)
    .append('text')
    .attr('x', x+5)
    .attr('y', y+55)
    .attr('width', 100)
    .attr('height', 100)
    .style("font-size", "10px")
    .text("Total Pop. Votes: " + Candidate.atom("CandidateTwo"+0).popularVotesReceived.toString());

  }
  y += 100
  }

  
}

printBoard()
printCandidates(2)