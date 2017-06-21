`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:20:04 05/12/2017 
// Design Name: 
// Module Name:    alu_control 
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
module alu_control(
    input [1:0] alu_op,
    input [5:0] instruction_5_0,
    output reg [3:0] alu_out
    );
	 
	 //ALU CONTROL UNIT Functionality
	always @(alu_op or instruction_5_0) begin
		case(alu_op)
			2'b00: alu_out = 4'b0010;//LOAD/STORE
			2'b01: alu_out = 4'b0110;//BRANCH
			2'b10: case(instruction_5_0)//R_TYPE
					6'b100000: alu_out = 4'b0010; //ADD
					6'b100010: alu_out = 4'b0110; //SUB
					6'b100100: alu_out = 4'b0000; //AND
					6'b100101: alu_out = 4'b0001; //OR
					6'b101010: alu_out = 4'b0111; //SLT
					6'b100111: alu_out = 4'b1100; //NOR
					6'b100001: alu_out = 4'b0010; //ADD UNSIGNED
					default: alu_out = 4'bxxxx;
				endcase
		endcase
	end


endmodule
