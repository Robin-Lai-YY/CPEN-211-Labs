module cpu(clk, reset, s, read_data, N, V, Z, w, select_out, mem_cmd, write_data, halt_signal, stop, number_user_want_to_add);
	input clk,reset, s;
	
	input [15:0] read_data;
	
	input stop;
	input [3:0] number_user_want_to_add;
	
	output w;
	
	wire [2:0] cond;//.......new.......
	output Z, N, V;//.......new.......
	wire [1:0]select_which_pc_signal;//..........select which pc needed............
	output halt_signal;//new in lab8
	
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
	
	
	wire [15:0]mdata;
	
	wire [8:0]PC;
	
	wire [8:0]data_address_out;
	
	output [8:0]select_out;  //mem_addr
		
	
	assign nsel = SM_out[11:9];
	
	wire [41:0]decoder_out;
	
	
	wire controll_original_pc;
	
	wire controll_the_pc_value_when_frozen;
	
	instruction_reg my_reg(read_data, reg_out, load_ir, clk);  // load_ir changed
	
	decoder my_decoder(reg_out, nsel, opcode, op, readnum, writenum, shift, sximm8, sximm5, ALUop, decoder_out, cond);
	
	SM my_SM(opcode, op, reset, clk, s, SM_out, w, mem_cmd, addr_sel, load_pc, reset_pc, load_addr, load_ir, cond, Z, N, V, 
			
				select_which_pc_signal, halt_signal, controll_original_pc, stop, controll_the_pc_value_when_frozen); // changed
	
	program_counter pc(clk, load_pc, reset_pc, PC, select_which_pc_signal, sximm8, controll_original_pc, controll_the_pc_value_when_frozen); // lab 8 changed
	
	vDFF #(9) data_address (clk, load_addr, write_data[8:0], data_address_out);
	
	MUX2 #(9) address_sel(PC, data_address_out, select_out ,addr_sel);
	
	datapath DP(clk, Z, write_data, decoder_out, SM_out, N, V, sximm5, sximm8, PC, read_data, number_user_want_to_add);
	
endmodule
	
	
	
	
module MUX2(ain, bin, out, sel);
	parameter k=1;
	input [k-1:0]ain;
	input [k-1:0]bin;
	input sel;
	
	output [k-1:0]out;
	assign out = sel ? ain:bin;
endmodule
	
	