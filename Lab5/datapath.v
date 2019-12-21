module datapath(clk, datapath_in, Z_out, datapath_out, from_decoder, from_SM);
	parameter k = 16;
	
	input clk;
	input [k-1:0]datapath_in;
	
	wire [k-1:0]data_in, data_out;
	wire [k-1:0]a_out, b_out;
	wire [k-1:0]sout;
	wire [k-1:0]Ain, Bin;
	wire [k-1:0]ALU_out;
	wire Z;
	
	output Z_out;	
	output [k-1:0]datapath_out;
	
	output N, V;
	
	input [41:0]from_decoder;
	input [11:0]from_SM;
	
	// decoder below
	wire [1:0]ALUop;
	wire [15:0]sximm5;
	wire [15:0]sximm8;
	wire [1:0]shift;
	wire [2:0]readnum;
	wire [2:0]writenum;
	
	assign ALUop = from_decoder[41:40]
	assign sximm5 = from_decoder[39:24];
	assign sximm8 = from_decoder[23:8];
	assign shift = from_decoder[7:6];
	assign readnum = from_decoder[5:3];
	assign writenum = from_decoder[2:0];
	// SM below
	wire [1:0]nsel;
	wire [1:0]vsel;
	wire write, loada, loadb, asel, bsel, loadc, loads;
	
	assign nsel = from_SM[11:10];
	assign vsel = from_SM[9:7];
	assign write = from_SM[6];
	assign loada = from_SM[5];
	assign loadb = from_SM[4];
	assign loadc = from_SM[3];
	assign loads = from_SM[2];
	assign asel = from_SM[1];
	assign bsel = from_SM[0];
	
	
	wire [15:0]mdata; // will be change in future
	assign mdata = 16'b0;
	
	wire [7:0] PC; // will be change in future
	assign PC = 8'b0;
	
	MUX4 first(.mdata(madata), .sximm8(sximm8), .newdata({8'b0,PC}),.c(c), .vsel(vsel), .out(out)); // improved 9
	
	regfile  REGFILE(.data_in(data_in),.writenum(writenum),.write(write),.readnum(readnum),.clk(clk),.data_out(data_out)); //1 no change
	
	vDFFE #(16) ff1(.clk(clk), .en(loada), .in(data_out), .out(a_out)); //3 no change
	vDFFE #(16) ff2(.clk(clk), .en(loadb), .in(data_out), .out(b_out)); //4 no change 
	
	shifter #(16) first_shifter(.in(b_out), .shift(shift), .sout(sout)); //8 no change 
	
	MUX_A second(.in(a_out), .asel(asel), .out(Ain)); //improved 6 
	
	MUX_B third(.in(sout), .bsel(bsel), .out(Bin), .sximm5(sximm5)); //improved 7
	
	ALU #(16) first_ALU(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(ALU_out), .Z(Z)); //2 no change 
	
	vDFFE #(16) ff4(.clk(clk), .en(loadc), .in(ALU_out), .out(datapath_out)); //5 no change 
	vDFFE #(1) ff3(.clk(clk), .en(loads), .in(Z), .out(Z_out)); //10 no change 
	assign N = datapath_out[15];
	always@(*) begin
		if(Ain[15] == 1 & Bin[15] == 1 & datapath_out[15] == 0 && ALUop == 00)
			V = 1;
		else if(Ain[15] == 0 & Bin[15] == 0 & datapath_out[15] == 1 && ALUop == 00)
		`	V = 1;
		else
			V = 0;
	end
endmodule

module MUX4 (mdata, sximm8, newdata, c, vsel, out);
	input [15:0]mdata;
	input [15:0]sximm8;
	input [15:0]newdata;
	input [15:0]c;
	input [3:0]vsel;
	output reg[15:0]out;
	
	always@(*) begin 
		case(vsel)
		2'b11: out = mdata;
		2'b10: out = sximm8;
		2'b01: out = newdata;
		2'b00: out = c;
		default: out = 16'bx;
		endcase
	end
endmodule

module MUX_A (asel, in, out);
  input asel;
  input [15:0] in;
  output reg [15:0] out;
  
  always @(*) begin
    out = asel? 16'b0:in;
  end
endmodule
	

module MUX_B(bsel, sximm5, in, out);
	input [15:0]in, sximm5;
	input bsel;
	output reg[15:0] out;
	
	always@(*) begin
		out = bsel? sximm5:in;
		end
	endmodule	
	
	
	
	
	
	
	
	
	
	
	


