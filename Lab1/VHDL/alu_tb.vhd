--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:42:27 01/15/2016
-- Design Name:   
-- Module Name:   /home/csmajs/rpasi001/cs161/lab1/alu_tb.vhd
-- Project Name:  my_alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: my_alu
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
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT my_alu
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         opcode : IN  std_logic_vector(2 downto 0);
         result : OUT  std_logic_vector(7 downto 0);
         carryout : OUT  std_logic;
         overflow : OUT  std_logic;
         zero : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal opcode : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal result : std_logic_vector(7 downto 0);
   signal carryout : std_logic;
   signal overflow : std_logic;
   signal zero : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
	signal clock : std_logic;
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: my_alu PORT MAP (
          A => A,
          B => B,
          opcode => opcode,
          result => result,
          carryout => carryout,
          overflow => overflow,
          zero => zero
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		A <= (others => '0');
		B <= (others => '0');
		opcode <= (others => '0');
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      -- insert stimulus here
		
		-- Test for bitwise AND 1
		opcode <= "100";
		A <= "00000001";
		B <= "00000000";
		wait for clock_period;
		Assert(result = "00000000" and zero = '1' and carryout = '0' and overflow = '0')
			Report "Error at AND 1"
			Severity ERROR;
		wait for clock_period;

		-- Test for bitwise AND 2
		opcode <= "100";
		A <= "00000001";
		B <= "00000001";
		wait for clock_period;
		Assert(result = "00000001" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at AND 2"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for bitwise AND 3
		opcode <= "100";
		A <= "10101111";
		B <= "11110101";
		wait for clock_period;
		Assert(result = "10100101" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at AND 3"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for bitwise OR 1
		opcode <= "101";
		A <= "10101111";
		B <= "11110101";
		wait for clock_period;
		Assert(result = "11111111" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at OR 1"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for bitwise XOR 1
		opcode <= "110";
		A <= "10101111";
		B <= "11110101";
		wait for clock_period;
		Assert(result = "01011010" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at XOR 1"
			Severity ERROR;
		wait for clock_period;
		
				
		-- Test for DIV 1
		opcode <= "111";
		A <= "00011000";
		B <= "00000000";
		wait for clock_period;
		Assert(result = "00001100" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at DIV 1"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for unsigned add 1
		opcode <= "000";
		A <= "00001111";
		B <= "00000001";
		wait for clock_period;
		Assert(result = "00010000" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at unsigned add 1"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for unsigned add - 255 + 1
		opcode <= "000";
		A <= "11111111";
		B <= "00000001";
		wait for clock_period;
		Assert(result = "00000000" and zero = '1' and carryout = '1' and overflow = '1')
			Report "Error at unsigned add - zero carry over "
			Severity ERROR;
		wait for clock_period;
		
		-- Test for unsigned add - 255 + 2
		opcode <= "000";
		A <= "11111111";
		B <= "00000010";
		wait for clock_period;
		Assert(result = "00000001" and zero = '0' and carryout = '1' and overflow = '1')
			Report "Error at unsigned add - Carry & Overflow"
			Severity ERROR;
		wait for clock_period;

		-- Test for signed add - basic
		opcode <= "001";
		A <= "00000001";
		B <= "00000010";
		wait for clock_period;
		Assert(result = "00000011" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at signed add - Carry & Overflow"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for signed add - -1 + 2
		opcode <= "001";
		A <= "11111111";
		B <= "00000010";
		wait for clock_period;
		Assert(result = "00000001" and zero = '0' and carryout = '1' and overflow = '0')
			Report "Error at signed add - (-1) + 2"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for signed add - 1 + (-2)
		opcode <= "001";
		A <= "00000001";
		B <= "11111110"; 
		wait for clock_period;
		Assert(result = "11111111" and zero = '0' and carryout = '0' and overflow = '0')
			Report "Error at signed add - 1+(-2)"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for signed add - 127 + 1
		opcode <= "001";
		A <= "00000001";
		B <= "01111111"; 
		wait for clock_period;
		Assert(result = "10000000" and zero = '0' and carryout = '0' and overflow = '1')
			Report "Error at signed add - 127+1"
			Severity ERROR;
		wait for clock_period;
		
		-- Test for signed sub -> 127 - (-2)
		opcode <= "011";
		A <= "01111111";
		B <= "11111110"; 
		wait for clock_period;
		Assert(zero = '0' and carryout = '0' and overflow = '1')
			Report "Error at signed sub - 127 - (-2)"
			Severity ERROR;
		wait for clock_period;		
		
		-- Test for signed sub -> -128 - 1
		opcode <= "011";
		A <= "10000000";
		B <= "00000001"; 
		wait for clock_period;
		Assert(zero = '0' and carryout = '1' and overflow = '1')
			Report "Error at signed sub -> -128 - 1"
			Severity ERROR;
		wait for clock_period;	
		
		-- Test for signed sub -> 9 - 3
		opcode <= "011";
		A <= "00001001";
		B <= "00000011"; 
		wait for clock_period;
		Assert(result = "00000110" and zero = '0' and carryout = '1' and overflow = '0')
			Report "Error at signed sub 9 - 3"
			Severity ERROR;
		wait for clock_period;			
		
		-- Test for signed sub -> 127 - (-128)
		opcode <= "011";
		A <= "01111111";
		B <= "10000000"; 
		wait for clock_period;
		Assert(zero = '0' and carryout = '0' and overflow = '1')
			Report "Error at signed sub -> 127 - (-128)"
			Severity ERROR;
		wait for clock_period;	
		
		-- Test for unsigned sub -> 0 - 1
		opcode <= "010";
		A <= "00000000";
		B <= "00000001"; 
		wait for clock_period;
		Assert(zero = '0' and carryout = '0' and overflow = '1')
			Report "Error at unsigned add -> 0 - 1"
			Severity ERROR;
		wait for clock_period;		

		-- Test for unsigned sub -> 5 - 1
		opcode <= "010";
		A <= "00000101";
		B <= "00000001"; 
		wait for clock_period;
		Assert(zero = '0' and carryout = '1' and overflow = '0')
			Report "Error at unsigned add -> 5 - 1"
			Severity ERROR;
		wait for clock_period;			
		
		Report "Done with testbench" Severity NOTE;

      wait;
   end process;

END;
