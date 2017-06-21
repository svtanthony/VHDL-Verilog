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
module my_alu #(
	 parameter NUMBITS = 8)
    (input [NUMBITS-1:0] A,
    input [NUMBITS-1:0] B,
    input [2:0] opcode,
    output reg [NUMBITS-1:0] result,
	 output reg carryout,
    output reg overflow,
    output reg zero
    );

reg c_overflow = 1'b0;
reg c_carryout = 1'b0;
reg c_zero = 1'b0;
reg [NUMBITS-1:0] c_result = 1'b0;

//Combinational Part
always @(*) begin

	c_overflow = 1'b0;
	c_carryout = 1'b0;
	c_zero = 1'b0;

	case(opcode)
		3'b000:
		begin
			//unsigned add
			{c_carryout, c_result} = A + B;
			if(c_carryout) 
			begin
				c_overflow = 1'b1;
			end
		end
		3'b001:
		begin
			//signed add
			{c_carryout, c_result} = A + B;
			//if (A[31] == B[31]) & (A[31] != Sum[31])
			if((A[NUMBITS-1] === B[NUMBITS-1]) && (A[NUMBITS-1] !== result[NUMBITS-1]))
			begin
				c_overflow = 1'b1;
			end
		end
		3'b010:
		begin
			//unsigned sub
			{c_carryout,c_result} = A - B;
			c_overflow = ~c_carryout;
		end
		3'b011:
		begin
			//signed sub
			{c_carryout, c_result} = A - B;
			//if (A[31] != B[31]) & (B[31] == Sum[31])
         if((A[NUMBITS-1] !== B[NUMBITS-1]) && (B[NUMBITS-1] === result[NUMBITS-1]))
			begin
				c_overflow = 1'b1;
			end
		end
		3'b100:
		begin
			// A & B
			c_result = A & B;
		end
		3'b101:
		begin
			// A | B
			c_result = A | B;
		end
		3'b110:
		begin
			// A ^ B
			c_result = A ^ B;
		end
		3'b111:
		begin
			// A / 2
			c_result = A >>> 1;
		end
	endcase
	if(!c_result)
	begin
		c_zero = 1'b1;
	end
end

//Sequential Part
always @(posedge clk) begin

	overflow <= c_overflow;
	carryout <= c_carryout;
 	zero <= c_zero;
	result <= c_result;

end

endmodule
