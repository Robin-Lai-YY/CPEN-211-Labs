module regfile(data_in,writenum,write,readnum,clk,data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;


// fill out the rest

//first we need to make a decoder 3:8
    	wire [7:0] decoder_for_input;
	Dec  #(3, 8) done(writenum, decoder_for_input);


//when the write button open, the number of box need to be make sure.

	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	
	wire [7:0] through_write_button;


	assign through_write_button[0] = write & decoder_for_input[0];
	assign through_write_button[1] = write & decoder_for_input[1];
	assign through_write_button[2] = write & decoder_for_input[2];
	assign through_write_button[3] = write & decoder_for_input[3];
	assign through_write_button[4] = write & decoder_for_input[4];
	assign through_write_button[5] = write & decoder_for_input[5];
	assign through_write_button[6] = write & decoder_for_input[6];
	assign through_write_button[7] = write & decoder_for_input[7];

		
	vDFFE  bo0(clk, through_write_button[0], data_in, R0);
	vDFFE  bo1(clk, through_write_button[1], data_in, R1);
	vDFFE  bo2(clk, through_write_button[2], data_in, R2);
	vDFFE  bo3(clk, through_write_button[3], data_in, R3);
	vDFFE  bo4(clk, through_write_button[4], data_in, R4);
	vDFFE  bo5(clk, through_write_button[5], data_in, R5);
	vDFFE  bo6(clk, through_write_button[6], data_in, R6);
	vDFFE  bo7(clk, through_write_button[7], data_in, R7);




//deal the signal from the readnum. change it from three bit to eight bit to decide which box we need to open
	
	wire [7:0] decoder_for_output;
	Dec  #(3, 8) dtwo(readnum, decoder_for_output);

//最后决定输出哪个box的。

	Mux1 nitamad(R0, R1, R2, R3, R4, R5, R6, R7, decoder_for_output, data_out);


endmodule




module Dec(a, b);
	parameter n = 3;
	parameter m = 8;

	input  [n-1:0] a;
	output [m-1:0] b;


	wire   [m-1:0]  b = 1 << a;
endmodule





module vDFFE(clk, en, in, out);
  	parameter n = 16;  
  	input clk, en ;
  	input  [n-1:0] in ;
  	output [n-1:0] out ;
 	reg    [n-1:0] out ;
  	wire   [n-1:0] next_out ;

  	assign next_out = en ? in : out;

  	always @(posedge clk)
    		out = next_out;  
endmodule


module Mux1(box0, box1, box2, box3, box4, box5, box6, box7, s, b);
	parameter k = 16;
	input [k - 1:0] box0, box1, box2, box3, box4, box5, box6, box7;
	input [7:0] s;
	output reg [k - 1:0] b;

	always @(*) begin
		case(s)
			8'b00000001: b = box0;
			8'b00000010: b = box1;
			8'b00000100: b = box2;
			8'b00001000: b = box3;
			8'b00010000: b = box4;
			8'b00100000: b = box5;
			8'b01000000: b = box6;
			8'b10000000: b = box7;
			default: b = 16'bxxxxxxxxxxxxxxxx;
		endcase
	end
endmodule