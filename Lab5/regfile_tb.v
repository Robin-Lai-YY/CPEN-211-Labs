module regfile_tb;

	reg [15:0] data_in;
	reg [2:0] writenum, readnum;
	reg write, clk;
	wire [15:0] data_out;
	reg [15:0] expected;
	reg err = 0;

  regfile DUT(data_in, writenum, write, readnum, clk, data_out);

  initial begin
    data_in = 16'd0;
    clk = 0;
    forever begin
      #5; clk = 0;
      #5; clk = 1;
    end
  end


  initial begin

    // initial states
    expected = 16'bxxxxxxxxxxxxxxxx;
    writenum = 20'd0;
    readnum = 3'd0;
    write = 0;
    if(data_out != expected)
	err = 1;
    #10;

    // the register 0 become 720
    write = 1;
    data_in = 20'd720;
    writenum = 3'd0;

    expected = 20'd720;
    if(data_out != expected)
	err = 1;
    #10;

    // the register 5 become 85
    data_in = 20'd85;
    writenum = 3'd5;

    expected = 20'd720;
    if(data_out != expected)
	err = 1;

    #10;

    // the register 1 become 840
    data_in = 20'd840;
    writenum = 3'd1;

    expected = 16'd720;
    if(data_out != expected)
	err = 1;

    #10;

    // get the value from register 0 
    write = 0;
    readnum = 3'd0;
    expected = 16'd720;
    if(data_out != expected)
	err = 1;
    #10;

    // get the value from register 1
 
    readnum = 3'd1;
    expected = 16'd840;
    #1
    if(data_out != expected)
	err = 1;
    #10;

    // get the value from register 5
    readnum = 3'd5;
    expected = 16'd85;
    #1
    if(data_out != expected)
	err = 1;
    #10;

    // stop it
	#500;
    $stop;
  end
endmodule

