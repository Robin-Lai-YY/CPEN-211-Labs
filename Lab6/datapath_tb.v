module datapath_tb;

	reg clk;
	
	wire Z_out;	
	wire [15:0]datapath_out;
	
	wire N;
	wire V;
	
	reg [41:0]from_decoder;
	reg [11:0]from_SM;
	
	datapath DUT(clk, Z_out, datapath_out, from_decoder, from_SM, N, V);
	
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
		from_decoder[23:8] = 16'd7; //write 7 to R0
		from_SM[8:7] = 2'b10;
		from_decoder[2:0] = 3'b000;
		from_SM[6] = 1;
		#10;
  
		from_decoder[23:8] = 16'd2; // write 2 to R1
		from_decoder[2:0] = 3'b001;
	from_SM[6] = 1;
  #10;
  from_SM[6] = 0; // stop write
  #10;
  
  from_SM[5:3] = 3'b000; //read value from R0 and shift it 
  from_SM[5] = 0;
  from_SM[4] = 1;
  #10;  
  ///////////////////////
  from_decoder[5:3] = 3'b001; // read value from R1
  from_SM[5]= 1;
from_SM[4] = 0;
  #10;
  from_SM[5] = 0; //reset  
  
  from_decoder[7:6] = 2'b01;
	
 from_SM[0] = 0;
  #10;
  from_SM[1] = 0;
  from_decoder[41:40] = 2'b00; //add two num
  #10;
  
  from_SM[3] = 1;
from_SM[2] = 1;
  #10;
  from_SM[3] = 0;
from_SM[2] = 0;
  #10;
  
  //done with add and store num to specific adress
  
  from_SM[8:7] = 2'b00; // memorized the past value 
  from_decoder[2:0] = 3'b010; // write the result to R2
  from_SM[6] = 1;
  #10;
  from_decoder[5:3] = 3'b010;
  
  #20;
  #500;
  $stop; 
 
	end
	
/*			ALUop = from_decoder[41:40];
	assign sximm5 = from_decoder[39:24];
	assign sximm8 = from_decoder[23:8];
	assign shift = from_decoder[7:6];
	assign readnum = from_decoder[5:3];
	assign writenum = from_decoder[2:0];
	
	
			vsel = from_SM[8:7];
	assign write = from_SM[6];
	assign loada = from_SM[5];
	assign loadb = from_SM[4];
	assign loadc = from_SM[3];
	assign loads = from_SM[2];
	assign asel = from_SM[1];
	assign bsel = from_SM[0];
	
	*/	
	
endmodule