library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CAM_Row is
	Generic (CAM_WIDTH : integer := 8) ;
	Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           we : in  STD_LOGIC;
           search_word : in  STD_LOGIC_VECTOR (CAM_WIDTH-1 downto 0);
           dont_care_mask : in  STD_LOGIC_VECTOR (CAM_WIDTH-1 downto 0);
           row_match : out  STD_LOGIC);
	 
end CAM_Row;

architecture Behavioral of CAM_Row is


component TCAM_Cell is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           we : in  STD_LOGIC;
           cell_search_bit : in  STD_LOGIC;
           cell_dont_care_bit : in  STD_LOGIC;
			  cell_match_bit_in : in  STD_LOGIC ;
           cell_match_bit_out : out  STD_LOGIC);
	 
end component ;

signal match_vector : STD_LOGIC_VECTOR (CAM_WIDTH-1 downto 0) := (others => '0');

begin

initial_cell : TCAM_CELL
	port map(
		clk => clk,
		rst => rst,
		we => we,
		cell_search_bit =>search_word(0),
		cell_dont_care_bit => dont_care_mask(0),
		cell_match_bit_in => '1',
		cell_match_bit_out => match_vector(0)
	);

cells: for I in 1 to CAM_WIDTH-1 generate
	cell: TCAM_CELL port map(
		clk => clk,
		rst => rst,
		we => we,
		cell_search_bit =>search_word(I),
		cell_dont_care_bit => dont_care_mask(I),
		cell_match_bit_in => match_vector(I-1),
		cell_match_bit_out => match_vector(I)
	);
	
end generate; 



process (match_vector)
begin
	row_match <= match_vector(CAM_WIDTH-1);

end process;
-- Connect the CAM cells here

end Behavioral;
