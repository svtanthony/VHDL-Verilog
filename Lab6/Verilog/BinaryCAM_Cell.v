`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:35:42 05/18/2017 
// Design Name: 
// Module Name:    BinaryCAM_Cell 
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
module BCAM_Cell(
    input clk,
    input rst,
    input we,
    input cell_search_bit,
    input cell_dont_care_bit,
    input cell_match_bit_in,
    output reg cell_match_bit_out
    );
	 
	//stored bit 
	reg curr_bit = 0;

	always @*	begin
		// Write enabled
		if (clk == 1 && we == 1) begin
			curr_bit = cell_search_bit;
		end
		// Search
		else begin
			if((cell_search_bit == curr_bit && cell_match_bit_in == 1))
				cell_match_bit_out = 1;
			else
				cell_match_bit_out = 0;
		end
		// Reset
		if(rst) begin
			curr_bit = 0;
			cell_match_bit_out = 0;
		end
	 end
endmodule
