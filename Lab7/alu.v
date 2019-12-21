module ALU(Ain, Bin, ALUop, out, Z);
	parameter k = 16;
	input[k-1:0] Ain, Bin;
	input[1:0] ALUop;
	output reg[k-1:0] out;
	output reg Z;
	
	always@(*) begin 
		case(ALUop)
			2'b00: out = Ain + Bin;
			2'b01: out = Ain - Bin;
			2'b10: out = Ain & Bin;
			2'b11: out = ~Bin;
		default: out = 16'bx;
		endcase	
	end
	
	always@(*) begin
	if(out == 0)
	Z = 1;
	else
	Z = 0;
	end
	
endmodule 
