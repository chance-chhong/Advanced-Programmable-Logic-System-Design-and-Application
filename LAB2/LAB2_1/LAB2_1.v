module LAB2_1 (KEY, SW, HEX3, HEX2, HEX1, HEX0);
	input [3:0] KEY;
	input [9:0] SW;
	output [6:0] HEX3, HEX2, HEX1, HEX0;
	wire [15:0] num;
	
	//counter Counter(KEY[0], SW[1], SW[0], num);
endmodule

module counter (clk, en, reset, num);
	input clk, en, reset;
	output [15:0] num;
	
endmodule

module D_FF (D, clk, Q, QB);
	input D, clk;
	output reg Q, QB;
	
	always @(posedge clk) begin
		Q = D;
		QB = ~D;
	end
endmodule

module T_FF (T, clk, Q, QB);
	input T, clk;
	output Q, QB;
	
	D_FF dff((~T&Q)|(T&QB), clk, Q, QB);
endmodule
