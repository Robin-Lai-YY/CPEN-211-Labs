module lab8_stage2_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;
  reg CLOCK_50;
  wire [15:0] hapi;
  
  assign hapi = DUT.MEM.mem[25];

  lab8_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);

  initial forever begin
    CLOCK_50 = 0; #5;
    CLOCK_50 = 1; #5;
  end
  wire break = (LEDR[8] == 1'b1);
  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    #10; // wait until next falling edge of clock
    KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4
    while (~break) begin
      @(posedge (DUT.CPU.my_SM.currentstate == 5'b01011) or posedge break);  // wait until IF1 
      @(negedge CLOCK_50); // show advance to negative edge of clock
      $display("PC = %h", DUT.CPU.PC); 
    end
    if (DUT.MEM.mem[25] !== -16'd23) begin err = 1; $display("FAILED: mem[25] wrong"); $stop; end
	//1110_1000+1=1110_1001
    if (~err) $display("PASSED");
    $stop;
  end
endmodule
