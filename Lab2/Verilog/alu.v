`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:42:33 05/10/2017 
// Design Name: 
// Module Name:    alu 
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
module alu #(
	 parameter NUMBITS = 8)
    (input [NUMBITS-1:0] A,
    input [NUMBITS-1:0] B,
    input [2:0] opcode,
    output reg [NUMBITS-1:0] result,
	 output reg carryout,
    output reg overflow,
    output reg zero
    );
always @(A or B or opcode)
begin
	overflow = 1'b0;
	carryout = 1'b0;
	zero = 1'b0;
	case(opcode)
		3'b000:
		begin
			//unsigned add
			{carryout, result} = A + B;
			if(carryout) 
			begin
				overflow = 1'b1;
			end
		end
		3'b001:
		begin
			//signed add
			{carryout, result} = A + B;
			//if (A[31] == B[31]) & (A[31] != Sum[31])
			if((A[NUMBITS-1] === B[NUMBITS-1]) && (A[NUMBITS-1] !== result[NUMBITS-1]))
			begin
				overflow = 1'b1;
			end
		end
		3'b010:
		begin
			//unsigned sub
			{carryout,result} = A - B;
			overflow = ~carryout;
		end
		3'b011:
		begin
			//signed sub
			{carryout, result} = A - B;
			//if (A[31] != B[31]) & (B[31] == Sum[31])
         if((A[NUMBITS-1] !== B[NUMBITS-1]) && (B[NUMBITS-1] === result[NUMBITS-1]))
			begin
				overflow = 1'b1;
			end
		end
		3'b100:
		begin
			// A & B
			result = A & B;
		end
		3'b101:
		begin
			// A | B
			result = A | B;
		end
		3'b110:
		begin
			// A ^ B
			result = A ^ B;
		end
		3'b111:
		begin
			// A / 2
			result = A >>> 1;
		end
	endcase
	if(!result)
	begin
		zero = 1'b1;
	end
end
endmodule
