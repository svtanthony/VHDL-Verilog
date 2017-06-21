--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:05:54 05/12/2017
-- Design Name:   
-- Module Name:   /home/dan/Xilinx/labs/lab4/main_tb.vhd
-- Project Name:  lab4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: main
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY main_tb IS
END main_tb;
 
ARCHITECTURE behavior OF main_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT main
    PORT(
         functionfield : IN  std_logic_vector(5 downto 0);
         instr_op_main : IN  std_logic_vector(5 downto 0);
         reg_dst : OUT  std_logic;
         branch : OUT  std_logic;
         mem_read : OUT  std_logic;
         mem_to_reg : OUT  std_logic;
         alu_output : OUT  std_logic_vector(3 downto 0);
         mem_write : OUT  std_logic;
         alu_src : OUT  std_logic;
         reg_write : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal functionfield : std_logic_vector(5 downto 0) := (others => '0');
   signal instr_op_main : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal reg_dst : std_logic;
   signal branch : std_logic;
   signal mem_read : std_logic;
   signal mem_to_reg : std_logic;
   signal alu_output : std_logic_vector(3 downto 0);
   signal mem_write : std_logic;
   signal alu_src : std_logic;
   signal reg_write : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main PORT MAP (
          functionfield => functionfield,
          instr_op_main => instr_op_main,
          reg_dst => reg_dst,
          branch => branch,
          mem_read => mem_read,
          mem_to_reg => mem_to_reg,
          alu_output => alu_output,
          mem_write => mem_write,
          alu_src => alu_src,
          reg_write => reg_write
        );

   -- Clock process definitions
   --<clock>_process :process
   --begin
	--	<clock> <= '0';
	--	wait for <clock>_period/2;
	--	<clock> <= '1';
	--	wait for <clock>_period/2;
   --end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

     -- wait for <clock>_period*10;

      -- insert stimulus here 
		---------------------------------------
		report "Testing r-type instructions";
		instr_op_main <= "000000";
		---------------------------------------
		
		-- Test 1 (Add instruction)

		functionfield <= "100000";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 1 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 1 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 1 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 1 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 1 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 1 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 1 fail - branch" severity Warning;
		assert alu_output = "0010" report "Test 1 fail - alu_out" severity Warning;
	
		-- Test 2 (Subtract)
		functionfield <= "100010";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 2 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 2 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 2 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 2 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 2 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 2 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 2 fail - branch" severity Warning;
		assert alu_output = "0110" report "Test 2 fail - alu_out" severity Warning;
		
		-- Test 3 (AND)
		functionfield <= "100100";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 3 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 3 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 3 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 3 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 3 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 3 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 3 fail - branch" severity Warning;
		assert alu_output = "0000" report "Test 3 fail - alu_out" severity Warning;
		
		-- Test 4 (OR)
		functionfield <= "100101";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 4 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 4 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 4 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 4 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 4 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 4 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 4 fail - branch" severity Warning;
		assert alu_output = "0001" report "Test 4 fail - alu_out" severity Warning;
		
		-- Test 5 (set on less than)
		functionfield <= "101010";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 5 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 5 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 5 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 5 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 5 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 5 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 5 fail - branch" severity Warning;
		assert alu_output = "0111" report "Test 5 fail - alu_out" severity Warning;
		
		-- Test 6 (NOR)
		functionfield <= "100111";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 6 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 6 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 6 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 6 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 6 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 6 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 6 fail - branch" severity Warning;
		assert alu_output = "1100" report "Test 6 fail - alu_out" severity Warning;

		---------------------------------------
		report "Testing load/store instructions";
		---------------------------------------
		
		-- Test 7 - (load word)
		instr_op_main <= "100011";
		wait for 10 ns;
		assert reg_dst = '0' 		report "Test 7 fail - reg_dst" severity Warning;
		assert alu_src = '1' 		report "Test 7 fail - alu_src" severity Warning;
		assert mem_to_reg = '1' 	report "Test 7 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 7 fail - reg_write" severity Warning;
		assert mem_read = '1' 		report "Test 7 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 7 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 7 fail - branch" severity Warning;
		assert alu_output = "0010" report "Test 7 fail - alu_out" severity Warning;
		
		-- Test 8 - (store word)
		instr_op_main <= "101011";
		wait for 10 ns;
		--assert reg_dst = '0' 		report "Test 8 fail - reg_dst" severity Warning;
		assert alu_src = '1' 		report "Test 8 fail - alu_src" severity Warning;
		--assert mem_to_reg = '1' 	report "Test 8 fail - mem_to_reg" severity Warning;
		assert reg_write = '0' 		report "Test 8 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 8 fail - mem_read" severity Warning;
		assert mem_write = '1' 		report "Test 8 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 8 fail - branch" severity Warning;
		assert alu_output = "0010" report "Test 8 fail - alu_out" severity Warning;
		
		------------------------------------
		report "Testing beq instruction";
		------------------------------------
		
		-- Test 9 - (branch equals)
		instr_op_main <= "000100";
		wait for 10 ns;
		--assert reg_dst = '0' 		report "Test 9 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 9 fail - alu_src" severity Warning;
		--assert mem_to_reg = '1' 	report "Test 9 fail - mem_to_reg" severity Warning;
		assert reg_write = '0' 		report "Test 9 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 9 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 9 fail - mem_write" severity Warning;
		assert branch = '1' 			report "Test 9 fail - branch" severity Warning;
		assert alu_output = "0110" report "Test 9 fail - alu_out" severity Warning;
		
		------------------------------------
		report "Testing add unsigned instruction";
		------------------------------------
		
		-- Test 10 - (add unsigned)
		instr_op_main <= "000000";
		functionfield <= "100001";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 10 fail - reg_dst" severity Warning;
		assert alu_src = '0' 		report "Test 10 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 10 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 10 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 10 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 10 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 10 fail - branch" severity Warning;
		assert alu_output = "0010" report "Test 10 fail - alu_out" severity Warning;
		
		------------------------------------
		report "Testing add immediate instruction";
		------------------------------------
		
		-- Test 11 - (add immediate)
		instr_op_main <= "001000";
		wait for 10 ns;
		assert reg_dst = '1' 		report "Test 11 fail - reg_dst" severity Warning;
		assert alu_src = '1' 		report "Test 11 fail - alu_src" severity Warning;
		assert mem_to_reg = '0' 	report "Test 11 fail - mem_to_reg" severity Warning;
		assert reg_write = '1' 		report "Test 11 fail - reg_write" severity Warning;
		assert mem_read = '0' 		report "Test 11 fail - mem_read" severity Warning;
		assert mem_write = '0' 		report "Test 11 fail - mem_write" severity Warning;
		assert branch = '0' 			report "Test 11 fail - branch" severity Warning;
		assert alu_output = "0010" report "Test 11 fail - alu_out" severity Warning;
		
      wait;
   end process;

END;
