module LAB1_1 (SW, LEDR);
	input [9:0] SW;
	output [3:0] LEDR;
	
	multiplexer_2to1 mux(SW[3:0], SW[7:4], SW[9], LEDR[3:0]);
endmodule

module multiplexer_2to1 (x, y, s, led);
	input [3:0] x, y;
	input s;
	output [3:0] led;
	
	assign led[3:0] = {{~{4{s}}}&x}|{{4{s}}&y};
endmodule
