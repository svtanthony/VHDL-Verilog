`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:59 05/11/2017 
// Design Name: 
// Module Name:    my_alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module my_alu #(parameter NUMBITS = 32)(
    input [NUMBITS-1:0] A,
    input [NUMBITS-1:0] B,
    input [3:0] Opcode,
    output Carry_out,
    output Overflow,
    output Zero,
    output [NUMBITS+3:0] Result
    );
	 

	 //variable declarations
	 wire [NUMBITS-1:0] bin_A;
	 wire [NUMBITS-1:0] bin_B;
	 reg [2:0] new_op;
	 wire [NUMBITS-1:0] bin_result;
	 wire temp_carryout;
	 
	 
	 //compomponent instantiation and connections
	 alu #(.NUMBITS(NUMBITS)) binALU(
		.A(bin_A), 
		.B(bin_B), 
		.opcode(new_op), 
		.result(bin_result), 
		.carryout(temp_carryout), 
		.overflow(Overflow), 
		.zero(Zero)
	);
	
	bcd_2_bin #(.N(NUMBITS)) bcdA(
		.A(A),
		.sign(Opcode[2]),
		.result(bin_A)
	);
	
	bcd_2_bin #(.N(NUMBITS)) bcdB(
		.A(B),
		.sign(Opcode[2]),
		.result(bin_B)
	);
	
	bin_2_bcd #(.N(NUMBITS)) bin2BCD(
		.A(bin_result),
		.sign(Opcode[2]),
		.carry(Carry_out),
		.result(Result)
    );
    	
		
	 //BCD ALU Functionality
	always @(Opcode) begin
		case(Opcode)
			4'b1000: new_op = 3'b000;
			4'b1001: new_op = 3'b010;
			4'b1100: new_op = 3'b001;
			4'b1101: new_op = 3'b011;
			default: new_op = 3'b000;
		endcase
	end

endmodule
