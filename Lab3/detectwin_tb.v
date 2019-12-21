module detectwin_tb;
	reg [8:0] ain, bin;
	wire [7:0] win_line;
	DetectWinner DUT(ain,bin,win_line);
	
initial begin
	ain = 9'b000_000_000;
	bin = 9'b000_000_000; //initialized
	
	//a wins
	
	ain = 9'b111_000_000; //test when the first row are all occupied by a
	bin = 9'b000_000_000;
	#10; // 100 units of time delay, same as below
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_111_000; //test when the second row are all occupied by a
	bin = 9'b000_000_000;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_111; //test when the third row are all occupied by a
	bin = 9'b000_000_000;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	
	ain = 9'b100_100_100; //test when the first column are all accupied by a
	bin = 9'b000_000_000;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b010_010_010; //test when the second column are all accupied by a
	bin = 9'b000_000_000;
	#10; 
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b001_001_001; //test when the third column are all accupied by a
	bin = 9'b000_000_000;
	#10; 
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b100_010_001; //test when the left to right diagonal are all accupied by a
	bin = 9'b000_000_000;
	#10; 
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b001_010_100; //test when the right to left diagonal are all accupied by a
	bin = 9'b000_000_000;
	#10; 
	$display("%b %b --> %b",ain, bin, win_line);
	
	//b wins
	
	ain = 9'b000_000_000; //test when the first row are all occupied by b
	bin = 9'b111_000_000;
	#10; 
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_000; //test when the second row are all occupied by b
	bin = 9'b000_111_000;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_000; //test when the third row are all occupied by b
	bin = 9'b000_000_111;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	
	ain = 9'b000_000_000; //test when the first column are all accupied by b
	bin = 9'b100_100_100;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_000; //test when the second column are all accupied by b
	bin = 9'b010_010_010;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_000; //test when the third column are all accupied by b
	bin = 9'b001_001_001;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_000; //test when the left to right diagonal are all accupied by b
	bin = 9'b100_010_001;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b000_000_000; //test when the right to left diagonal are all accupied by b
	bin = 9'b001_010_100;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
		
	//Draw
	ain = 9'b110_001_101; //no winner 1
	bin = 9'b001_110_010;
	#10; 
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b011_110_001; //no winner 2
	bin = 9'b100_001_110;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b101_011_010; //no winner 3
	bin = 9'b010_100_101;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b011_100_011; //no winner 4
	bin = 9'b100_011_100;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
	
	ain = 9'b010_110_101; //no winner 5
	bin = 9'b101_001_010;
	#10;
	$display("%b %b --> %b",ain, bin, win_line);
		
	
	end


endmodule 