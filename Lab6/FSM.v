
`define beginning_state 4'b0000
`define decode_state 4'b0001
`define mov_state 4'b0010
`define getnumA_state 4'b0011
`define getnumB_state 4'b0100
`define shift_state 4'b0101
`define add_operation 4'b0110
`define minus_operation 4'b0111
`define and_operation 4'b1000
`define what_operation 4'b1001
`define store_state 4'b1010

module SM(opcode, op, reset, clk, s, out, w);

	input [2:0] opcode;
	input [1:0] op;
	input reset;
	input clk;
	input s;
	
	output reg [11:0] out;
	output reg w;
	
	
	reg  [3:0]currentstate;
	reg  [3:0]nextstate;
	

	always @(posedge clk) begin
    if (reset) begin
      currentstate = `beginning_state;
      nextstate = `beginning_state;
      out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
      w = 1'b1;
    end
    else begin
      case (currentstate)
        `beginning_state: if (s) begin
                nextstate = `decode_state;
				out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
                w = 1'b0;
               end
               else begin
                 nextstate = `beginning_state;
				 out = 12'b000000000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
                 w = 1'b1;
               end
        `decode_state: begin
                   if ({opcode,op} == 5'b11010) begin // Move immediate
                     nextstate = `mov_state;
                   end
                   else if (({opcode,op} == 5'b11000) | ({opcode,op} == 5'b10111)) begin // Move number shift  or make the number negative
                     nextstate = `getnumB_state;
                   end
                   else begin // Add, compare or and
                      nextstate = `getnumA_state;
                   end
                 end
        `mov_state: begin
					out = 12'b001_10_1_000000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
												// selects Rn as register to write in ; selects sximm8 as data_in to calculate
                     nextstate = `beginning_state;
                  end
        `getnumA_state: begin
				out = 12'b001_00_0_100000;	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1); selects Rn register
                 nextstate = `getnumB_state;
               end
        `getnumB_state: begin
				out = 12'b100_00_0_010000;   	  //nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1); selects Rm register

                 if ({opcode,op} == 5'b10100) begin // add two number together
                   nextstate = `add_operation;
                 end
                 else if ({opcode,op} == 5'b10101) begin // compare
                   nextstate = `minus_operation;
                 end
                 else if ({opcode,op} == 5'b10110) begin // use add operation
                   nextstate = `and_operation;
                 end
                 else if ({opcode,op} == 5'b10111) begin //  negative
                   nextstate = `what_operation;
                 end
                 else begin // move shifted
                   nextstate = `shift_state;
                 end
               end
        `add_operation: begin
				out = 12'b000000001000; // selects A use the data in A register; selects B use the data in B register; nsel(3),vsel(2),write(1),loada(1),loadb(1),loadc(1),loads(1),asel(1),bsel(1)
                nextstate = `store_state;
              end
        `minus_operation: begin
				out = 12'b000000001100;// selects A use the data in A register; selects B use the data in B register; output status
                nextstate = `store_state;
              end
        `and_operation: begin
				out = 12'b000000001000; // selects A use the data in A register; selects B use the data in B register
                nextstate = `store_state;
              end
        `what_operation: begin
				out = 12'b000000001010; // selects zero; selects B use the data in B register
                nextstate = `store_state;
              end
        `shift_state: begin
				out = 12'b000000001010; // selects zero; selects B use the data in B register
                nextstate = `store_state;
                end
        `store_state: begin
				out = 12'b010001000000; // selects Rd; selects C to write the result
                     nextstate = `beginning_state;
                   end
         default: begin
                  currentstate = `beginning_state;
                  nextstate = `beginning_state;
                  end
      endcase
    end
    currentstate = nextstate;
  end
	

endmodule

	
	




			
	

