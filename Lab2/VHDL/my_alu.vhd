----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:55:05 01/21/2016 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity my_alu is

	 Generic(n : natural := 32);
	
    Port ( A : in  STD_LOGIC_VECTOR (n-1 downto 0) := (others => '0');
           B : in  STD_LOGIC_VECTOR (n-1 downto 0) := (others => '0');
           Opcode : in  STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
           Result : out  STD_LOGIC_VECTOR (n+3 downto 0) := (others => '0');
           Carryout : out  STD_LOGIC  :='0';
           Overflow : out  STD_LOGIC :='0';
           Zero : out  STD_LOGIC :='0');
end my_alu;

architecture Behavioral of my_alu is

	component bin_alu 
		generic (
			numbits : natural := n
		);
		PORT( A : in std_logic_vector;
				B : in std_logic_vector;
				opcode : in std_logic_vector;
				result : out std_logic_vector;
				carryout : out std_logic;
				overflow : out std_logic;
				zero : out std_logic);
	end component;
	
	 component bcd_to_bin
		generic(
			numbits	: natural	:= n
		);
    PORT(
         A : IN  std_logic_vector;
         sign : IN  std_logic;
         result : OUT  std_logic_vector
        );
    END COMPONENT;
	 
	 component bin_to_bcd
		generic(
			n	: natural	:= n
		);
    PORT(
         A : IN  std_logic_vector;
         sign : IN  std_logic;
			carry : OUT std_logic;
         result : OUT  std_logic_vector
        );
    END COMPONENT;

	signal bin_A  : std_logic_vector(n-1 downto 0) := (others => '0');
	signal bin_B  : std_logic_vector(n-1 downto 0) := (others => '0');
	signal new_op : std_logic_vector(2 downto 0) := (others => '0');
	signal bin_result : std_logic_vector(n-1 downto 0) := (others => '0');
	signal temp_carryout : std_logic := '0';

begin

	U1 : bcd_to_bin PORT MAP(  A      => A,
									   sign   => (opcode(2)),
									   result => bin_A);
	U2 : bcd_to_bin PORT MAP ( A      => B,
										sign   => opcode(2),
										result => bin_B);
	U3 : bin_alu PORT MAP (  A        => bin_A,
									 B        => bin_B,
									 opcode   => new_op,
									 result   => bin_result,
									 overflow => overflow,
									 carryout => temp_carryout,
									 zero     => zero);
	U4 : bin_to_bcd PORT MAP ( A      => bin_result,
										sign   => opcode(2),
										carry  => Carryout,
										result => Result);

	process (opcode)
	begin
		case Opcode is
			when "1000" =>
				new_op <= "000"; 
				-- BCD unsigned add
			when "1001" =>
				-- BCD unsigned subtract
				new_op <= "010";
			when "1100" =>
				-- BCD signed add
				new_op <= "001";
			when "1101" =>
				-- BCD signed subtract
				new_op <= "011";
			when others =>
				-- default
				new_op <= "000";
		end case;
	end process;


end Behavioral;

