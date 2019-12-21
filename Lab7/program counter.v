module program_counter(clk, load_pc, reset_pc, pc_out);
	input clk;
	input load_pc;
	input reset_pc;
	output [8:0] pc_out;
	
	reg [8:0]next_pc;
	
	vDFF #(9) program_counter(clk, load_pc, next_pc, pc_out);
	
	always @(*) begin 
		case(reset_pc)
			1'b1: next_pc = 9'b0;
			1'b0: next_pc = pc_out + 1;
			default: next_pc = 9'bx;
		endcase
	end 
 
endmodule

module vDFF(clk, load, next, out);
	parameter k = 1;
	input clk;
	input load;
	input [k-1:0]next;
	output reg [k-1:0]out;
	
	always@(posedge clk) begin
		out = load? next:out;
	end
endmodule