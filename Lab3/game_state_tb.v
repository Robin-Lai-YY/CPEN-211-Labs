module clever_mode;


  reg [8:0] xin, oin;
  
  // the input xin is the computer's decision
  // the input oin is human's decision
  wire [8:0] xout;
  // the output xout is the computer's next step 

  TicTacToe dut(xin, oin, xout) ;


  initial begin

    // testing 
    //  x |   | 
    //    | 0 |
    //    |   | x
    oin = 9'b100_000_001;
	 // this input is human's decision, same the positiion like"X" in the graph above
    xin = 9'b000_010_000;
	 // this input is computer's decision, same as th3e position like "O" in the graph above
    #100;
	 // 100 units of time delay
    $display("%b %b -> %b", xin, oin, xout) ;


    // testing 
    //    |   | x
    //    | 0 |
    //  x |   | 
    oin = 9'b001_000_100;
	 //same as the3 graph above
    xin = 9'b000_010_000;
    #100;
	 //same as above
    $display("%b %b -> %b", xin, oin, xout) ;


  end
endmodule