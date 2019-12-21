module cpu(clk, reset, s, load, in, out, N, V, Z, w);
	input clk,reset, s, load;
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w;
	
	wire [15:0]reg_out;
	
	wire [2:0]opcode;
	wire [1:0]op;
	wire [2:0]readnum, writenum;
	wire [1:0]shift;
	wire [15:0]sximm8;
	wire [15:0]sximm5;
	wire [1:0]ALUop;
	wire [2:0]nsel;
	wire [11:0]SM_out;
	assign nsel = SM_out[11:9];
	
	wire [41:0]decoder_out;
	
	instruction_reg my_reg(in, reg_out, load, clk);
	decoder my_decoder(reg_out, nsel, opcode, op, readnum, writenum, shift, sximm8, sximm5, ALUop, decoder_out);
	SM my_SM(opcode, op, reset, clk, s, SM_out, w);
    datapath DP(clk, Z, out, decoder_out, SM_out, N, V);
	
endmodule
	