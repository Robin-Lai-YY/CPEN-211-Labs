module shifter_tb();
	parameter n = 16;
	reg [15:0] in;
	reg [1:0] shift;
	wire [15:0] sout;
	reg err;
	shifter DUT(in, shift, sout);
	
	initial begin 
	err = 0;
	in = 16'b1111000011001111;
	shift = 2'b00;
	#10;
	if(sout !== 16'b1111000011001111) //if it is equal to this value
		err = 1;
	#10;
	
	in = 16'b1111000011001111;
	shift = 2'b01;
	#10;
	if(sout !== 16'b1110000110011110) //if it is equal to this value
		err = 1;
	#10;
	
	in = 16'b1111000011001111;
	shift = 2'b10;
	#10;
	if(sout !== 16'b0111100001100111) //if it is equal to this value
		err = 1;
	#10;
	
	in = 16'b1111000011001111;
	shift = 2'b11;
	#10;
	if(sout !== 16'b1111100001100111) //if it is equal to this value
		err = 1;
	#10;
	#500;
	
	end
endmodule 
