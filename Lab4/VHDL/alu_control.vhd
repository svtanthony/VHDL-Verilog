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

	process(alu_op, instruction_5_0)
	begin
		if alu_op = ALU_OP_L_S then
			-- load/store op
			alu_out <= ALU_ADD;
		elsif alu_op = ALU_OP_BEQ then
			-- branch equals
			alu_out <= ALU_SUB;
		elsif alu_op = ALU_OP_R_TYPE then
			-- r-type instruction
			case instruction_5_0 is
				when FUNCT_ADD =>
					-- add instr
					alu_out <= ALU_ADD;
				when FUNCT_SUB =>
					-- subtraction instr
					alu_out <= ALU_SUB;
				when FUNCT_AND =>
					-- AND instr
					alu_out <= ALU_AND;
				when FUNCT_OR =>
					-- OR instr
					alu_out <= ALU_OR;
				when FUNCT_SLT =>
					-- set on less than instr
					alu_out <= ALU_SLT;
				when FUNCT_NOR =>
					-- nor instr
					alu_out <= ALU_NOR;
				when FUNCT_ADDU =>
					-- add unsigned
					alu_out <= ALU_ADD;
				when others =>
					alu_out <= "XXXX";
			end case;
		end if;
	end process;
end Behavioral;
