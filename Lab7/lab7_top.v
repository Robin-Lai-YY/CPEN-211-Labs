`define MWRITE 2'b11
`define MREAD 2'b01


module lab7_top(KEY, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	wire clk, reset, s;
	
	assign clk = ~KEY[0];
	assign reset = ~KEY[1]; 
	
	wire [15:0]read_data;
	
	wire N, V, Z, w;
	
	wire [8:0]select_out;
	wire [1:0]mem_cmd;
	
	
	wire [15:0]sximm5;
	wire [15:0]sximm8;
	wire [7:0] PC; // will be change in future
	wire [15:0]mdata; // will be change in future
	
	wire [15:0]write_data;
	
	wire Z_out;	
	
	wire [41:0]from_decoder;
	wire [11:0]from_SM;
	
	wire write;
	
	wire [15:0]dout;
	
	cpu CPU(clk, reset, s, read_data, N, V, Z, w, select_out, mem_cmd, write_data);	
	
	wire write_process_out1;
	wire write_process_out2;
	
	equal #(2) write_process1(`MWRITE, mem_cmd, write_process_out1); //equal
	equal #(1) write_process2(1'b0, select_out[8:8], write_process_out2);
	assign write = write_process_out1 & write_process_out2;
	
	wire dout_process_out1;
	wire dout_process_out2;
	wire after_AND_dout;
	equal #(2) dout1 (`MREAD, mem_cmd, dout_process_out1);
	equal #(1) dout2 (1'b0, select_out[8], dout_process_out2);
	assign 	after_AND_dout = dout_process_out1 & dout_process_out2;
	
	//assign mdata = read_data;
	
	RAM #(16, 8, "figure8.txt") MEM(clk,select_out[7:0],select_out[7:0],write,write_data,dout);
	
	assign read_data = after_AND_dout ? dout : 16'bz;
	
	assign LEDR[9] = w;
	DTCLED one(clk, mem_cmd, select_out, LEDR[7:0], write_data); //control LED
		
	
	
	DTCSWITCH second (mem_cmd, select_out, SW[7:0], read_data); // control Switch
endmodule	


module DTCSWITCH(mem_cmd, mem_addr, dtcswitch_out, read_data);
	input [1:0] mem_cmd;
	input [8:0] mem_addr;
	input [7:0] dtcswitch_out;
	output reg [15:0] read_data;
	reg out;
	
	always@(*) begin
		if((mem_addr == 9'b101000000) & `MREAD == 2'b01)
		out = 1'b1;
		else
		out = 1'b0;
		
	read_data[15:8] = out? 8'b0 : 8'bz;
	read_data[7:0] = out? dtcswitch_out[7:0] : 8'bz;
	end	
endmodule

module DTCLED(clk, mem_cmd, mem_addr, LEDR, write_data);
	input clk;
	input [1:0] mem_cmd;
	input [8:0] mem_addr;
	input [15:0] write_data;
	output reg [7:0] LEDR;
	reg out;
	
	always@(*) begin
		if((`MWRITE == 2'b11) & (9'b100000000== mem_addr))
			out = 1'b1;
		else 
			out = 1'b0;
	end
	
	always@(posedge clk) begin 
		LEDR[7:0] = out ? write_data[7:0] : LEDR[7:0];
	end	
endmodule



module equal(in1, in2, out);
	parameter k=1;	
	input [k-1:0]in1;
	input [k-1:0]in2;
	output reg out;
	
	always@(*) begin 
	if(in1 == in2)
		out = 1;
	else
		out = 0;
	end
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	



