module LAB1_3 (SW, HEX0, HEX1);
	input [3:0] SW;
	output [6:0] HEX0, HEX1;
	
	two_digit_seg A(SW[3:0], HEX1, HEX0);
endmodule

//display two digit in seg
module two_digit_seg (bcd, seg1, seg0);
	input [3:0] bcd;
	output [6:0] seg1, seg0;
	
	seg_decoder de1(bcd/10, seg1);
	seg_decoder de0(bcd%10, seg0);
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
