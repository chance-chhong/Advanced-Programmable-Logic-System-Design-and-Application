module LAB6 (KEY, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	input [2:0] KEY;
	output reg [7:0] LEDR;
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	wire [4:0] addr;
	wire [7:0] instruction, R1, R0;
	
	rom1 ROM(
		.address(addr),
		.clock(~KEY[1]),
		.q(instruction));
	
	always @(posedge ~KEY[2]) begin
		LEDR = instruction;
	end
	
	Program_Counter PC(~KEY[1], KEY[0], addr);
	Processor Proc(instruction, KEY[0], ~KEY[2], R1, R0);
	two_digit_seg R0_display(R0, HEX3, HEX2);
	two_digit_seg R1_display(R1, HEX1, HEX0);
	two_digit_seg instruction_display(instruction, HEX5, HEX4);
	
endmodule

module Program_Counter (clk, Resetn, address);
	input clk, Resetn;
	output reg [4:0] address;
	
	always @(posedge clk or negedge Resetn) begin
		if(~Resetn) begin
			address = 0;
		end
		else begin
			if(address >= 32) begin
				address = 0;
			end
			else begin
				address = address + 1;
			end
		end
	end
endmodule

module Processor (DIN, Resetn, clk, R1, R0);
	input [7:0] DIN;
	input Resetn, clk;
	output [7:0] R1, R0;
	reg [7:0] register[0:7];
	reg flag = 0;
	reg [2:0] index;
	integer i;
	parameter mv = 2'b00, mvi = 2'b01, add = 2'b10, sub = 2'b11;
	
	assign R0 = register[0];
	assign R1 = register[1];
	
	always @(posedge clk or negedge Resetn) begin
		if(~Resetn) begin
			for(i = 0; i < 8; i = i + 1)
				register[i] <= 0;
		end
		else begin
			if(flag) begin
				register[index] = DIN;
				flag = 0;
			end
			else begin
				case (DIN[7:6])
					mv:
					begin
						register[DIN[5:3]] = register[DIN[2:0]];
						flag = 0;
					end
					mvi:
					begin
						index = DIN[5:3];
						flag = 1;
					end
					add:
					begin
						register[DIN[5:3]] = register[DIN[5:3]] + register[DIN[2:0]];
						flag = 0;
					end
					sub:
					begin
						register[DIN[5:3]] = register[DIN[5:3]] - register[DIN[2:0]];
						flag = 0;
					end
				endcase
			end
		end
	end
endmodule

//bch to seg
module seg_decoder (bch, seg);
	input [3:0] bch;
	output reg [6:0] seg;
	
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

//display two digit in seg
module two_digit_seg (num, seg1, seg0);
	input [7:0] num;
	output [6:0] seg1, seg0;
	
	seg_decoder de1(num[7:4], seg1);
	seg_decoder de0(num[3:0], seg0);
endmodule

