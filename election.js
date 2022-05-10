d3 = require('d3')
d3.selectAll("svg > *").remove();

const stateNames = [
  'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut',
  'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas',
  'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 
  'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'NewHampshire', 'NewJersey', 
  'NewMexico', 'NewYork', 'NorthCarolina', 'NorthDakota', 'Ohio', 'Oklahoma', 'Oregon',
  'Pennsylvania', 'RhodeIsland', 'SouthCarolina', 'SouthDakota', 'Tennessee', 'Texas', 'Utah', 
  'Vermont', 'Virginia', 'Washington', 'WestVirginia', 'Wisconsin', 'Wyoming'
];

function printBoard() {

  y = 0
  x = 0
  
  for(i = 0; i < stateNames.length; i++) {

  d3.select(svg)
    .append('rect')
    .attr('x', x)
    .attr('y', y)
    .attr('width', 100)
    .attr('height', 100)
    .attr('stroke-width', 1)
    .attr('stroke', 'black')
    .attr('fill', 'transparent');
    
  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .style("font-size", "12px")
    .attr("x", x)
    .attr("y", y+15)
    .text(State.atom(stateNames[i]+'0').toString().substring(0, stateNames[i].length));

  d3.select(svg)
    .append("text")
    .style("fill", "black")
    .style("font-size", "12px")
    .attr("x", x)
    .attr("y", y+30)
    .text(State.atom(stateNames[i]+'0').chosenCandidate.toString());



    d3.select(svg)
    .append("text")
    .style("font-size", "11px")
    .style("fill", "black")
    .attr("x", x)
    .attr("y", y+50)
    .text("Electoral Votes: " + State.atom(stateNames[i]+'0').votes.toString());



    y += 50
    if(y > 600) {
        y = 0
        x += 100
    }
  }
}

function printCandidates() {
  candidate = Election.atom("Election0").candidates.toString()
  const arr = candidate.split(/\s/)
  x = 430
  y = 0

  for(i = 0; i < arr.length; i++) {

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
    .text(arr[i]);

  d3.select(svg)
    .append('text')
    .attr('x', x+5)
    .attr('y', y+35)
    .attr('width', 100)
    .attr('height', 100)
    .style("font-size", "10px")
    .text("Total Elec. Votes: " + Candidate.atom(arr[i]).votesReceived.toString());

    y += 100
    

  }

  
}

printBoard()
printCandidates()