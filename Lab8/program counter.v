module program_counter(clk, load_pc, reset_pc, pc_out, select_which_pc_signal, sximm8,controll_original_pc, controll_the_pc_value_when_frozen);
 input clk;
 input load_pc;
 input reset_pc;
 input [1:0]select_which_pc_signal;
 input [15:0]sximm8;
 input controll_original_pc;
 input controll_the_pc_value_when_frozen;
 
 
 
 
 wire [8:0] register_pc;
 
 vDFF #(9) register_pc_out(clk, controll_original_pc, pc_out, register_pc);
 
 
 wire [8:0] the_pc_value_while_frozen;
 vDFF #(9) frozen_pc_value(clk, controll_the_pc_value_when_frozen, pc_out, the_pc_value_while_frozen);
 
 
 output [8:0] pc_out;
 
 
 reg [8:0]new_pc;
 wire [8:0]next_pc;
 
 always@(*) begin
  case(select_which_pc_signal)
   2'b00:new_pc = pc_out + 1'b1;
   2'b01:new_pc = pc_out + sximm8;
   2'b10:new_pc = register_pc;
   2'b11:new_pc = the_pc_value_while_frozen;
   default: new_pc = 9'bx;
  endcase
 end
 
 assign next_pc = reset_pc ? 9'b0 : new_pc;
 vDFF #(9) program_counter(clk, load_pc, next_pc, pc_out);
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