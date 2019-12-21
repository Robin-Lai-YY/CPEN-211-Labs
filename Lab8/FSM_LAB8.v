
`define beginning_state 5'b00000
`define decode_state 5'b00001
`define mov_state 5'b00010
`define getnumA_state 5'b00011
`define getnumB_state 5'b00100
`define shift_state 5'b00101
`define add_operation 5'b00110
`define minus_operation 5'b00111
`define and_operation 5'b01000
`define what_operation 5'b01001
`define store_state_one 5'b01010

`define store_state_two 5'b01110

`define IF1 5'b01011
`define IF2 5'b01100
`define UPDATEPC 5'b01101

`define LDR 5'b01111

`define STR 5'b10000
`define STR2 5'b10001
`define STR3 5'b10010

`define stop 5'b10011

`define shabi 5'b10100
`define hapi 5'b10101
`define seperate 5'b10111

`define pc_plus_1_plus_sximm 5'b10110

`define table_2 5'b11000

`define save_pc_value 5'b11001

`define BLX_RD 5'b11010

`define whether_frozen 5'b11011
`define whether_frozen_add_data 5'b11100
`define finish_load_pc_value 5'b11101

module SM(opcode, op, reset, clk, s, out, w, mem_cmd, addr_sel, load_pc, reset_pc, load_addr, load_ir, cond, Z, N, V, 

select_which_pc_signal, halt_signal, 

controll_original_pc, frozen, controll_the_pc_value_when_frozen);

	input [2:0] opcode;
	input [1:0] op;
	input reset;
	input clk;
	input s;
	
	input [2:0] cond;//.......new.......
	input Z, N, V;//.......new.......
	
	input frozen;
	
	output reg [11:0] out;
	output reg w;
	output reg [1:0] mem_cmd;
	output reg addr_sel;
	output reg load_pc;
	output reg reset_pc;
	output reg load_addr;
	output reg load_ir;
	
	output reg [1:0]select_which_pc_signal;//..........select which pc needed............
	
	output reg halt_signal;
	
	output reg controll_original_pc;
	
	output reg controll_the_pc_value_when_frozen;
	
	reg  [4:0]currentstate;
	reg  [4:0]nextstate;
	
	
	
	

	always @(posedge clk) begin
	
	if(reset) begin
		nextstate = `beginning_state;
        reset_pc = 1;
        load_pc = 1;
		mem_cmd = 2'b00;
		out = 12'b000000000000;//nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
		halt_signal = 0; 
	end
	else begin
		casex ({currentstate, opcode, op, cond}) 
		
		{`beginning_state, 3'bxxx, 2'bxx, 3'bxxx}: begin
			nextstate = `IF1;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1'b1;
			mem_cmd = 2'b00;
			load_ir = 0;
			load_addr = 0;
			addr_sel = 0;
			reset_pc = 1;
			load_pc = 1;
			halt_signal = 0;
			select_which_pc_signal = 2'b00;
		end
		
		{`IF1, 3'bxxx, 2'bxx, 3'bxxx}: begin
			nextstate = `IF2;
			controll_the_pc_value_when_frozen = 0;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1'b1;
			mem_cmd = 2'b01;//
			load_ir = 0;//
			load_addr = 0;
			addr_sel = 1;
			reset_pc = 0;
			load_pc = 0;
			select_which_pc_signal = 2'b00;
			
		end
		{`IF2, 3'bxxx, 2'bxx, 3'bxxx}: begin
			nextstate = `UPDATEPC;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1;
			mem_cmd = 2'b01;//
			load_ir = 1;
			load_addr = 0;
			addr_sel = 1;
		end
		{`UPDATEPC, 3'bxxx, 2'bxx, 3'bxxx}:begin//output the loadpc
			nextstate = `whether_frozen;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1;
			mem_cmd = 2'b00;//
			load_ir = 0;
			load_addr = 0;
			addr_sel = 0;
			load_pc = 1;
		end
		
		{`whether_frozen, 3'bxxx, 2'bxx, 3'bxxx}:begin//frozen the state
			w = 0;
		    load_pc = 0;
			if(frozen)begin
				nextstate = `whether_frozen_add_data;//if frozen next step
			end
			else begin
				nextstate = `decode_state;//else go to the decode step
			end
		end
		
		{`whether_frozen_add_data, 3'bxxx, 2'bxx, 3'bxxx}:begin//
			controll_the_pc_value_when_frozen = 1;
			nextstate = `finish_load_pc_value;
		end
		{`finish_load_pc_value, 3'bxxx, 2'bxx, 3'bxxx}:begin//
			controll_the_pc_value_when_frozen = 0;
			nextstate = `IF1;
			
		end
		//..........................................................................................................................
	
		
		{`decode_state, 3'b110, 2'b10, 3'bxxx}: begin//seperate into 5 paths 
			load_pc = 0;
			w = 0;
			select_which_pc_signal = 2'b00;
			nextstate = `mov_state;// get the value from another register
		end
		
		{`decode_state, 3'b110, 2'b00, 3'bxxx}: begin
			load_pc = 0;
			w = 0;
			select_which_pc_signal = 2'b00;
			nextstate = `getnumB_state;// get the new value
		end		
		
		{`decode_state, 3'b101, 2'b11, 3'bxxx}: begin
			load_pc = 0;
			w = 0;
			select_which_pc_signal = 2'b00;
			nextstate = `getnumB_state;//get another new value
		end				
		{`decode_state, 3'b111, 2'b00, 3'bxxx}: begin
			load_pc = 0;
			w = 0;
			select_which_pc_signal = 2'b00;
			nextstate = `stop;//halt
		end
		//..........................................................................              tabel            ................................................
		{`decode_state, 3'b001, 2'b00, 3'b000}: begin//when meet 001_00_000 
			w = 0;
			load_pc = 0;
			
			select_which_pc_signal = 2'b01;
			
			nextstate = `pc_plus_1_plus_sximm;
		end
		{`decode_state, 3'b001, 2'b00, 3'b001}: begin//when meet 001_00_001
			w = 0;
			load_pc = 0;
			if(Z == 1)begin
				select_which_pc_signal = 2'b01;
				nextstate = `pc_plus_1_plus_sximm;
			end
			else begin
				select_which_pc_signal = 2'b00;
				nextstate = `IF1;
			end

		end

		{`decode_state, 3'b001, 2'b00, 3'b010}: begin//when meet 001_00_010
			w = 0;
			load_pc = 0;
			if(Z == 0)begin
				select_which_pc_signal = 2'b01;
				nextstate = `pc_plus_1_plus_sximm;
			end
			else begin
				nextstate = `IF1;
				select_which_pc_signal = 2'b00;
			end
			
			
		end

		{`decode_state, 3'b001, 2'b00, 3'b011}: begin//when meet 001_00_011
			w = 0;
			load_pc = 0;
			if(N !== V)begin
				nextstate = `pc_plus_1_plus_sximm;
				select_which_pc_signal = 2'b01;
			end
			else begin
				nextstate = `IF1;
				select_which_pc_signal = 2'b00;
			end

			
		end
		{`decode_state, 3'b001, 2'b00, 3'b100}: begin//when meet 001_00_100
			w = 0;
			load_pc = 0;
			if(N !== V )begin
			
				nextstate = `pc_plus_1_plus_sximm;
				select_which_pc_signal = 2'b01;
				
			end
			else if(Z == 1)begin
				nextstate = `pc_plus_1_plus_sximm;
				select_which_pc_signal = 2'b01;
			end
			else begin
			
				nextstate = `IF1;
				select_which_pc_signal = 2'b00;
				
			end
			
		end
		
		{`pc_plus_1_plus_sximm, 3'b001, 2'b00, 3'bxxx}: begin//
			controll_original_pc = 0;//
			load_pc = 1;
			nextstate = `IF1;
		end
		
		
		
		
		
		
		
		//                                                                                table 2
		
		{`decode_state, 3'b010, 2'bxx, 3'bxxx}: begin//
			load_pc = 0;
			w = 0;
			nextstate = `table_2;
		end
		
		
		//......................................................................................................................................
		
		{`table_2, 3'b010, 2'b11, 3'b111}:begin
			out = 12'b001_01_1_000000;
			nextstate = `save_pc_value;
		end
		
		{`save_pc_value, 3'b010, 2'b11, 3'bxxx}: begin//
			controll_original_pc = 1;
			out = 12'b001_01_1_000000;
			select_which_pc_signal = 2'b01;
			nextstate = `pc_plus_1_plus_sximm;
		end
		
		{`pc_plus_1_plus_sximm, 3'b010, 2'b11, 3'bxxx}: begin//
			controll_original_pc = 0;
			out = 12'b001_01_0_000000;
			load_pc = 1;
			nextstate = `IF1;
		end
		
		
		
		{`table_2, 3'b010, 2'b00, 3'b000}:begin  //RD 01
			controll_original_pc = 0;
			out = 12'b010_00_0_000000;
			select_which_pc_signal = 2'b10;
			nextstate = `pc_plus_1_plus_sximm;
		end
		{`pc_plus_1_plus_sximm, 3'b010, 2'b00, 3'bxxx}: begin//
			controll_original_pc = 0;
			out = 12'b010_00_0_000000;
			load_pc = 1;
			nextstate = `IF1;
		end
		
		
		
		{`table_2, 3'b010, 2'b10, 3'b111}:begin
			out = 12'b001_01_1_000000;
			nextstate = `save_pc_value;
		end
		
		{`save_pc_value, 3'b010, 2'b10, 3'bxxx}: begin//
			controll_original_pc = 1;
			out = 12'b001_01_1_000000;
			select_which_pc_signal = 2'b10;
			nextstate = `BLX_RD;
		end
		{`BLX_RD, 3'b010, 2'b10, 3'bxxx}:begin
			out = 12'b010_01_0_000000;
			controll_original_pc = 0;
			select_which_pc_signal = 2'b10;
			nextstate = `pc_plus_1_plus_sximm;
		end
		
		{`pc_plus_1_plus_sximm, 3'b010, 2'b10, 3'bxxx}: begin//
			controll_original_pc = 0;
			out = 12'b010_01_0_000000;
			load_pc = 1;
			nextstate = `IF1;
		end
		
		
		
		
		//...............................................................................................................................................................
	
		{`decode_state, 3'bxxx, 2'bxx, 3'bxxx}: begin//.................................................................................
			load_pc = 0;
			w = 0;
			nextstate = `getnumA_state;
		end	
		
		{`stop, 3'bxxx, 2'bxx, 3'bxxx}: begin//halt
			nextstate = `stop;
			halt_signal = 1;
			out = 12'b000000000000;
		end	
		
		
		
		{`mov_state, 3'bxxx, 2'bxx, 3'bxxx}: begin//return to IF1
			out = 12'b001_10_1_000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)									
            nextstate = `IF1;
        end
		
		{`getnumA_state, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b001_00_0_100000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1);
            nextstate = `getnumB_state;
        end
		
        {`getnumB_state, 3'b110, 2'b00, 3'bxxx}: begin
			out = 12'b100_00_0_010000;
			nextstate = `shift_state;
		end
		
        {`getnumB_state, 3'b101, 2'b01, 3'bxxx}: begin//compare
			out = 12'b100_00_0_010000;
			nextstate = `minus_operation;
		end		
		
		{`getnumB_state, 3'b101, 2'b10, 3'bxxx}: begin//and
			out = 12'b100_00_0_010000;
			nextstate = `and_operation;
		end
		
		{`getnumB_state, 3'b101, 2'b11, 3'bxxx}: begin//nor
			out = 12'b100_00_0_010000;
			nextstate = `what_operation;
		end
		
		{`getnumB_state, 3'bxxx, 2'bxx, 3'bxxx}: begin// to wait state
			out = 12'b100_00_0_010000;
			nextstate = `hapi;
		end
		
		{`hapi, 3'bxxx, 2'bxx, 3'bxxx}: begin// wait state,change the value of loadb
			nextstate = `add_operation;
			out = 12'b000000001001;
		end
		
		{`add_operation, 3'b011, 2'b00, 3'bxxx}: begin//seperate the LDR and STR and real and process
			out = 12'b000_00_0_000001; // selects A; selects B; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
            load_addr = 1;
			addr_sel = 0;
			load_ir = 0;
			mem_cmd = 2'b00;
			nextstate = `LDR;
		end
		
		{`add_operation, 3'b100, 2'b00, 3'bxxx}: begin
			out = 12'b000_00_0_000001; // selects A; selects B; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
            load_addr = 1;
			addr_sel = 0;
			nextstate = `STR;
		end
		
		{`add_operation, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b000_00_0_001000; // selects A; selects B; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
            load_addr = 1;
			nextstate = `seperate;
			
		end
		{`seperate, 3'b011, 2'b00, 3'bxxx}: begin//the wait state before store state. and sepearte into two paths
			nextstate = `store_state_one;
		end
		{`seperate, 3'b101, 2'b01, 3'bxxx}: begin//the wait state before store state. and sepearte into two paths
		
			nextstate = `IF1;
		end
		
		{`seperate, 3'bxxx, 2'bxx, 3'bxxx}: begin
			nextstate = `store_state_two;
		end
		
        {`store_state_one, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b010_11_1_000000; // 
            nextstate = `IF1;
        end
		
		{`store_state_two, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b010_00_1_000000; // 
            nextstate = `IF1;	
		end
		//....................................................................................
		{`minus_operation, 3'bxxx, 2'bxx, 3'bxxx}: begin//sepearte into two store path, to the wair state
			out = 12'b000000001100;// 
			nextstate = `seperate;
        end
        {`and_operation, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b000000001000; //
            nextstate = `seperate;
        end
		
        {`what_operation, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b000000001010; 
            nextstate = `seperate;
        end
		
        {`shift_state, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b000000001010; // 
			nextstate = `seperate;
		end
		
		{`LDR, 3'bxxx, 2'bxx, 3'bxxx}: begin
			mem_cmd = 2'b01;
			load_addr = 1'b0;
            nextstate = `seperate;    
		end
		
        {`STR, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b010_00_0_010000;
            load_addr = 1'b0;
            nextstate = `STR2;
        end
		
        {`STR2, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b010_00_0_001010;
            nextstate = `STR3;
        end
		
        {`STR3, 3'bxxx, 2'bxx, 3'bxxx}: begin
			out = 12'b010_00_0_001010;
            mem_cmd = 2'b11;
            nextstate = `IF1;
        end
		default: begin
            nextstate = `beginning_state;
        end
		endcase
	end
	currentstate = nextstate;
	end
endmodule
















			
	


