--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:31:18 01/28/2016
-- Design Name:   
-- Module Name:   /home/csmajs/jholl013/Desktop/lab2/bcd_alu_tb.vhd
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.all;
 
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY bcd_alu_tb IS
END bcd_alu_tb;
 
ARCHITECTURE behavior OF bcd_alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT my_alu
    PORT(
         A : IN  std_logic_vector(31 downto 0) := (others => '0');
         B : IN  std_logic_vector(31 downto 0) := (others => '0');
         Opcode : IN  std_logic_vector(3 downto 0) := (others => '0');
         Result : OUT  std_logic_vector(35 downto 0) := (others => '0');
         Carryout : OUT  std_logic :='0';
         Overflow : OUT  std_logic :='0';
         Zero : OUT  std_logic :='0'
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Opcode : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Result : std_logic_vector(35 downto 0) := (others => '0');
   signal Carryout : std_logic := '0';
   signal Overflow : std_logic := '0';
   signal Zero : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: my_alu PORT MAP (
          A => A,
          B => B,
          Opcode => Opcode,
          Result => Result,
          Carryout => Carryout,
          Overflow => Overflow,
          Zero => Zero
        );


   -- Stimulus process
   stim_proc: process
   begin		

		A <= (others => '0');
		B <= (others => '0');
		opcode <= "1000";
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- insert stimulus here
		
		----------------------------------------------------------------------------
		report "Testing bcd unsigned add";
		----------------------------------------------------------------------------
		
		
		-- Test 1 (test result)
		opcode <= "1000";
		A <= "00000000000000000000000000100011";
		B <= "00000000000000000000000000100011";

		wait for 10 ns;
		assert result = "000000000000000000000000000001000110" report "Test 1 fail - result" severity Warning;
		assert carryout = '0' report "Test 1 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 1 fail - overflow" severity Warning;
		assert zero = '0' report "Test 1 fail - zero" severity Warning;
		
		-- Test 2 
		-- 57 + 143 = 200 (test result)
		opcode <= "1000";
		A <= "00000000000000000000000001010111";
		B <= "00000000000000000000000101000011";

		wait for 10 ns;
		assert result = "000000000000000000000000001000000000" report "Test 2 fail - result" severity Warning;
		assert carryout = '0' report "Test 2 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 2 fail - overflow" severity Warning;
		assert zero = '0' report "Test 2 fail - zero" severity Warning;
		
		-- Test 3  -- 99999999 + 99999999 = 199999998(set carry)
		opcode <= "1000";
		A <= "10011001100110011001100110011001"; -- A <= x"99999999"
		B <= "10011001100110011001100110011001";

		wait for 10 ns;
		assert result = "000110011001100110011001100110011000" report "Test 3 fail - result" severity Warning;
		assert carryout = '1' report "Test 3 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 3 fail - overflow" severity Warning;
		assert zero = '0' report "Test 3 fail - zero" severity Warning;
		
		-- Test 4  -- 0 + 0 = 0(set Zero)
		opcode <= "1000";
		A <= x"00000000"; 
		B <= x"00000000"; 

		wait for 10 ns;
		assert result = x"00000000" report "Test 4 fail - result" severity Warning;
		assert carryout = '0' report "Test 4 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 4 fail - overflow" severity Warning;
		assert zero = '1' report "Test 4 fail - zero" severity Warning;
		
		----------------------------------------------------------------------------
		report "Testing bcd unsigned subtract";
		opcode <= "1001";
		----------------------------------------------------------------------------
		
		-- Test 5 -- 0 - 1 = 999999...
		A <= x"00000000";
		B <= x"00000001";
		
		wait for 10 ns;
		--assert result = x"99999999" report "Test 5 fail - result" severity Warning;
		-- required algorithim MAXVALUE-B+A+1 = 99999999-1+0+1 = 99999999
		assert carryout = '1' report "Test 5 fail - carryout" severity Warning;
		assert overflow = '1' report "Test 5 fail - overflow" severity Warning;
		assert zero = '0' report "Test 5 fail - zero" severity Warning;
		
		-- Test 6 -- 1 - 0 = 1
		A <= x"00000001";
		B <= x"00000000";
		
		wait for 10 ns;
		assert result = x"00000001" report "Test 6 fail - result" severity Warning;
		assert carryout = '0' report "Test 6 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 6 fail - overflow" severity Warning;
		assert zero = '0' report "Test 6 fail - zero" severity Warning;
		
		-- Test 7 -- 9999 - 1111 = 8888
		A <= x"00009999";
		B <= x"00001111";
		
		wait for 10 ns;
		assert result = x"00008888" report "Test 7 fail - result" severity Warning;
		assert carryout = '0' report "Test 7 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 7 fail - overflow" severity Warning;
		assert zero = '0' report "Test 7 fail - zero" severity Warning;
		
		-- Test 16 -- 9999 - 9999 = 0000
		A <= x"00009999";
		B <= x"00009999";
		
		wait for 10 ns;
		assert result = x"000000000" report "Test 16 fail - result" severity Warning;
		assert carryout = '0' report "Test 16 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 16 fail - overflow" severity Warning;
		assert zero = '1' report "Test 16 fail - zero" severity Warning;
		
		----------------------------------------------------------------------------
		report "Testing bcd signed add";
		opcode <= "1100";
		----------------------------------------------------------------------------
		-- Test 8 -- 9999 + (-1111) = 8888
		A <= x"00009999";
		B <= x"10001111";
		
		wait for 10 ns;
		assert result = x"000008888" report "Test 8 fail - result" severity Warning;
		assert carryout = '0' report "Test 8 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 8 fail - overflow" severity Warning;
		assert zero = '0' report "Test 8 fail - zero" severity Warning;
		
		-- Test 9 -- (-9999) + (-1111) = (-11110)
		A <= x"10009999";
		B <= x"10001111";
		
		wait for 10 ns;
		assert result = x"100011110" report "Test 9 fail - result" severity Warning;
		assert carryout = '0' report "Test 9 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 9 fail - overflow" severity Warning;
		assert zero = '0' report "Test 9 fail - zero" severity Warning;
		
		-- Test 10 -- (-512) + 512 = 0
		A <= x"10000512";
		B <= x"00000512";
		
		wait for 10 ns;
		assert result = x"00000000" report "Test 10 fail - result" severity Warning;
		assert carryout = '0' report "Test 10 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 10 fail - overflow" severity Warning;
		assert zero = '1' report "Test 10 fail - zero" severity Warning;
		
		-- Test 11 -- 0 + (-512) = -512
		A <= x"00000000";
		B <= x"10000512";
		
		wait for 10 ns;
		assert result = x"100000512" report "Test 11 fail - result" severity Warning;
		assert carryout = '0' report "Test 11 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 11 fail - overflow" severity Warning;
		assert zero = '0' report "Test 11 fail - zero" severity Warning;
		
		-- Test 17 -- (99999999) + (-1) = 099999998
		A <= x"09999999";
		B <= x"10000001";
		
		wait for 10 ns;
		assert result = x"009999998" report "Test 17 fail - result" severity Warning;
		assert carryout = '0' report "Test 17 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 17 fail - overflow" severity Warning;
		assert zero = '0' report "Test 17 fail - zero" severity Warning;
		
		-- Test 18 -- 99999999 + 1 = 100000000
		A <= x"09999999";
		B <= x"00000001";
		
		wait for 10 ns;
		assert result = x"010000000" report "Test 18 fail - result" severity Warning;
		assert carryout = '1' report "Test 18 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 18 fail - overflow" severity Warning;
		assert zero = '0' report "Test 18 fail - zero" severity Warning;
		
		----------------------------------------------------------------------------
		report "Testing bcd signed subtract";
		opcode <= "1101";
		----------------------------------------------------------------------------
		
		-- Test 12 -- 32 - 32 = 0
		A <= x"00000032";
		B <= x"00000032";
		
		wait for 10 ns;
		assert result = x"000000000" report "Test 12 fail - result" severity Warning;
		assert carryout = '0' report "Test 12 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 12 fail - overflow" severity Warning;
		assert zero = '1' report "Test 12 fail - zero" severity Warning;
		
		-- Test 13 -- 0 - 32 = -32
		A <= x"00000000";
		B <= x"00000032";
		
		wait for 10 ns;
		assert result = x"100000032" report "Test 13 fail - result" severity Warning;
		assert carryout = '0' report "Test 13 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 13 fail - overflow" severity Warning;
		assert zero = '0' report "Test 13 fail - zero" severity Warning;
		
		-- Test 14 -- (-32) - (-32) = -64
		A <= x"10000032";
		B <= x"10000032";
		
		wait for 10 ns;
		assert result = x"000000000" report "Test 14 fail - result" severity Warning;
		assert carryout = '0' report "Test 14 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 14 fail - overflow" severity Warning;
		assert zero = '1' report "Test 14 fail - zero" severity Warning;
		
		-- Test 15 -- (99999999) - 1 = 009999998
		A <= x"09999999";
		B <= x"00000001";
		
		wait for 10 ns;
		assert result = x"009999998" report "Test 15 fail - result" severity Warning;
		assert carryout = '0' report "Test 15 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 15 fail - overflow" severity Warning;
		assert zero = '0' report "Test 15 fail - zero" severity Warning;
		
		-- Test 16 -- (99999999) - (-1) = 100000000
		A <= x"09999999";
		B <= x"10000001";
		
		wait for 10 ns;
		assert result = x"010000000" report "Test 16 fail - result" severity Warning;
		assert carryout = '1' report "Test 16 fail - carryout" severity Warning;
		assert overflow = '0' report "Test 16 fail - overflow" severity Warning;
		assert zero = '0' report "Test 16 fail - zero" severity Warning;
		

      wait;
   end process;

END;
