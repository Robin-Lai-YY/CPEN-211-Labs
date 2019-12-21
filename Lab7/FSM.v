
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

module SM(opcode, op, reset, clk, s, out, w, mem_cmd, addr_sel, load_pc, reset_pc, load_addr, load_ir);

	input [2:0] opcode;
	input [1:0] op;
	input reset;
	input clk;
	input s;
	
	output reg [11:0] out;
	output reg w;
	output reg [1:0] mem_cmd;
	output reg addr_sel;
	output reg load_pc;
	output reg reset_pc;
	output reg load_addr;
	output reg load_ir;
	
		
	
	
	reg  [4:0]currentstate;
	reg  [4:0]nextstate;
	

	always @(posedge clk) begin
	
	if(reset) begin
		nextstate = `beginning_state;
        reset_pc = 1;
        load_pc = 1;
		out = 12'b000000000000;//nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
	end
	else begin
		casex ({currentstate, opcode, op}) 
		
		{`beginning_state, 3'bxxx, 2'bxx}: begin
			nextstate = `IF1;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1'b1;
			mem_cmd = 2'b00;
			load_ir = 0;
			load_addr = 0;
			addr_sel = 0;
			reset_pc = 1;
			load_pc = 1;
		end
		{`IF1, 3'bxxx, 2'bxx}: begin
			nextstate = `IF2;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1'b1;
			mem_cmd = 2'b01;//
			load_ir = 0;//
			load_addr = 0;
			addr_sel = 1;
			reset_pc = 0;
			load_pc = 0;
		end
		{`IF2, 3'bxxx, 2'bxx}: begin
			nextstate = `UPDATEPC;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1;
			mem_cmd = 2'b01;//
			load_ir = 1;
			load_addr = 0;
			addr_sel = 1;
		end
		{`UPDATEPC, 3'bxxx, 2'bxx}:begin//output the loadpc
			nextstate = `decode_state;
			out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
			w = 1;
			mem_cmd = 2'b00;//
			load_ir = 0;
			load_addr = 0;
			addr_sel = 0;
			load_pc = 1;
			
		end
		
		{`decode_state, 3'b110, 2'b10}: begin//seperate into 5 paths 
			load_pc = 0;
			w = 0;
			nextstate = `mov_state;// get the value from another register
		end
		
		{`decode_state, 3'b110, 2'b00}: begin
			load_pc = 0;
			w = 0;
			nextstate = `getnumB_state;// get the new value
		end		
		
		{`decode_state, 3'b101, 2'b11}: begin
			load_pc = 0;
			w = 0;
			nextstate = `getnumB_state;//get another new value
		end				
		{`decode_state, 3'b111, 2'b00}: begin
			load_pc = 0;
			w = 0;
			nextstate = `stop;//half
		end
		{`decode_state, 3'bxxx, 2'bxx}: begin//.................................................................................
			load_pc = 0;
			w = 0;
			nextstate = `getnumA_state;
		end	
		
		{`stop, 3'bxxx, 2'bxx}: begin//half
			nextstate = `stop;
			out = 12'b000000000000;
		end	
		{`mov_state, 3'bxxx, 2'bxx}: begin//return to IF1
			out = 12'b001_10_1_000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)									
            nextstate = `IF1;
        end
		
		{`getnumA_state, 3'bxxx, 2'bxx}: begin
			out = 12'b001_00_0_100000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1);
            nextstate = `getnumB_state;
        end
		
        {`getnumB_state, 3'b110, 2'b00}: begin
			out = 12'b100_00_0_010000;
			nextstate = `shift_state;
		end
		
        {`getnumB_state, 3'b101, 2'b01}: begin//compare
			out = 12'b100_00_0_010000;
			nextstate = `minus_operation;
		end		
		
		{`getnumB_state, 3'b101, 2'b10}: begin//and
			out = 12'b100_00_0_010000;
			nextstate = `and_operation;
		end
		
		{`getnumB_state, 3'b101, 2'b11}: begin//nor
			out = 12'b100_00_0_010000;
			nextstate = `what_operation;
		end
		
		{`getnumB_state, 3'bxxx, 2'bxx}: begin// to wait state
			out = 12'b100_00_0_010000;
			nextstate = `hapi;
		end
		
		{`hapi, 3'bxxx, 2'bxx}: begin// wait state,change the value of loadb
			nextstate = `add_operation;
			out = 12'b000000001001;
		end
		
		{`add_operation, 3'b011, 2'b00}: begin//seperate the LDR and STR and real and process
			out = 12'b000_00_0_000001; // selects A; selects B; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
            load_addr = 1;
			addr_sel = 0;
			load_ir = 0;
			mem_cmd = 2'b00;
			nextstate = `LDR;
		end
		
		{`add_operation, 3'b100, 2'b00}: begin
			out = 12'b000_00_0_000001; // selects A; selects B; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
            load_addr = 1;
			addr_sel = 0;
			nextstate = `STR;
		end
		
		{`add_operation, 3'bxxx, 2'bxx}: begin
			out = 12'b000_00_0_001000; // selects A; selects B; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
            load_addr = 1;
			nextstate = `seperate;
			
		end
		{`seperate, 3'b011, 2'b00}: begin//the wait state before store state. and sepearte into two paths
			nextstate = `store_state_one;
		end
		
		{`seperate, 3'bxxx, 2'bxx}: begin
			nextstate = `store_state_two;
		end
		
        {`store_state_one, 3'bxxx, 2'bxx}: begin
			out = 12'b010_11_1_000000; // 
            nextstate = `IF1;
        end
		
		{`store_state_two, 3'bxxx, 2'bxx}: begin
			out = 12'b010_00_1_000000; // 
            nextstate = `IF1;	
		end
		//....................................................................................
		{`minus_operation, 3'bxxx, 2'bxx}: begin//sepearte into two store path, to the wair state
			out = 12'b000000001100;// 
			nextstate = `seperate;
        end
        {`and_operation, 3'bxxx, 2'bxx}: begin
			out = 12'b000000001000; //
            nextstate = `seperate;
        end
		
        {`what_operation, 3'bxxx, 2'bxx}: begin
			out = 12'b000000001010; 
            nextstate = `seperate;
        end
		
        {`shift_state, 3'bxxx, 2'bxx}: begin
			out = 12'b000000001010; // 
			nextstate = `seperate;
		end
		
		{`LDR, 3'bxxx, 2'bxx}: begin
			mem_cmd = 2'b01;
			load_addr = 1'b0;
            nextstate = `seperate;    
		end
		
        {`STR, 3'bxxx, 2'bxx}: begin
			out = 12'b010_00_0_010000;
            load_addr = 1'b0;
            nextstate = `STR2;
        end
		
        {`STR2, 3'bxxx, 2'bxx}: begin
			out = 12'b010_00_0_001010;
            nextstate = `STR3;
        end
		
        {`STR3, 3'bxxx, 2'bxx}: begin
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
















			
	

