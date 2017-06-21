`timescale 1ns / 1ps
//`include "cpu_constant_library.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:39:09 05/12/2017 
// Design Name: 
// Module Name:    control_unit 
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
`define OPCODE_R_TYPE 6'b000000
module control_unit(
    input [5:0] instr_op,
    output reg  reg_dst,
    output reg  branch,
    output reg mem_read,
    output reg  mem_to_reg,
    output reg  [1:0] alu_op,
    output reg  mem_write,
    output reg  alu_src,
    output reg  reg_write
    );
	 
	//CONTROL UNIT Functionality
	always @(instr_op) begin
		case(instr_op)
			6'b000000: begin //R-TYPE instruction
				reg_dst = 1'b1;
				alu_src = 1'b0;
				mem_to_reg = 1'b0;
				reg_write = 1'b1;
				mem_read = 1'b0;
				mem_write = 1'b0;
				branch = 1'b0;
				alu_op = 2'b10;
			end
			6'b100011: begin //Load Word
				reg_dst = 1'b0;
				alu_src = 1'b1;
				mem_to_reg = 1'b1;
				reg_write = 1'b1;
				mem_read = 1'b1;
				mem_write = 1'b0;
				branch = 1'b0;
				alu_op = 2'b00;				
			end
			6'b101011: begin // Store Word
				alu_src = 1'b1;
				reg_write = 1'b0;
				mem_read = 1'b0;
				mem_write = 1'b1;
				branch = 1'b0;
				alu_op = 2'b00;
			end
			6'b000100: begin // Branch
				alu_src = 1'b0;
				reg_write = 1'b0;
				mem_read = 1'b0;
				mem_write = 1'b0;
				branch = 1'b1;
				alu_op = 2'b01;
			end
			6'b001000: begin //Add immediate
				reg_dst = 1'b1;
				alu_src = 1'b1;
				mem_to_reg = 1'b0;
				reg_write = 1'b1;
				mem_read = 1'b0;
				mem_write = 1'b0;
				branch = 1'b0;
				alu_op = 2'b00;
			end
		endcase
	
	end

endmodule
