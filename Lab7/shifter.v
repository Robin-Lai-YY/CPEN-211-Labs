module shifter(in, shift, sout);
	parameter n = 16;
	input [n-1:0] in;
	input [1:0] shift;
	output reg [n-1:0] sout;

	always@(*) begin 
	if(shift == 2'b00) 
		sout = in;
	else if(shift == 2'b01)
		sout = in << 1;
	else if(shift == 2'b10) begin
		sout = in >> 1;
		sout[n-1] = 0;	
		end
	else begin
		sout = in >> 1;
		sout[n-1] = in[n-1];
		end
	end
endmodule