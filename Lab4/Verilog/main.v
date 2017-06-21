`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:47:32 05/12/2017 
// Design Name: 
// Module Name:    main 
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
module main(
    input [5:0] functionfield,
    input [5:0] instr_op_main,
    output reg_dst,
    output branch,
    output mem_read,
    output mem_to_reg,
    output [3:0] alu_output,
    output mem_write,
    output alu_src,
    output reg_write
    );
		
    //variable declarations
	 wire [1:0] temp_alu_op;
	 
	 
	 //compomponent instantiation and connections
	 control_unit C_UNIT(
		   .instr_op(instr_op_main),
			.reg_dst(reg_dst),
			.branch(branch),
			.mem_read(mem_read),
			.mem_to_reg(mem_to_reg),
			.alu_op(temp_alu_op),
			.mem_write(mem_write),
			.alu_src(alu_src),
			.reg_write(reg_write)
    );
		
	alu_control ALU_UNIT(
		.alu_op(temp_alu_op),
		.instruction_5_0(functionfield),
		.alu_out(alu_output)
	);
	
	//MAIN Functionality
	always @* begin
		//
	end

endmodule
