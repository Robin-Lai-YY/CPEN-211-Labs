module decoder(in, nsel, opcode, op, readnum, writenum, shift, sximm8, sximm5, ALUop,decoder_out);
	input [15:0]in;
	input [2:0]nsel;
	output [41:0]decoder_out;
	output [2:0]opcode;
	assign opcode = in[15:13];
	
	output [1:0]op;
	assign op = in[12:11];
	
	output [1:0]ALUop;
	assign ALUop = in[12:11];
	
	wire[2:0]Rn; 
	wire[2:0]Rd; 
	wire[2:0]Rm;
	
	assign Rm = in[2:0];
	assign Rd = in[7:5];
	assign Rn = in[10:8]; // read and wirte is ready to select nsel
	
	output reg[2:0]readnum;
	output reg[2:0]writenum;
	
	always @(*) begin
		case(nsel)
			3'b001:{readnum,writenum}={Rn,Rn};
			3'b010:{readnum,writenum}={Rd,Rd};
			3'b100:{readnum,writenum}={Rm,Rm};
			default:{readnum,writenum}={3'bx,3'bx};
		endcase
	end	
	
	output[1:0]shift;
	assign shift = in[4:3];
	
	wire [7:0]imm8;
	assign imm8 = in[7:0];
	output [15:0]sximm8; // to be extended
	extend_sign #(8,8) first(.ex_in(imm8),.ex_out(sximm8));
	
	wire [4:0]imm5;
	assign imm5 = in[4:0];
	output [15:0]sximm5; // to be extended
	extend_sign #(5,11) second(.ex_in(imm5),.ex_out(sximm5));	
	
	assign decoder_out = {ALUop, sximm5, sximm8, shift, readnum, writenum};
	
endmodule


module extend_sign(ex_in,ex_out);
	parameter n=1;
	parameter m = 1;
	
	input [n-1:0]ex_in;
	output reg [15:0]ex_out;
	
	always@(*) begin 
		if(ex_in[n-1])
			ex_out = {{m{1'b1}}, ex_in}; 
		else if(~ex_in[n-1])
			ex_out = {{m{1'b0}}, ex_in}; 
		else
			ex_out = 16'bx;
	end
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	