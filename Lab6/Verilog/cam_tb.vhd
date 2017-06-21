--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:59:03 02/27/2016
-- Design Name:   
-- Module Name:   /home/rob/cs161/test/cam_tb.vhd
-- Project Name:  test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CAM_Wrapper
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
use IEEE.math_real.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY cam_tb IS
END cam_tb;
 
ARCHITECTURE behavior OF cam_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CAM_Wrapper
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         we_decoded_row_address : IN  std_logic_vector(7 downto 0);
         search_word : IN  std_logic_vector(7 downto 0);
         dont_care_mask : IN  std_logic_vector(7 downto 0);
         decoded_match_address : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal we_decoded_row_address : std_logic_vector(7 downto 0) := (others => '0');
   signal search_word : std_logic_vector(7 downto 0) := (others => '0');
   signal dont_care_mask : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal decoded_match_address : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	shared variable A: unsigned(7 downto 0) := x"01";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CAM_Wrapper PORT MAP (
          clk => clk,
          rst => rst,
          we_decoded_row_address => we_decoded_row_address,
          search_word => search_word,
          dont_care_mask => dont_care_mask,
          decoded_match_address => decoded_match_address
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		rst <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;
			rst <= '0';

      wait for clk_period*10;

      -- insert stimulus here
		
		-- load value(0,32,64,96,128,160,192,224) in addresses(1-8)
		--	(0)0000-0000 (32)0010-0000 (64)0100-0000 (96)0110-0000 (128)1000-0000 (160)1010-0000 (192)1100-0000 (224)1110-0000
		for I in 0 to 7 loop
			we_decoded_row_address <= std_logic_vector(to_unsigned(2**I,we_decoded_row_address'length));
			search_word <= std_logic_vector(to_unsigned(I*32,search_word'length));
			wait for clk_period*2;
		end loop;
		
		we_decoded_row_address <= (others => '0');	
		
		-- test 2 (search x00)
      search_word <= x"00";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"01"	report "Test 1 fail - search for 0" severity Warning;
		
		-- test 2 (search x20)
      search_word <= x"20";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"02"	report "Test 2 fail - search for x20" severity Warning;
		
		-- test 3 (search x40)
      search_word <= x"40";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"04"	report "Test 3 fail - search for x40" severity Warning;
		
		-- test 4 (search x60)
      search_word <= x"60";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"08"	report "Test 4 fail - search for x60" severity Warning;
		

		-- test 5 (search x80)
      search_word <= x"80";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"10"	report "Test 5 fail - search for x80" severity Warning;

		-- test 6 (search xA0)
      search_word <= x"A0";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"20"	report "Test 6 fail - search for xA0" severity Warning;
	
	
		-- test 7 (search xC0)
      search_word <= x"C0";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"40"	report "Test 7 fail - search for xC0" severity Warning;	
	
		-- test 8 (search xE0)
      search_word <= x"E0";
      dont_care_mask <= x"00";
		wait for clk_period*2;
      assert decoded_match_address = x"80"	report "Test 8 fail - search for xE0" severity Warning;
	
		-- test 9 (search DC x20)
      search_word <= x"00";
      dont_care_mask <= x"20";
		wait for clk_period*2;
      assert decoded_match_address = x"03"	report "Test 9 fail - search for x20 w/DC (only passes w/ TCAM)" severity Warning;
		
		-- test 10 (search DC x40)
      search_word <= x"00";
      dont_care_mask <= x"40";
		wait for clk_period*2;
      assert decoded_match_address = x"05"	report "Test 10 fail - search for x40 w/DC (only passes w/ TCAM)" severity Warning;
		
		-- test 11 (search DC x60)
      search_word <= x"00";
      dont_care_mask <= x"60";
		wait for clk_period*2;
      assert decoded_match_address = x"0F"	report "Test 11 fail - search for x60 w/DC (only passes w/ TCAM)" severity Warning;
		
		
		-- test 12 (search DC x80)
      search_word <= x"00";
      dont_care_mask <= x"80";
		wait for clk_period*2;
      assert decoded_match_address = x"11"	report "Test 12 fail - search for x80 w/DC (only passes w/ TCAM)" severity Warning;
		
		
		-- test 13 (search DC xA0)
      search_word <= x"00";
      dont_care_mask <= x"A0";
		wait for clk_period*2;
      assert decoded_match_address = x"33"	report "Test 13 fail - search for xA0 w/DC (only passes w/ TCAM)" severity Warning;
		
		
		-- test 14 (search DC xC0)
      search_word <= x"00";
      dont_care_mask <= x"C0";
		wait for clk_period*2;
      assert decoded_match_address = x"55"	report "Test 14 fail - search for xC0 w/DC (only passes w/ TCAM)" severity Warning;
		
		
		-- test 15 (search DC xE0)
      search_word <= x"00";
      dont_care_mask <= x"E0";
		wait for clk_period*2;
      assert decoded_match_address = x"FF"	report "Test 15 fail - search for xE0 w/DC (only passes w/ TCAM)" severity Warning;
		
		
		--test 16 (search DC xFF)
		search_word <= x"00";
      dont_care_mask <= x"FF";
		wait for clk_period*2;
      assert decoded_match_address = x"FF"	report "Test 16 fail - search for xFF w/DC (only passes w/ TCAM)" severity Warning;	
		
		--load "1X10-0000" @ address 1
		we_decoded_row_address <= x"01";
		search_word <= x"A0";
		dont_care_mask <= x"40";
		wait for clk_period*2;
		we_decoded_row_address <= x"00";
		dont_care_mask <= x"00";
		
		
		--test 17 (search xE0)
		search_word <= x"E0";
		wait for clk_period*2;
      assert decoded_match_address = x"81"	report "Test 17 fail - search for xE0 Add(1) = 1X10-0000 (only passes w/ STCAM)" severity Warning;	
		
		--test 18 (search xA0)
		search_word <= x"A0";
		wait for clk_period*2;
      assert decoded_match_address = x"21"	report "Test 18 fail - search for xA0 Add(1) = 1X10-0000 (only passes w/ STCAM)" severity Warning;	

      wait;
   end process;

END;
