`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:39:09 05/18/2017 
// Design Name: 
// Module Name:    CAM_Array 
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
module CAM_Array #(parameter CAM_WIDTH = 8, parameter CAM_DEPTH = 4) (
    input clk,
    input rst,
    input [CAM_DEPTH-1:0] we_decoded_row_address,
    input [CAM_WIDTH-1:0] search_word,
    input [CAM_WIDTH-1:0] dont_care_mask,
    output wire [CAM_DEPTH-1:0] decoded_match_address
    );
	 
	genvar i;
	generate
		for (i=0; i<=CAM_DEPTH-1; i=i+1) begin : rows
			CAM_Row #(.CAM_WIDTH(CAM_WIDTH)) row(
				.clk(clk),
				.rst(rst),
				.we(we_decoded_row_address[i]),
				.search_word(search_word),
				.dont_care_mask(dont_care_mask),
				.row_match(decoded_match_address[i])
			); 
		end 
	endgenerate

endmodule
