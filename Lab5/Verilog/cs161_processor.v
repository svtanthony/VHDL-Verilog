`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:51:50 05/13/2017 
// Design Name: 
// Module Name:    cs161_processor 
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
module cs161_processor(
    input clk,
    input rst,
    output [31:0] prog_count,
    output [5:0] instr_opcode,
    output [4:0] reg1_addr,
    output [31:0] reg1_data,
    output [4:0] reg2_addr,
    output [31:0] reg2_data,
    output [4:0] write_reg_addr,
    output [31:0] write_reg_data
    );
	 
	 //COMPONENT_conectionName -- Copmponent interconections --
	 wire [31:0] PC_out;
	 wire [31:0] MEM_im_out;
    wire [31:0] MEM_read;
    wire [31:0] MEM_write;
    wire [31:0] MUX_pcIn;
    wire [4:0] MUX_writeReg;
    wire [31:0] MUX_writeData;
    wire [31:0] MUX_aluIn;
    wire [31:0] REG_readData1;
    wire [31:0] REG_readData2;
    wire CTRL_write;
    wire CTRL_regWrite;
    wire CTRL_regDest;
    wire CTRL_mem2Reg;
    wire CTRL_aluSrc;
    wire CTRL_branch;
    wire [1:0] CTRL_aluOp;
    wire [3:0] ALUC_out;
    wire [31:0] ALU_result;
    wire ALU_zero;
    wire ground;
    wire [31:0] TEMP_aluMux;
    wire TEMP_pcMux_s;
    wire [31:0] TEMP_pcMux_d0;
    wire [31:0] TEMP_pcMux_d1;
    wire [31:0] TEMP_data_addr;
	 
	 
    //Assigning connections
	 assign prog_count = PC_out;
	 assign instr_opcode = MEM_im_out[31:26];
	 assign reg1_addr = MEM_im_out[25:21];
	 assign reg1_data = REG_readData1;
	 assign reg2_addr = MEM_im_out[20:16];
	 assign reg2_data = REG_readData2;
	 assign write_reg_addr = MUX_writeReg;
	 assign write_reg_data = MUX_writeData;
	 
	 //NOTE: Temporary value(toFrom) with [sll,and,adder,sign extend]
	 assign TEMP_aluMux = {{16{MEM_im_out[15]}},MEM_im_out[15:0]};//signed extend MEM_im_out[15]
	 assign TEMP_pcMux_s = (CTRL_branch & ALU_zero);//and 
	 assign TEMP_pcMux_d0 = (PC_out + 4);//adder
	 assign TEMP_pcMux_d1 = (({{16{MEM_im_out[15]}},MEM_im_out[15:0]}<<2) + PC_out + 4);//SE,+,+
	 
	 // Component instantiation
	 generic_register #(.SIZE(32)) Program_Counter(
		.clk(clk),
		.rst(rst),
		.write_en(1'b1),
		.data_in(MUX_pcIn),
		.data_out(PC_out)
	);
	
	 memory #(.COE_FILE_NAME("init2.coe")) MEMORY_UNIT(
		.clk(clk),
		.rst(rst),
		.instr_read_address(PC_out[9:2]),
		.instr_instruction(MEM_im_out),
		.data_mem_write(CTRL_write),
		.data_address(ALU_result[7:0]),
		.data_write_data(REG_readData2),
		.data_read_data(MEM_read)
	);
	
	cpu_registers REGISTERS(
		.clk(clk),
		.rst(rst),
		.reg_write(CTRL_regWrite),
		.read_register_1(MEM_im_out[25:21]),
		.read_register_2(MEM_im_out[20:16]),
		.write_register(MUX_writeReg),
		.write_data(MUX_writeData),
		.read_data_1(REG_readData1),
		.read_data_2(REG_readData2)
	);
	
	mux_2_1 #(.SIZE(5)) REG_MUX_1(
		.select_in(CTRL_regDest),
		.data_0_in(MEM_im_out[20:16]),
		.data_1_in(MEM_im_out[15:11]),
		.data_out(MUX_writeReg)
	);
	
	mux_2_1 #(.SIZE(32)) REG_MUX_2(
		.select_in(CTRL_mem2Reg),
		.data_0_in(ALU_result),
		.data_1_in(MEM_read),
		.data_out(MUX_writeData)
	);
	
	mux_2_1 #(.SIZE(32)) ALU_MUX(
		.select_in(CTRL_aluSrc),
		.data_0_in(REG_readData2),
		.data_1_in(TEMP_aluMux),
		.data_out(MUX_aluIn)
	);
	
	mux_2_1 #(.SIZE(32)) PC_MUX(
		.select_in(TEMP_pcMux_s),
		.data_0_in(TEMP_pcMux_d0),
		.data_1_in(TEMP_pcMux_d1),
		.data_out(MUX_pcIn)
	);
	
	control_unit CTRL(
		.instr_op(MEM_im_out[31:26]),
		.reg_dst(CTRL_regDest),
		.branch(CTRL_branch),
		.mem_read(ground),
		.mem_to_reg(CTRL_mem2Reg),
		.alu_op(CTRL_aluOp),
		.mem_write(CTRL_write),
		.alu_src(CTRL_aluSrc),
		.reg_write(CTRL_regWrite)
	);
	
	alu_control ALU_CTRL(
		.alu_op(CTRL_aluOp),
		.instruction_5_0(MEM_im_out[5:0]),
		.alu_out(ALUC_out)
	);
	
	alu ALU_UNIT(
		.alu_control_in(ALUC_out),
		.channel_a_in(REG_readData1),
		.channel_b_in(MUX_aluIn),
		.zero_out(ALU_zero),
		.alu_result_out(ALU_result)
	);
	
endmodule
