module LAB2 (SW, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input CLOCK_50;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [5:0] sec;
	wire [7:0] hour, min;
	
	timer Timer (CLOCK_50, SW[8], SW[9], SW[7:0], hour, min, sec);
	
	two_digit_seg sec_display(sec, HEX1, HEX0);
	two_digit_seg min_display(min, HEX3, HEX2);
	two_digit_seg hour_display(hour, HEX5, HEX4);
endmodule

module timer (clk, set, select, setting_time, hour, min, sec);
	input clk, set, select;
	input [7:0] setting_time;
	output [7:0] hour, min;
	output [5:0] sec;
	reg [7:0] hour, min;
	reg [5:0] sec;
	reg [25:0] sec_count;
	integer flag = 0;	//for the purpose of posedge of set

	always @(posedge clk) begin
		//clock 00:00:00 ~ 23:59:59
		if(sec_count >= 50000000) begin
			sec_count = 0;
			sec = sec + 1;
			if(sec >= 60) begin
				sec = 0;
				min = min + 1;
				if(min >= 60) begin
					min = 0;
					hour = hour + 1;
					if(hour >= 24) begin
						hour = 0;
						min = 0;
						sec = 0;
					end
				end
			end
		end
		else begin
			sec_count = sec_count + 1;
		end
		//set hour or min
		if(set == 1) begin
			if(flag == 0) begin
				flag = 1;
				if(select == 1) begin
					//setting hour time must be less than 24
					if(setting_time > 23)
						hour = 23;
					else begin
						hour = setting_time;
					end
				end
				else begin
					//setting minute time must be less than 60
					if(setting_time > 59)
						min = 59;
					else begin
						min = setting_time;
					end
				end
			end
		end
		else begin
			flag = 0;
		end
	end
endmodule

//bcd to seg
module seg_decoder (bcd, seg);
	input [7:0] bcd;
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
	input [7:0] bcd;
	output [6:0] seg1, seg0;
	
	seg_decoder de1(bcd/10, seg1);
	seg_decoder de0(bcd%10, seg0);
endmodule