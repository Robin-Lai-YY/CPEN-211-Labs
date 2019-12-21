`define num1 7'b0110000 //3 
`define num2 7'b1111000 //7 	
`define num3 7'b0100100 //2 
`define num4 7'b0011001 //4 
`define num5 7'b0000010 //6 
`define clk ~KEY[0]
`define reset ~KEY[1]   // reset button 
`define dir SW[0]       //change direction


module lab4_top(SW,KEY,HEX0);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0;  
  
  // put your state machine code here!
  
  reg [6:0] HEX0;
  reg [6:0] present_state;  
  
  always @(posedge `clk or posedge `reset) begin //When the KEY[0] and [1] are pressed, start!
  //Reference: Slide Set 5 from Dr.Tor
    if (KEY[1] == 0) begin //check the reset condition
       present_state = `num1;
		 HEX0 = `num1;
    end else begin //
       case (present_state)  // assign values
         `num1: if (`dir == 0) 
                  present_state = `num5;
               else 
                  present_state = `num2;
			`num2: if (`dir == 0)
                  present_state = `num1;
               else
                  present_state = `num3;
         `num3: if (`dir == 0) 
                  present_state = `num2;
               else
                  present_state = `num4;
         `num4: if (`dir == 0) 
                  present_state = `num3;
               else
                  present_state = `num5;
			`num5: if (`dir == 0) 
                  present_state = `num4;
               else
                  present_state = `num1;
           default: present_state = 7'bxxxxxxx; 
        endcase
		  
		case (present_state) // print the vaule to HEX according to the value of present_state
           `num1: HEX0 = `num1;
           `num2: HEX0 = `num2;
           `num3: HEX0 = `num3;
           `num4: HEX0 = `num4;
			  `num5: HEX0 = `num5;
            default: HEX0 = 7'bxxxxxxx;
        endcase
		  
		end
	end	
  
endmodule
