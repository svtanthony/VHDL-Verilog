library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity BCAM_Cell is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           we : in  STD_LOGIC;
           cell_search_bit : in  STD_LOGIC;
           cell_dont_care_bit : in  STD_LOGIC;
			  cell_match_bit_in : in  STD_LOGIC ;
           cell_match_bit_out : out  STD_LOGIC);
end BCAM_Cell;

architecture Behavioral of BCAM_Cell is

signal curr_bit : STD_LOGIC :='0';

begin


process (we, cell_search_bit, cell_match_bit_in, clk, rst)
begin 
	if rising_edge(clk) and we = '1' then 
		curr_bit <= cell_search_bit;
	else 
		if cell_search_bit = curr_bit and cell_match_bit_in = '1' then
			cell_match_bit_out <= '1';
		else
			cell_match_bit_out <= '0';
		end if;
	end if;
	
	if rst = '1' then
		cell_match_bit_out <= '0';
		curr_bit <= '0';
	end if;
		
end process;



end Behavioral ;
