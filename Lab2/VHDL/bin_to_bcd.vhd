----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:57:25 01/29/2016 
-- Design Name: 
-- Module Name:    bin_to_bcd - Behavioral 
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

entity bin_to_bcd is
	Generic(N : natural := 16);
	
	Port (
		A : in std_logic_vector(N - 1 downto 0);
		sign : in std_logic;
		carry : out std_logic;
		result: out std_logic_vector(N +3 downto 0)
	);
end bin_to_bcd;

architecture Behavioral of bin_to_bcd is

begin

	process (A, sign)
		variable result_temp : std_logic_vector(N + 3 downto 0);
		variable A_temp      : std_logic_vector(N-1 downto 0);
		variable column      : unsigned(3 downto 0);
		variable left        : integer range 0 to 16;
	begin
		A_temp := A;
		result_temp := (others => '0');
		
		if sign = '1' and A(N-1) = '1' then
			A_temp := std_logic_vector(unsigned((not A) + 1));
		end if;

		for i in 0 to N - 1 loop
			for j in 0 to (N+4)/4 - 1 loop
				column := unsigned(result_temp(j*4 + 3 downto j*4));
				if column >= 5 then
					column := column + 3;
					result_temp(j*4 + 3 downto j*4) := std_logic_vector(column);
				end if;
			end loop;
			result_temp := std_logic_vector(unsigned(result_temp) sll 1);
			result_temp(0) := A_temp(N-1-i);
		end loop;
		if sign = '1' then
			if unsigned(result_temp(N-1 downto N-4)) > 0 then
				carry <= '1';
			else
				carry <= '0';
			end if;
			if A(N-1) = '1' then
				result_temp(N+3 downto N) := "0001";
			end if;
		else
			if unsigned(result_temp(N+3 downto N)) > 0 then
				carry <= '1';
			else
				carry <= '0';
			end if;
		end if;
		result <= result_temp;
	end process;

end Behavioral;

