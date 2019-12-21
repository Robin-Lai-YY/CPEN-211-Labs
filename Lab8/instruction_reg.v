module instruction_reg(in, reg_out, load, clk);
	input [15:0]in;
	input load;
	output reg[15:0]reg_out;
	input clk;
	always @(posedge clk) begin 
		if(load == 1'b1)
			reg_out <= in;
		else
			reg_out <= reg_out;
	end
endmodule