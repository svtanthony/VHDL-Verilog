`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:08:44 05/18/2017 
// Design Name: 
// Module Name:    CAM_Row 
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
module CAM_Row #(parameter CAM_WIDTH = 8) (
    input clk,
    input rst,
    input we,
    input [CAM_WIDTH-1:0] search_word,
    input [CAM_WIDTH-1:0] dont_care_mask,
    output reg row_match
    );
	 
	 wire [CAM_WIDTH-1:0] match_vector;
	 
	 // Compoenent instantiation - match_bit_in = true
	 TCAM_Cell intial_cell(
		.clk(clk),
		.rst(rst),
		.we(we),
		.cell_search_bit(search_word[0]),
		.cell_dont_care_bit(dont_care_mask[0]),
		.cell_match_bit_in(1'b1),
		.cell_match_bit_out(match_vector[0])
	);
	
	// Compoenent instantiation - match_bit_in = previous
	genvar i;
	generate
		for (i=1; i<=CAM_WIDTH-1; i=i+1) begin : cells
			TCAM_Cell(
				.clk(clk),
				.rst(rst),
				.we(we),
				.cell_search_bit(search_word[i]),
				.cell_dont_care_bit(dont_care_mask[i]),
				.cell_match_bit_in(match_vector[i-1]),
				.cell_match_bit_out(match_vector[i])
			); 
	 
		end 
	endgenerate

	always @* begin
		row_match = match_vector[CAM_WIDTH-1];
	end

endmodule
