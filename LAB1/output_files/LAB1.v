module LAB1 (SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
	input [8:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	reg [9:0] LEDR;
	wire [3:0] sum;
	wire [4:0] result;
	wire c_out;
	
	//display A and B in seg
	two_digit_seg A(SW[7:4], HEX3, HEX2);
	two_digit_seg B(SW[3:0], HEX1, HEX0);
	
	//display sum result in seg
	full_adder FA(SW[7:4], SW[3:0], SW[8], c_out, sum);
	assign result = {c_out, sum};
	two_digit_seg result_de(result, HEX5, HEX4);
	
	//LEDR9 turn on when A or B is greater than 9
	always @(*) begin
		if(SW[7:4] > 9 || SW[3:0] > 9) begin
			LEDR[9] = 1'b1;
		end
		else begin
			LEDR[9] = 1'b0;
		end
	end
	
endmodule

//bcd to seg
module seg_decoder (bcd, seg);
	input [3:0] bcd;
	output [6:0] seg;
	reg [6:0] seg;
	
	always @(bcd) begin
		case (bcd)
			0 : seg = 7'b1000000;
			1 : seg = 7'b1111001;
			2 : seg = 7'b0100100;
			3 : seg = 7'b0110000;
			4 : seg = 7'b0011001;
			5 : seg = 7'b0010010;
			6 : seg = 7'b0000010;
			7 : seg = 7'b1111000;
			8 : seg = 7'b0000000;
			9 : seg = 7'b0010000;
			//lights out
			default : seg = 7'b1111111;
		endcase
	end
endmodule

//display two digit in seg
module two_digit_seg (bcd, seg1, seg0);
	input [4:0] bcd;
	output [6:0] seg1, seg0;
	
	seg_decoder de1(bcd/10, seg1);
	seg_decoder de0(bcd%10, seg0);
endmodule

//4bit full adder
module full_adder (a, b, c_in, c_out, sum);
	input c_in;
	input [3:0] a, b;
	output c_out;
	output [3:0] sum;
	
	assign {c_out, sum} = a + b + c_in;
endmodule
