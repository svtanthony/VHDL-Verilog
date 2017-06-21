--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:07:22 01/21/2016
-- Design Name:   
-- Module Name:   /home/csmajs/jholl013/Desktop/lab2_bcd/bcd_to_bin_tb.vhd
-- Project Name:  lab2_bcd
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bcd_to_bin
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
 
ENTITY bcd_to_bin_tb IS
END bcd_to_bin_tb;
 
ARCHITECTURE behavior OF bcd_to_bin_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bcd_to_bin
		generic(
			numbits	: natural	:= 32
		);
    PORT(
         A : IN  std_logic_vector;
         sign : IN  std_logic;
         result : OUT  std_logic_vector
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal sign : std_logic := '0';

 	--Outputs
   signal result : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bcd_to_bin generic map(
		numbits => 16
	)
	PORT MAP (
          A => A,
          sign => sign,
          result => result
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here
		report "Testing bcd to binary unsigned";

		
		-- Test 1
		sign <= '0';
		A <= "0000000000100011";
		wait for 10 ns;
		assert result = conv_std_logic_vector(23, 16)
			report "Test 1 incorrect"
			severity Warning;
			
		-- Test 2
		sign <= '0';
		A <= "0001010100100011";
		wait for 10 ns;
		assert result = conv_std_logic_vector(1523, 16)
			report "Test 2 incorrect"
			severity Warning;
			
		-- Test 3
		sign <= '1';
		A <= "0001000000101001";
		wait for 10 ns;
		assert result = conv_std_logic_vector(-29, 16)
			report "Test 3 incorrect"
			severity Warning;
			
		-- Test 4
		sign <= '1';
		A <= "0001010100100011";
		wait for 10 ns;
		assert result = conv_std_logic_vector(-523, 16)
			report "Test 4 incorrect"
			severity Warning;
			
		-- Test 5
		sign <= '0';
		A <= "1001100110011001";
		wait for 10 ns;
		assert result = conv_std_logic_vector(9999, 16)
			report "Test 5 incorrect"
			severity Warning;
			
		-- Test 6
		sign <= '1';
		A <= "0001100110011001";
		wait for 10 ns;
		assert result = conv_std_logic_vector(-999, 16)
			report "Test 6 incorrect"
			severity Warning;
      wait;
   end process;

END;
