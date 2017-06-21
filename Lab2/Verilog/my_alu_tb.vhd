--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:35:47 05/11/2017
-- Design Name:   
-- Module Name:   /home/dan/Xilinx/labs/lab2/my_alu_tb.vhd
-- Project Name:  lab2
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
 
ENTITY my_alu_tb IS
END my_alu_tb;
 
ARCHITECTURE behavior OF my_alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT my_alu
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Opcode : IN  std_logic_vector(3 downto 0);
         Carry_out : OUT  std_logic;
         Overflow : OUT  std_logic;
         Zero : OUT  std_logic;
         result : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Opcode : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Carry_out : std_logic;
   signal Overflow : std_logic;
   signal Zero : std_logic;
   signal result : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: my_alu PORT MAP (
          A => A,
          B => B,
          Opcode => Opcode,
          Carry_out => Carry_out,
          Overflow => Overflow,
          Zero => Zero,
          result => result
        );

   -- Clock process definitions
   <clock>_process :process
   begin
		<clock> <= '0';
		wait for <clock>_period/2;
		<clock> <= '1';
		wait for <clock>_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for <clock>_period*10;

      -- insert stimulus here 
		Opcode <= "1000";
		A <= "00000000000000000000000000100011";
		B <= "00000000000000000000000000100011";
		
   end process;

END;
