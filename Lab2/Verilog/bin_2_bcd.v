`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:20:25 05/11/2017 
// Design Name: 
// Module Name:    bin_2_bcd 
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
module bin_2_bcd #(parameter N = 8)(
    input [N-1:0] A,
    input sign,
    output reg carry,
    output reg [N+3:0] result
    );

always @(A or sign)
begin : convert
	//temp variables
	reg [N+3:0] result_temp;
	reg [N-1:0] A_temp;
	reg [3:0] column;
	reg [N-1:0] i, j;
	
	A_temp = A;
	result_temp = 0;
	
	if(sign == 1 && A[N-1] == 1) A_temp = -1*A; 

	
	for(i = 0;i < N;i=i+1) begin
		for(j =0;j < (N+4)/4;j=j+1) begin 
			column = result_temp[j*4+3-:4];
			if (column > 4)
			begin
				column = column + 3;
				result_temp[j*4+3-:4] = column;
			end
		end
		result_temp = result_temp <<< 1;
		result_temp[0] = A_temp[N-1-i]; 
	end


	if (sign) begin
		carry = (result_temp[N-1-:4] > 0)? 1: 0;
		if(A[N-1] == 1) result_temp[N+3-:4] = 4'b1;///////////////
	end
	else begin
		carry = (result_temp[N-1-:4] > 0)? 1: 0 ;
	end
	result = result_temp;

end
endmodule
