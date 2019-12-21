module insdecoder_tb;
 reg [15:0] in;
 reg [2:0] nsel;
 wire [2:0] readnum,writenum,opcode;
 wire [1:0] shift, ALUop,op;
 wire [15:0]sximm5,sximm8;
 wire [41:0]decoder_out;
 decoder DUT(in, nsel, opcode, op, readnum, writenum, shift, sximm8, sximm5, ALUop,decoder_out);
 initial begin 
   in = 16'b0111001011101000;
 nsel = 3'b001;
 #100
 in = 16'b0111001011101000;
 nsel = 3'b010;
 #100
 in = 16'b1000101110000111;
 nsel = 3'b001;
 #100
 in = 16'b1010000101001000;
 nsel = 3'b100;
 #100;
 end
endmodule