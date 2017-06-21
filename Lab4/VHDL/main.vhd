----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;



Entity main is
    Port ( functionfield : in  STD_LOGIC_VECTOR (5 downto 0);
           instr_op_main : in  STD_LOGIC_VECTOR (5 downto 0);
           reg_dst : out  STD_LOGIC;
           branch : out  STD_LOGIC;
           mem_read : out  STD_LOGIC;
           mem_to_reg : out  STD_LOGIC;
           alu_output : out  STD_LOGIC_VECTOR (3 downto 0);
           mem_write : out  STD_LOGIC;
           alu_src : out  STD_LOGIC;
           reg_write : out  STD_LOGIC);
end main;

architecture Behavioral of main is

    component control_unit is 
        port (  
		      instr_op          : in std_logic_vector(5 downto 0);
				reg_dst           : out std_logic;
				branch            : out std_logic;
				mem_read          : out std_logic;
				mem_to_reg        : out std_logic;
				alu_op            : out std_logic_vector(1 downto 0);
				mem_write         : out std_logic;
				alu_src           : out std_logic;
				reg_write         : out std_logic
        ); 
    end component;
    
    component alu_control is 
        port (
				alu_op            : in std_logic_vector(1 downto 0);
				instruction_5_0   : in std_logic_vector(5 downto 0);
				alu_out           : out std_logic_vector(3 downto 0)
        );
    end component;

	signal temp_alu_op : std_logic_vector(1 downto 0) := (others => '0');
	
begin
	C_UNIT : control_unit port map(
											instr_op => instr_op_main,
											reg_dst => reg_dst,
											branch => branch,
											mem_read => mem_read,
											mem_to_reg => mem_to_reg,
											alu_op => temp_alu_op,
											mem_write => mem_write,
											alu_src => alu_src,
											reg_write => reg_write);
	ALU_UNIT : alu_control port map(
											alu_op => temp_alu_op,
											instruction_5_0 => functionfield,
											alu_out => alu_output);
											
end Behavioral;

