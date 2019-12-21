	//the code is structured from autograder -------from Tor
module my_own_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;

  lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  initial forever begin
    KEY[0] = 1; #5;
    KEY[0] = 0; #5;
  end
//MOV R3, X
//MOV R2, Y
//LDR R5, [R3]
//ADD R1, R2, R5 
//STR R1, [R3]
//HALT
//X:
//.word 0x720
//Y:
//.word 0x424

  initial begin
    err = 0;
    KEY[1] = 1'b0; // 

    if (DUT.MEM.mem[0] !== 16'b1101001100000110) begin 
	err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	//6
	//MOV R3, X //0x720
    if (DUT.MEM.mem[1] !== 16'b1101001000000111) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	//7
	//MOV R2, Y //0x424
    if (DUT.MEM.mem[2] !== 16'b0110001110100000) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	//LDR R5, [R3] // temporary register R5 gets A[0]
    if (DUT.MEM.mem[3] !== 16'b1010001000100101) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	//ADD R1, R2, R5 // g = h + A[0]
    if (DUT.MEM.mem[4] !== 16'b1000001100100000) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	//STR R1, [R3]
	if (DUT.MEM.mem[5] !== 16'b1110000000000000) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	//halt
    if (DUT.MEM.mem[6] !== 16'b0000011100100000) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	
	if (DUT.MEM.mem[7] !== 16'b0000010000100100) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	
    #10; 
    KEY[1] = 1'b1; // reset button
    #10; // give some time to rest
	
	//......................................................

    if (DUT.CPU.PC !== 9'b0) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC); 

    if (DUT.CPU.PC !== 9'h1) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  //

    if (DUT.CPU.PC !== 9'h2) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
    if (DUT.CPU.DP.REGFILE.R3 !== 16'h6) begin //the memary address is 6 and store in R3
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end  // 

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait

    if (DUT.CPU.PC !== 9'h3) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
    if (DUT.CPU.DP.REGFILE.R2 !== 16'h7) begin //the memary address is 7 and store in R2
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait

    if (DUT.CPU.PC !== 9'h4) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
    if (DUT.CPU.DP.REGFILE.R5 !== 16'h720) begin //the vale was move to R5(720)
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	
	if (DUT.CPU.PC !== 9'h5) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h727) begin // add the (address of 424) and the 720
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	  
 
	@(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	if (DUT.CPU.PC !== 9'h6) begin 
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end
	
    if (DUT.MEM.mem[6] !== 16'h727) begin //store this value into R3
		err = 1; 
		$display("FAILED"); 
		$stop; 
	end

    if (~err) 
	$display("INTERFACE OK");
    $stop;
  end
endmodule
