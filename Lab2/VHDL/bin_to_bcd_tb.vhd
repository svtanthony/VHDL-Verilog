--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:36:14 01/29/2016
-- Design Name:   
-- Module Name:   /home/csmajs/jholl013/Desktop/bcd_alu/bin_to_bcd_tb.vhd
-- Project Name:  bcd_alu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bin_to_bcd
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bin_to_bcd_tb IS
END bin_to_bcd_tb;
 
ARCHITECTURE behavior OF bin_to_bcd_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bin_to_bcd
    PORT(
         A : IN  std_logic_vector(15 downto 0);
         sign : IN  std_logic;
         carry : OUT  std_logic;
         result : OUT  std_logic_vector(19 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal sign : std_logic := '0';

 	--Outputs
   signal carry : std_logic;
   signal result : std_logic_vector(19 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bin_to_bcd PORT MAP (
          A => A,
          sign => sign,
          carry => carry,
          result => result
        );

   -- Stimulus process
   stim_proc: process
   begin

      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here
		
		
		
		report "Testing binary to bcd unsigned";
		-- Test 1
		sign <= '0';
		A <= conv_std_logic_vector(23, 16);
		wait for 10 ns;
		assert result = "00000000000000100011"
			report "Test 1 incorrect"
			severity Warning;
			
		-- Test 2
		sign <= '0';
		A <= conv_std_logic_vector(9999, 16);
		wait for 10 ns;
		assert result = "00001001100110011001"
			report "Test 2 incorrect"
			severity Warning;
			
		-- Test 3
		sign <= '0';
		A <= conv_std_logic_vector(19999, 16);
		wait for 10 ns;
		assert result = "00011001100110011001" and carry = '1'
			report "Test 3 incorrect"
			severity Warning;
			
		report "Testing binary to bcd signed";
		-- Test 4
		sign <= '1';
		A <= conv_std_logic_vector(9999, 16);
		wait for 10 ns;
		assert result = "00001001100110011001" and carry = '1'
			report "Test 4 incorrect"
			severity Warning;
			
				-- Test 5
		sign <= '1';
		A <= conv_std_logic_vector(-1, 16);
		wait for 10 ns;
		assert result = "00010000000000000001" and carry = '0'
			report "Test 5 incorrect"
			severity Warning;
			
		-- Test 6
		sign <= '1';
		A <= conv_std_logic_vector(-1001, 16);
		wait for 10 ns;
		assert result = "00010001000000000001" and carry = '1'
			report "Test 6 incorrect"
			severity Warning;
			
		-- Test 7
		sign <= '1';
		A <= conv_std_logic_vector(1001, 16);
		wait for 10 ns;
		assert result = "00000001000000000001" and carry = '1'
			report "Test 7 incorrect"
			severity Warning;

      wait;
   end process;

END;

