// DetectWinner
// Detects whether either ain or bin has three in a row 
// Inputs:
//   ain, bin - (9-bit) current positions of type a and b
// Out:
//   win_line - (8-bit) if A/B wins, one hot indicates along which row, col or diag
//   win_line(0) = 1 means a win in row 8 7 6 (i.e., either ain or bin has all ones in this row)
//   win_line(1) = 1 means a win in row 5 4 3
//   win_line(2) = 1 means a win in row 2 1 0
//   win_line(3) = 1 means a win in col 8 5 2
//   win_line(4) = 1 means a win in col 7 4 1
//   win_line(5) = 1 means a win in col 6 3 0
//   win_line(6) = 1 means a win along the downward diagonal 8 4 0
//   win_line(7) = 1 means a win along the upward diagonal 2 4 6

module DetectWinner( input [8:0] ain, bin, output [7:0] win_line );
  // CPEN 211 LAB 3, PART 1: your implementation goes here
  wire [7:0]winner_a; //a will be the winner, and 7 means 3 rows + 3 columns + 2 diagonal
  wire [7:0]winner_b; //b will be the winner, and 7 means 3 rows + 3 columns + 2 diagonal

  
  
  assign winner_a [0] = ain [8] & ain [7] & ain [6]; //check first row
  assign winner_a [1] = ain [5] & ain [4] & ain [3]; //check second row
  assign winner_a [2] = ain [2] & ain [1] & ain [0]; //check third row
  
  assign winner_a [3] = ain [8] & ain [5] & ain [2]; //check first column
  assign winner_a [4] = ain [7] & ain [4] & ain [1]; //check second column
  assign winner_a [5] = ain [6] & ain [3] & ain [0]; //check third column
  
  assign winner_a [6] = ain [8] & ain [4] & ain [0]; //check first diagonal
  assign winner_a [7] = ain [6] & ain [4] & ain [2]; //check second diagonal
  
  
  assign winner_b [0] = bin [8] & bin [7] & bin [6]; //check first row
  assign winner_b [1] = bin [5] & bin [4] & bin [3]; //check second row
  assign winner_b [2] = bin [2] & bin [1] & bin [0]; //check third row
  
  assign winner_b [3] = bin [8] & bin [5] & bin [2]; //check first column
  assign winner_b [4] = bin [7] & bin [4] & bin [1]; //check second column
  assign winner_b [5] = bin [6] & bin [3] & bin [0]; //check third column
  
  assign winner_b [6] = bin [8] & bin [4] & bin [0]; //check first diagonal
  assign winner_b [7] = bin [6] & bin [4] & bin [2]; //check second diagonal
  
  assign win_line = winner_a | winner_b; //Check who wins finally
  
  
endmodule
