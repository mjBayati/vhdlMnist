library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

ENTITY multiplier IS 
	generic(vectorLength : Integer := 16);
	PORT(
	mult_input_num_first: IN STD_LOGIC_VECTOR(vectorLength-1 downto 0);
	mult_input_num_second: IN STD_LOGIC_VECTOR(vectorLength-1 downto 0);
	mult_output_num: OUT STD_LOGIC_VECTOR (vectorLength-1 downto 0);
	mult_overflow: out std_logic 
	);
END multiplier;

ARCHITECTURE mult OF multiplier IS
signal temp: signed(2*vectorLength-1 downto 0); 
signal a, b : signed(vectorLength - 1 downto 0);
BEGIN
	a <= signed(mult_input_num_first);
	b <= signed(mult_input_num_second); 
	temp <= a*b;
	mult_output_num <= STD_LOGIC_VECTOR(temp(vectorLength-1 downto 0));
	mult_overflow <= '0';
END mult;
