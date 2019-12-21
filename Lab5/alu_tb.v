module ALU_tb();
	parameter k = 16;
	reg [k-1:0] Ain, Bin;
	reg [1:0] ALUop;
	wire [k-1:0] out;
	wire Z;
	reg err;
	reg [k-1:0]expect_value;
	ALU DUT(Ain, Bin, ALUop, out, Z);
	
	initial begin 
	expect_value = 16'bxxxxxxxxxxxxxxxx;
	err = 0;
	Ain = 16'b0000000000000001;
	Bin = 16'b0000000000000001;
	ALUop = 2'b00;
	expect_value = Ain + Bin;
	#10;
	if(out !== expect_value) //check if it si the expect_value "add"
		err = 1;
	#10;
	
	Ain = 16'b0000000000000001;
	Bin = 16'b0000000000000001;
	ALUop = 2'b01;
	expect_value = Ain - Bin;
	#10;
	if(out !== expect_value) //check if it si the expect_value "-"
		err = 1;
	#10;
	
	Ain = 16'b0000000000000001;
	Bin = 16'b0000000000000001;
	ALUop = 2'b10;
	expect_value = Ain & Bin;
	#10;
	if(out !== expect_value) //check if it si the expect_value "&"
		err = 1;
	#10;
	
	Ain = 16'b0000000000000001;
	Bin = 16'b0000000000000001;
	ALUop = 2'b11;
	expect_value = ~Bin;
	#10;
	if(out !== expect_value)  //check if it si the expect_value "~Bin"
		err = 1;
	#10;
	#500;
	
	end
	
endmodule