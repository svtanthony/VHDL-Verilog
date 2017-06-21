library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generic_register is
  generic (
    SIZE        : natural   := 4
  );
  port (
    clk         : in std_logic;
    rst         : in std_logic;
    write_en    : in std_logic;
    data_in     : in std_logic_vector(SIZE-1 downto 0);
    data_out    : out std_logic_vector(SIZE-1 downto 0)
  );
end generic_register;

--PC is a generic register
architecture Behavioral of generic_register is

begin

  process (clk, rst)
  begin
    if rst = '1' then
      data_out <= (others => '0');
      
    elsif rising_edge(clk) then
      if write_en = '1' then
        data_out <= data_in;
      end if;
      
    end if;
  end process;
  
end Behavioral;

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_1 is
  generic(
    SIZE           : natural   := 4
  );
  port (
    select_in      : in std_logic;
    data_0_in      : in std_logic_vector(SIZE-1 downto 0);
    data_1_in      : in std_logic_vector(SIZE-1 downto 0);
    data_out       : out std_logic_vector(SIZE-1 downto 0)
  );
end mux_2_1;

architecture Behavioral of mux_2_1 is

begin

  process (select_in, data_0_in, data_1_in)
  begin
    case select_in is
      when '0'    =>    data_out <= data_0_in;
      when '1'    =>    data_out <= data_1_in;
      when others =>    data_out <= (others => '0');
    end case;
  end process;

end Behavioral;

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity cpu_registers is
  port (
	 clk					 : in std_logic;
    rst               : in std_logic;
    reg_write         : in std_logic;
    read_register_1   : in std_logic_vector(4 downto 0);
    read_register_2   : in std_logic_vector(4 downto 0);
    write_register    : in std_logic_vector(4 downto 0);
    write_data        : in std_logic_vector(31 downto 0);
    read_data_1       : out std_logic_vector(31 downto 0);
    read_data_2       : out std_logic_vector(31 downto 0)
    );
end cpu_registers;

architecture Behavioral of cpu_registers is
  type REG_BUFF is array(0 to 31) of std_logic_vector(31 downto 0);
  signal registers   : REG_BUFF;

begin

  process (rst, read_register_1, read_register_2)
  begin
    if rst = '1' then
      read_data_1 <= (others => '0');
      read_data_2 <= (others => '0');
    else
      read_data_1 <= registers(conv_integer(read_register_1));
      read_data_2 <= registers(conv_integer(read_register_2));
    end if;
    
  end process;
  
  process (rst, clk)
  begin
    if rst = '1' then
      for i in 31 downto 0 loop
        registers(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk) then
      if reg_write = '1' then
        registers(conv_integer(write_register)) <= write_data;
      end if;
    end if;
    
  end process;

end Behavioral;

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use work.cpu_constant_library.all;

entity alu is
  port (
    alu_control_in : in std_logic_vector(3 downto 0);
    channel_a_in   : in std_logic_vector(31 downto 0);
    channel_b_in   : in std_logic_vector(31 downto 0);
    zero_out       : out std_logic;
    alu_result_out : out std_logic_vector(31 downto 0)
    );
end alu;

architecture Behavioral of alu is
  signal result_s   : std_logic_vector(31 downto 0);

begin

  process (alu_control_in, channel_a_in, channel_b_in)
  begin
    case alu_control_in is
      --AND
      when "0000"          => result_s <= channel_a_in and channel_b_in;
      --OR
      when "0001"          => result_s <= channel_a_in or channel_b_in;
      --ADD
      when "0010"          => result_s <= channel_a_in + channel_b_in;
      --SUB
      when "0110"          => result_s <= channel_a_in - channel_b_in;
      --SLT
      when "0111"          => if channel_a_in < channel_b_in then
                                 result_s <= (others => '1');
                              else
                                 result_s <= (others => '0');
                              end if;
      --NOR
      when "1100"          => result_s <= channel_a_in nor channel_b_in;
      when others          => result_s <= (others => '0');
    end case;
  end process;

  alu_result_out <= result_s;
  zero_out <= '1' when result_s = 0 else '0';

end Behavioral;

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity memory is
  generic (
    COE_FILE_NAME        : string   := "init2.coe"
    );
  port (
	 clk						 : in std_logic;
    rst                  : in std_logic;
    instr_read_address   : in std_logic_vector(7 downto 0);
    instr_instruction    : out std_logic_vector(31 downto 0);
    data_mem_write       : in std_logic;
    data_address         : in std_logic_vector(7 downto 0);
    data_write_data      : in std_logic_vector(31 downto 0);
    data_read_data       : out std_logic_vector(31 downto 0)
    );
end memory;

architecture Behavioral of memory is
  type MEMORY_BUFFER is array(255 downto 0) of std_logic_vector(31 downto 0);
  signal buff      : MEMORY_BUFFER;
  
begin

  process (rst, clk, instr_read_address, data_mem_write, data_address, data_write_data, buff)
    file     coe_file  :   text;
    variable coe_line  :   line;
    variable coe_str   :   bit_vector(31 downto 0);
    variable coe_status:   file_open_status;
  begin
    if rst = '1' then
      
      file_open(coe_status, coe_file, COE_FILE_NAME, read_mode);
      
      if coe_status = OPEN_OK then
        for i in 0 to 255 loop
          if not endfile(coe_file) then
            readline(coe_file, coe_line);
            read(coe_line, coe_str);
            buff(i) <= to_StdLogicVector(coe_str);
          else
            buff(i) <= (others => '0');
          end if;
        end loop;
        file_close(coe_file);
      else
        report "Could not open COE file" severity warning;
        for i in 0 to 255 loop
          buff(i) <= (others => '0');
        end loop;
        
      end if;
      
      instr_instruction <= (others => '0');
      data_read_data      <= (others => '0');
    else
		if rising_edge(clk) and data_mem_write = '1' then
				buff(conv_integer(data_address)) <= data_write_data;
		end if;
		
      instr_instruction <= buff(conv_integer(instr_read_address));
      data_read_data <= buff(conv_integer(data_address));
    end if;
  end process;


end Behavioral;


-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.cpu_constant_library.all;

entity alu_control is
  port (
    alu_op            : in std_logic_vector(1 downto 0);
    instruction_5_0   : in std_logic_vector(5 downto 0);
    alu_out           : out std_logic_vector(3 downto 0)
    );
end alu_control;

architecture Behavioral of alu_control is

begin

  process (alu_op, instruction_5_0) 
  begin
    if alu_op = "00" then -- LW or SW
      alu_out <= ALU_ADD;
      
    elsif alu_op = "01" then -- branch
      alu_out <= ALU_SUB;
      
    else -- R_Type
      case instruction_5_0 is
        when FUNCT_AND       =>      alu_out <= ALU_AND;
        when FUNCT_OR        =>      alu_out <= ALU_OR;
        when FUNCT_ADD       =>      alu_out <= ALU_ADD;
        when FUNCT_SUB 		  =>      alu_out <= ALU_SUB;
        when FUNCT_SLT		  =>      alu_out <= ALU_SLT;
        when FUNCT_NOR       =>      alu_out <= ALU_NOR;
        when others          =>      alu_out <= (others => '0');
      end case;
    end if;
  end process;

end Behavioral;


-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.cpu_constant_library.all;

entity control_unit is
  port (
    instr_op           : in std_logic_vector(5 downto 0);
    reg_dst           : out std_logic;
    branch            : out std_logic;
    mem_read          : out std_logic;
    mem_to_reg        : out std_logic;
    alu_op            : out std_logic_vector(1 downto 0);
    mem_write         : out std_logic;
    alu_src           : out std_logic;
    reg_write         : out std_logic
    );
end control_unit;

architecture Behavioral of control_unit is

begin
  
  process (instr_op)
  begin
    reg_dst     <= '0';
    branch      <= '0';
    mem_read    <= '0';
    mem_to_reg  <= '0';
    alu_op      <= (others => '0');
    mem_write   <= '0';
    alu_src     <= '0';
    reg_write   <= '0';
    
    case instr_op is
      when OPCODE_R_TYPE =>         reg_dst    <= '1';
                                    reg_write  <= '1';
                                    alu_op     <= "10";
      
      when OPCODE_ADD_I =>           alu_src    <= '1';
                                    reg_write  <= '1';
                                                
      when OPCODE_LOAD_WORD =>      alu_src    <= '1';
                                    mem_to_reg <= '1';
                                    reg_write  <= '1';
                                    mem_read   <= '1';
                                        
      when OPCODE_STORE_WORD =>     alu_src    <= '1';
                                    mem_write  <= '1';
                                        
      when OPCODE_BRANCH_EQ =>      branch     <= '1';
                                    alu_op     <= "01";
                                        
      when others =>
        
    end case;
  end process;
  
end Behavioral;
