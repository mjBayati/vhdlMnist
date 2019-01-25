library ieee;
--use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.or_reduce;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

ENTITY adder IS 
	generic(vectorLength : Integer := 16);
	PORT(
	adder_input_first: IN STD_LOGIC_VECTOR(vectorLength -1 downto 0);
	adder_input_second: IN STD_LOGIC_VECTOR(vectorLength -1 downto 0);
	adder_output_num: OUT STD_LOGIC_VECTOR(vectorLength -1 downto 0);
	adder_overflow: out std_logic 
	);

END adder;

ARCHITECTURE description OF adder IS 
signal temp_adder_result: signed(vectorLength - 1 downto 0);
signal a, b: signed(vectorLength - 1 downto 0);
signal temp: STD_LOGIC_VECTOR(2 downto 0);
BEGIN
	a <= resize(signed(adder_input_first), vectorLength);
	b <= resize(signed(adder_input_second), vectorLength);

	temp_adder_result <= a + b;

	--temp_adder_result <= STD_LOGIC_VECTOR(('0' & adder_input_first) + ('0' & adder_input_second));
	
	adder_output_num <= STD_LOGIC_VECTOR(resize(temp_adder_result, vectorLength));
	
	temp <= a(a'high) & b(b'high) & temp_adder_result(temp_adder_result'high);
	process(temp)
	begin
	     adder_overflow <= '0';
	     if    (temp = "001" or temp = "110") then adder_overflow <= '1'; 
	     else                             		   adder_overflow <= '0';
	     end if;
	end process;
	--adder_overflow <= (temp = "001") or (temp = "110");
END description;