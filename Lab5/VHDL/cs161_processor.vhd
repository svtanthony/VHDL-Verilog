library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.cpu_component_library.all;

entity cs161_processor is
  port (
  
	 -- INPUTS
    clk            : in std_logic;
    rst            : in std_logic;
    -- OUTPUTS
    prog_count     : out std_logic_vector(31 downto 0);
    instr_opcode   : out std_logic_vector(5 downto 0);
    reg1_addr      : out std_logic_vector(4 downto 0);
    reg1_data      : out std_logic_vector(31 downto 0);
    reg2_addr      : out std_logic_vector(4 downto 0);
    reg2_data      : out std_logic_vector(31 downto 0);
    write_reg_addr : out std_logic_vector(4 downto 0);
    write_reg_data : out std_logic_vector(31 downto 0)
    );
end cs161_processor;

architecture Behavioral of cs161_processor is

	signal PC_out 			:std_logic_vector(31 downto 0) :=(others => '0');
	signal MEM_im_out 	:std_logic_vector(31 downto 0) :=(others => '0'); 
	signal MEM_read 		:std_logic_vector(31 downto 0) := (others => '0');
	signal MEM_write 		:std_logic_vector(31 downto 0) := (others => '0');
	signal MUX_pcIn 		:std_logic_vector(31 downto 0) :=(others => '0');
	signal MUX_writeReg 	:std_logic_vector(4 downto 0) := (others => '0');
	signal MUX_writeData :std_logic_vector (31 downto 0) := (others => '0');
	signal MUX_aluIn 		:std_logic_vector (31 downto 0) := (others => '0');
	signal REG_readData1	:std_logic_vector (31 downto 0) := (others => '0');
	signal REG_readData2	:std_logic_vector (31 downto 0) := (others => '0');
	signal CTRL_write 	:std_logic := '0';
	signal CTRL_regWrite	:std_logic := '0';
	signal CTRL_regDest 	:std_logic := '0';
	signal CTRL_mem2Reg  :std_logic := '0';
	signal CTRL_aluSrc	:std_logic := '0';
	signal CTRL_branch	:std_logic := '0';
	signal CTRL_aluOp		:std_logic_vector(1 downto 0) := (others => '0');
	signal ALUC_out		:std_logic_vector(3 downto 0) := (others => '0');
	signal ALU_result 	:std_logic_vector(31 downto 0) := (others => '0');
	signal ALU_zero		:std_logic := '0';
	signal ground 			:std_logic := '0';
	signal TEMP_aluMux	:std_logic_vector(31 downto 0) := (others => '0');
	signal TEMP_pcMux_s	:std_logic := '0';
	signal TEMP_pcMux_d0	:std_logic_vector(31 downto 0) := (others => '0');
	signal TEMP_pcMux_d1	:std_logic_vector(31 downto 0) := (others => '0');
	signal TEMP_data_addr :std_logic_vector(31 downto 0) := (others => '0');

begin

	-- debug output signals of main entity
	prog_count 		<= PC_out;
	instr_opcode 	<= MEM_im_out(31 downto 26);
	reg1_addr      <= MEM_im_out(25 downto 21);
   reg1_data      <= REG_readData1;
   reg2_addr      <= MEM_im_out(20 downto 16);
   reg2_data      <= REG_readData2;
   write_reg_addr <= MUX_writeReg;
   write_reg_data <= MUX_writeData;
	
	
	Program_Counter : generic_register
		generic map (SIZE => 32)
		port map (
			clk			=>	clk, 
			rst			=> rst,  
			write_en		=> '1', 
			data_in		=> MUX_pcIn, 
			data_out		=> PC_out
			);
			
	MEMORY_UNIT : memory
		generic map ( COE_FILE_NAME => "init2.coe")
		port map(
			clk 						=> clk,
			rst  						=> rst,
			instr_read_address   => PC_out(9 downto 2), -- Current = 8 bit addressing -> PC and memory is word addressible so only 8 bits needed for 255 word memory
			instr_instruction    => MEM_im_out, 	 
			data_mem_write       => CTRL_write,
			data_address         => ALU_result(7 downto 0), -- from ALU **256 word file size.
			data_write_data      => REG_readData2,
			data_read_data       => MEM_read
			);
	 
	REGISTERS : cpu_registers
		port map(
			clk						=> clk,
			rst						=> rst,
			reg_write				=> CTRL_regWrite,
			read_register_1		=> MEM_im_out(25 downto 21),
			read_register_2   	=> MEM_im_out(20 downto 16),
			write_register			=> MUX_writeReg,
			write_data				=> MUX_writeData,
			read_data_1				=> REG_readData1,
			read_data_2				=> REG_readData2
			);
	 
	REG_MUX_1 : mux_2_1 
		generic map (SIZE => 5)
		port map(
			select_in					=> CTRL_regDest,
			data_0_in					=> MEM_im_out(20 downto 16),
			data_1_in					=> MEM_im_out(15 downto 11),
			data_out						=> MUX_writeReg
			);
	 
	REG_MUX_2 : mux_2_1
		generic map (SIZE => 32)
		port map(
			select_in				=> CTRL_mem2Reg,
			data_0_in				=> ALU_result,
			data_1_in				=> MEM_read,
			data_out					=> MUX_writeData
			);
	 
	ALU_MUX : mux_2_1 
		generic map (SIZE => 32)
		port map(
			select_in				=> CTRL_aluSrc,
			data_0_in				=> REG_readData2,
			data_1_in				=> TEMP_aluMux,
			data_out					=> MUX_aluIn
			);
	
	PC_MUX : mux_2_1
		generic map (SIZE => 32)
		port map(
			select_in				=> TEMP_pcMux_s,
			data_0_in				=> TEMP_pcMux_d0,
			data_1_in				=> TEMP_pcMux_d1,
			data_out					=> MUX_pcIn
			);
	 
	CTRL: control_unit
		port map(
			instr_op					=> MEM_im_out(31 downto 26),
			reg_dst					=> CTRL_regDest,
			branch					=> CTRL_branch,
			mem_read					=> ground, -- ground - Memory doesn't use mem_read , it reads when not writing
			mem_to_reg				=> CTRL_mem2Reg,
			alu_op					=> CTRL_aluOp,
			mem_write				=> CTRL_write,
			alu_src					=> CTRL_aluSrc,
			reg_write				=> CTRL_regWrite
			);

	ALU_CTRL : alu_control
		port map(
			alu_op					=> CTRL_aluOp,
			instruction_5_0		=> MEM_im_out(5 downto 0),
			alu_out					=> ALUC_out
			);

	ALU_UNIT: alu 
		port map(
			alu_control_in 		=> ALUC_out,
			channel_a_in   		=> REG_readData1,
			channel_b_in   		=> MUX_aluIn,
			zero_out       		=> ALU_zero,
			alu_result_out 		=> ALU_result
			);
			
	TEMP_aluMux		<= std_logic_vector(resize(signed(MEM_im_out(15 downto 0)), MUX_aluIn'length));--sign extend Instr(15 - 0)
	TEMP_pcMux_s	<= (CTRL_branch and ALU_zero);
	TEMP_pcMux_d0	<= std_logic_vector(unsigned(PC_out) + 4);
	TEMP_pcMux_d1	<= std_logic_vector(unsigned( resize(signed(MEM_im_out(15 downto 0)), MUX_pcIn'length) sll 2) + unsigned(PC_out) + 4);-- [(pcOut + 4) + SE(IM_mem)<<2]

end Behavioral;

