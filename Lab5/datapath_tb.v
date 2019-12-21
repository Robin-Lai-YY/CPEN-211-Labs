module datapath_tb();
 parameter k = 16;
 reg clk;
 
 reg [k-1:0]datapath_in;
 reg vsel, write, loada, loadb, asel, bsel, loadc, loads;
 reg [1:0]shift;
 reg [1:0]ALUop; 
 reg [2:0]writenum, readnum;

 wire Z_out; 
 wire [k-1:0]datapath_out;
 datapath dut(
    .clk(clk), 
    .datapath_in(datapath_in), 
    .vsel(vsel), 
    .write(write), 
    .loada(loada), 
    .loadb(loadb), 
    .asel(asel), 
    .bsel(bsel), 
    .loadc(loadc), 
    .loads(loads), 
    .shift(shift), 
    .ALUop(ALUop), 
    .writenum(writenum), 
    .readnum(readnum), 
    .Z_out(Z_out), 
    .datapath_out(datapath_out));
 
 initial begin   
  clk = 0;
  #5;
  forever begin 
  clk = 1;
  #5;
  clk = 0;
  #5;
  end
 end
 
 initial begin   
  datapath_in = 16'd7; //write 7 to R0
  vsel = 1;
  writenum = 3'b000;
  write = 1;
  #10;
  
  datapath_in = 16'd2; // write 2 to R1
  writenum = 3'b001;
  write = 1;
  #10;
  write = 0; // stop write
  
  readnum = 3'b000; //read value from R0 and shift it 
  loada = 0;
  loadb = 1;  
  #10;  
  
  readnum = 3'b001; // read value from R1
  loada = 1;
  loadb = 0;
  #10;
  loada = 0; //reset  
  
  shift = 2'b01;
  bsel = 0;    
  #10;
  
  asel = 0; 
  ALUop = 2'b00; //add two num
  #10;
  
  loadc = 1;
  loads = 1;
  #10;
  
  loadc = 0;
  loads = 0;
  #10;
  
  //done with add and store num to specific adress
  
  vsel = 0; // memorized the past value 
  writenum = 3'b010; // write the result to R2
  write = 1;
  #20;
  #500;
  $stop; 
 end 
endmodule
 