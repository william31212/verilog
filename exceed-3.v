module test(
  // Clock Input (50 MHz)
  input  CLOCK_50,
  //  Push Buttons
  input  [3:0]  KEY,
  //  DPDT Switches 
  input  [17:0]  SW,
  //  7-SEG Displays
  output  [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
  //  LEDs
  output  [8:0]  LEDG,  //  LED Green[8:0]
  output  [17:0]  LEDR, //  LED Red[17:0]
  output [3:0] result,
  //  GPIO Connections
  inout  [35:0]  GPIO_0, GPIO_1
);
//  set all inout ports to tri-state
	assign  GPIO_0    =  36'hzzzzzzzzz;
	assign  GPIO_1    =  36'hzzzzzzzzz;

// Connect dip switches to red LEDs
	assign LEDR[17:0] = SW[17:0];
	assign LEDR[17]= SW[17];
	assign LEDR[16] = SW[16];
// turn off green LEDs
	assign LEDG[8:0] = 0;

	wire [15:0] A;
// map to 7-segment displays
	plus(A[3], A[2], A[1], A[0], result[3], result[2], result[1], result[0]);
	hex_7seg dsp0(result[3:0],HEX0);//result_bit,HEX[?]
	wire [6:0] blank = ~7'h00; 
	assign HEX1 = blank;
	assign HEX2 = blank;
	assign HEX3 = blank;
	assign HEX4 = blank;
	assign HEX5 = blank;
	assign HEX6 = blank;
	assign HEX7 = blank;

// control (set) value of A, signal with KEY3

//always @(negedge KEY[3])
//    A <= SW[15:0];
	assign A = SW[15:0];
endmodule




module hex_7seg(hex_digit,seg);
	input [3:0] hex_digit;
	output [6:0] seg;
	reg [6:0] seg;

	always @ (hex_digit)
	case (hex_digit)
		4'h0: seg = ~7'h3F;
		4'h1: seg = ~7'h06;     //   ---a----
	        4'h2: seg = ~7'h5B;     // |           |
	        4'h3: seg = ~7'h4F;     // f          b
	        4'h4: seg = ~7'h66;     // |           |
	        4'h5: seg = ~7'h6D;     //  ---g----
	        4'h6: seg = ~7'h7D;     // |           |
	        4'h7: seg = ~7'h07;     // e          c
	        4'h8: seg = ~7'h7F;     // |           |
	        4'h9: seg = ~7'h67;     //   ---d----
		4'hA: seg = ~7'h77;
		4'hC: seg = ~7'h39;
		4'hE: seg = ~7'h79;
		4'hF: seg = ~7'h71;
        endcase
endmodule




module plus(A, B, C, D, X, Y, Z, W);

	input A, B, C, D;
	output X, Y, Z, W;
	
	assign Y = D | C | B | A;
	assign Z = (B & C & D) | (A & C & D) | (A & B & D) | (A & B & C) | (~A & ~B & ~C & ~D);
	assign W = (~A & ~B & ~C & ~D) | (~A & ~B & C & D) | (~A & B & ~C & D) | (~A & B & C & ~D) | (A & ~B & ~C & D) | (A & ~B & C & ~D) | (A & B & ~C & ~D) | (A & B & C & D);
	
endmodule

// 0000 0011
// 0001 0100
// 0010 0100 
// 0011 0101
// 0100 0100

// 0101 0101
// 0110 0101
// 0111 0110
// 1000 0100
// 1001 0101

// 1010 0101
// 1011 0110
// 1100 0101
// 1101 0110
// 1110 0110

// 1111 0111


// 0011 0
// 0100 1
// 0101 2
// 0110 3
// 0111 4
