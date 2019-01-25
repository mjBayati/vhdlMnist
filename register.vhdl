library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


ENTITY register_16 IS
	generic(vectorLength : Integer := 16);
	PORT(
	reg_input_num: IN STD_LOGIC_VECTOR(vectorLength-1 downto 0);
	clk: IN STD_LOGIC;
	reset: IN STD_LOGIC;
	reg_output_num: OUT STD_LOGIC_VECTOR(vectorLength-1 downto 0) 
	);

END register_16;

ARCHITECTURE description OF register_16 IS
BEGIN
	process(clk, reset)
	begin
		if reset = '1' then
			reg_output_num <=(vectorLength-1 downto 0 => '0');
		elsif rising_edge (clk) then
			reg_output_num <= reg_input_num;
		end if;
	end process;
END description ; 

