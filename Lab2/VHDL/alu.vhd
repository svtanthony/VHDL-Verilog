----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:30:55 01/07/2016 
-- Design Name: 
-- Module Name:    my_alu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin_alu is

	Generic(NUMBITS : natural := 8);
	
	Port (
		A : in std_logic_vector(NUMBITS - 1 downto 0);
		B : in std_logic_vector(NUMBITS - 1 downto 0);
		opcode : in std_logic_vector(2 downto 0);
		result : out std_logic_vector(NUMBITS - 1 downto 0);
		carryout : out std_logic;
		overflow : out std_logic;
		zero : out std_logic
	);
end bin_alu;

architecture Behavioral of bin_alu is

signal sum : std_logic_vector(NUMBITS downto 0);

begin

	process(A, B, opcode)
	variable temp : std_logic_vector(NUMBITS downto 0);
	begin
	
	case opcode is
		when "000" =>
			-- unsigned add
			temp := std_logic_vector(unsigned('0' & A) + unsigned('0' & B));		
			carryout <= temp(NUMBITS);
			overflow <= temp(NUMBITS);
			sum <= temp;
		when "001" =>
			-- signed add
			temp := std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
			if (A(NUMBITS-1) = '0') and (B(NUMBITS-1) = '0') and (sum(NUMBITS-1) = '1') then
				overflow <= '1';
			elsif (A(NUMBITS-1) = '1') and (B(NUMBITS-1) = '1') and (temp(NUMBITS-1) = '0') then
				overflow <= '1';
			else
				overflow <= '0';
			end if;
			carryout <= temp(NUMBITS);
			sum <= temp;
		when "010" =>
			-- unsigned sub
			temp := std_logic_vector(unsigned('0' & A) + unsigned('0' & (unsigned(not B)+1) ));
			carryout <= temp(NUMBITS);
			if (B = (B'range => '0')) then
				overflow <= '0';
			else
				overflow <= not temp(NUMBITS);
			end if;
			sum <= temp;
		when "011" =>
			-- signed sub
			temp := std_logic_vector(unsigned('0' & A) + unsigned('0' & (unsigned(not B)+1)));
			if (A(NUMBITS-1) = '0') and (B(NUMBITS-1) = '1') and (temp(NUMBITS-1) = '1') then
				overflow <= '1';
			elsif (A(NUMBITS-1) = '1') and (B(NUMBITS-1) = '0') and (temp(NUMBITS-1) = '0') then
				overflow <= '1';
			else
				overflow <= '0';
			end if;
			carryout <= temp(NUMBITS);
			sum <= temp;
		when "100" =>
			sum <= ('0' & (A and B));
			carryout <= '0';
			overflow <= '0';
		when "101" =>
			sum <= ('0' & (A or B));
			carryout <= '0';
			overflow <= '0';
		when "110" =>
			sum <= ('0' & (A xor B));
			carryout <= '0';
			overflow <= '0';
		when "111" =>
			sum <= std_logic_vector('0' & (unsigned(A) srl 1));
			carryout <= '0';
			overflow <= '0';
		when others =>
			sum <= (sum'range => 'X');
	end case;
	
	end process;
	
	
	
	process(sum)
	begin
		result <= sum(NUMBITS-1 downto 0);
	if sum(NUMBITS-1 downto 0) = (result'range => '0') then
		zero <= '1';
	else
		zero <= '0';
	end if;

	end process;
	

end Behavioral;

