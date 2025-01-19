module LAB1_4 (SW, LEDR);
	input [9:0] SW;
	output [4:0] LEDR;
	
	full_adder FA(SW[3:0], SW[7:4], SW[9], LEDR[4], LEDR[3:0]);
endmodule

//4bit full adder
module full_adder (a, b, c_in, c_out, sum);
	input c_in;
	input [3:0] a, b;
	output c_out;
	output [3:0] sum;
	
	assign {c_out, sum} = a + b + c_in;
endmodule
