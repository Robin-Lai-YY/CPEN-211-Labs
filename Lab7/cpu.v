module cpu(clk, reset, s, read_data, N, V, Z, w, select_out, mem_cmd, write_data);
	input clk,reset, s;
	
	input [15:0] read_data;
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
	
	output [1:0] mem_cmd;
	
	output [15:0]write_data;
	
	wire addr_sel;
	wire load_pc;
	wire reset_pc;
	wire load_addr;
	wire load_ir;
	wire Z_out;
	
	//wire [41:0]from_decoder;
	wire w;
	wire [7:0]PC_from_dapapath;
	assign PC_from_dapapath = 8'b00000000;
	
	wire [15:0]mdata;
	
	wire [8:0]PC;
	
	wire [8:0]data_address_out;
	
	output [8:0]select_out;  //mem_addr
		
	
	assign nsel = SM_out[11:9];
	
	wire [41:0]decoder_out;
	
	instruction_reg my_reg(read_data, reg_out, load_ir, clk);  // load_ir changed
	
	decoder my_decoder(reg_out, nsel, opcode, op, readnum, writenum, shift, sximm8, sximm5, ALUop, decoder_out);
	
	SM my_SM(opcode, op, reset, clk, s, SM_out, w, mem_cmd, addr_sel, load_pc, reset_pc, load_addr, load_ir);
	
	program_counter pc(clk, load_pc, reset_pc,PC);
	
	vDFF #(9) data_address (clk, load_addr, write_data[8:0], data_address_out);
	
	MUX2 #(9) address_sel(PC, data_address_out, select_out ,addr_sel);
	
	datapath DP(clk, Z_out, write_data, decoder_out, SM_out, N, V, sximm5, sximm8, PC_from_dapapath, read_data);
	
endmodule
	
	
	
	
module MUX2(ain, bin, out, sel);
	parameter k=1;
	input [k-1:0]ain;
	input [k-1:0]bin;
	input sel;
	
	output [k-1:0]out;
	assign out = sel ? ain:bin;
endmodule
	
	