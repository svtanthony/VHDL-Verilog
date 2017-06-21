`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:45:28 05/11/2017 
// Design Name: 
// Module Name:    bcd_2_bin 
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
module bcd_2_bin #(parameter N = 8)(
    input [N-1:0] A,
    input sign,
    output reg [N-1:0] result
    );
	 
always @(A or sign)
begin : convert
	//temp variables
	reg [N-1:0] bin_A;
	reg [N-1:0] int_A;
	reg [N-1:0] i, j, power;
	
	bin_A = 0;
	power = 1;
	int_A = 0;
	
	if(sign == 0) begin
		for(i = 0;i <= N/4-1;i=i+1) begin
			int_A = int_A + power*A[i*4+3-:4];
			power = power*10;
		end
	end
	else begin
		for(i = 0;i <= N/4-2;i=i+1) begin
			int_A = int_A + power*A[i*4+3-:4];
			power = power*10;
		end
		if(A[N-4] == 1) int_A = -1*int_A;
	end
	result = int_A;
end
endmodule
