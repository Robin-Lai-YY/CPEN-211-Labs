// Structure from Lab 7 auto grader, thank to Dr.Tor
module stage3_tb;
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

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    
    if (DUT.MEM.mem[0] !== 16'b11010000_00001000) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.MEM.mem[1] !== 16'b01100000_00000000) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.MEM.mem[2] !== 16'b01100000_01000000) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.MEM.mem[3] !== 16'b11000000_01101010) begin err = 1; $display("FAILED"); $stop; end
	/////////////////MOV separate
    if (DUT.MEM.mem[4] !== 16'b11010001_00001001) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.MEM.mem[5] !== 16'b01100001_00100000) begin err = 1; $display("FAILED"); $stop; end
	if (DUT.MEM.mem[6] !== 16'b10000001_01100000) begin err = 1; $display("FAILED"); $stop; end
	if (DUT.MEM.mem[7] !== 16'b11100000_00000000) begin err = 1; $display("FAILED"); $stop; end
	if (DUT.MEM.mem[8] !== 16'b00000001_01000000) begin err = 1; $display("FAILED"); $stop; end
	if (DUT.MEM.mem[9] !== 16'b00000001_00000000) begin err = 1; $display("FAILED"); $stop; end


    #10; 
    KEY[1] = 1'b1;

    #10;

    if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED"); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h8) begin err = 1; $display("FAILED"); $stop; end  
	//what is R0 address
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h0140) begin err = 1; $display("FAILED"); $stop; end
	//what is R0

	SW[7:0] = 8'b00000001;
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h4) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.CPU.DP.REGFILE.R2 !== 16'b00000000_00000001) begin err = 1; $display("FAILED"); $stop; end
	//what is R2 address
	
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC); 
   
    if (DUT.CPU.PC !== 9'h5) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.CPU.DP.REGFILE.R3 !== DUT.CPU.DP.REGFILE.R2<<1) begin err = 1; $display("FAILED"); $stop; end
	//multiple by 2
	
	@(posedge DUT.CPU.PC or negedge DUT.CPU.PC); 
   
    if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'b00000000_00001001) begin err = 1; $display("FAILED"); $stop; end
	//R1 address
	
	@(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  

    if (DUT.CPU.PC !== 9'h7) begin err = 1; $display("FAILED"); $stop; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h100) begin err = 1; $display("FAILED"); $stop; end  
	// what is R1
   
   @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);
	
    if (DUT.CPU.PC !== 9'h8) begin err = 1; $display("FAILED"); $stop; end
	// store
	 
    if (~err) $display("INTERFACE OK");
    $stop;
  end
endmodule


















