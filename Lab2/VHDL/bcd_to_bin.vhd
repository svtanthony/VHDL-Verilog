----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:55:01 01/21/2016 
-- Design Name: 
-- Module Name:    bcd_to_bin - Behavioral 
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
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bcd_to_bin is
Generic(NUMBITS : natural := 16);
	
	Port (
		A : in std_logic_vector(NUMBITS - 1 downto 0);
		sign : in std_logic;
		result: out std_logic_vector(NUMBITS - 1 downto 0)
	);

end bcd_to_bin;

architecture Behavioral of bcd_to_bin is

begin

	process(A, sign)
		variable bin_A : std_logic_vector(NUMBITS-1 downto 0);
		--variable int_A : unsigned(NUMBITS - 1 downto 0);
		--variable power : unsigned(NUMBITS - 1 downto 0);
		variable power : integer range 0 to NUMBITS - 1;
		variable int_A : integer range 0 to NUMBITS - 1;
		begin
			bin_A := std_logic_vector(to_unsigned(0, NUMBITS));
			power := 1;
			int_A := 0;
			if sign = '0' then
				-- unsigned bcd convert
				for i in 0 to (NUMBITS / 4) - 1 loop
					int_A := int_A + power * to_integer(unsigned(A(i*4 + 3 downto i*4)));
					power := power * 10;
				end loop;
			elsif sign = '1' then
				for i in 0 to (NUMBITS / 4) - 2 loop
					int_A := int_A + power * to_integer(unsigned(A(i*4 + 3 downto i*4)));
					power := power * 10;
				end loop;
				-- signed bcd convert
				if A(NUMBITS - 4) = '1' then
					-- negative number
					--int_A := to_integer((not to_unsigned(int_A, NUMBITS))) + 1;
					int_A := (-1)*int_A;
				end if;
			end if;
			result <= std_logic_vector(to_signed(int_A, NUMBITS));
		end process;

end Behavioral;

