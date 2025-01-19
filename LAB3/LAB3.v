module LAB3 (KEY, SW, LEDR, HEX3, HEX2, HEX1, HEX0);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:9] LEDR;
	output [6:0] HEX3, HEX2, HEX1, HEX0;
	reg [7:0] A, B, C, D;
	wire [15:0] resultAB, resultCD, sum;
	reg [15:0] num_display;
	
	//sum = (A x B) + (C x D)
	mult AB(.dataa(A), .datab(B), .result(resultAB));
	mult CD(.dataa(C), .datab(D), .result(resultCD));
	add ABCD(.dataa(resultAB), .datab(resultCD), .cout(LEDR), .result(sum));
	//display {A,B}, {C,D} or sum
	four_digit_seg display(num_display, HEX3, HEX2, HEX1, HEX0);
	
	//KEY[1] is manual input clock, KEY[0] is active-low asynchronous reset
	always @(posedge KEY[1] or negedge KEY[0]) begin
		if(~KEY[0]) begin
			A = 0;
			B = 0;
			C = 0;
			D = 0;
		end
		else begin
			//SW[9] is write enable
			if(SW[9] == 1) begin
				//SW[8] decides A&B or C&D
				if(SW[8] == 1) begin
					//KEY[2] decides A&C or B&D
					if(KEY[2] == 1) begin
						A = SW[7:0];
					end
					else begin
						B = SW[7:0];
					end
				end
				else begin
					if(KEY[2] == 1) begin
						C = SW[7:0];
					end
					else begin
						D = SW[7:0];
					end
				end
			end
		end
	end
	
	//KEY[3]&SW[8] decides display
	always @(*) begin
		if(KEY[3] == 0) begin
			num_display = sum;
		end
		else begin
			if(SW[8] == 1) begin
				num_display = {A, B};
			end
			else begin
				num_display = {C, D};
			end
		end
	end
	
endmodule

//bch to seg
module seg_decoder (bch, seg);
	input [3:0] bch;
	output [6:0] seg;
	reg [6:0] seg;
	
	always @(bch) begin
		case (bch)
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
			10 : seg = 7'b0001000;	//A
			11 : seg = 7'b0000011;	//b
			12 : seg = 7'b1000110;	//C
			13 : seg = 7'b0100001;	//d
			14 : seg = 7'b0000110;	//E
			15 : seg = 7'b0001110;	//F
			//lights out
			default : seg = 7'b1111111;
		endcase
	end
endmodule

//display four digit in seg
module four_digit_seg (num, seg3, seg2, seg1, seg0);
	input [15:0] num;
	output [6:0] seg3, seg2, seg1, seg0;
	
	seg_decoder de3(num[15:12], seg3);
	seg_decoder de2(num[11:8], seg2);
	seg_decoder de1(num[7:4], seg1);
	seg_decoder de0(num[3:0], seg0);
endmodule
