library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_arith.SIGNED;

entity ActivationFunction is 
	generic (bitVectorLength: integer:= 4);
	port(ready: in std_logic;
		input_vector: in std_logic_vector (bitVectorLength - 1 downto 0);
		output_vector: out std_logic_vector (bitVectorLength - 1 downto 0));
end entity;

architecture description of ActivationFunction is
	signal middle: std_logic_vector(bitVectorLength - 1 downto 0);
begin
	middle <= (1 => '1', others => '0');
	process(ready)
    begin
    if (ready = '1') then 
      if (signed(input_vector) > signed(middle)) then
        output_vector <= input_vector;
      elsif (signed(input_vector) <= signed(middle)) then
      	output_vector <= (bitVectorLength - 1 downto 0 => '0');
      end if;
    else
    	output_vector <= (bitVectorLength - 1 downto 0 => '0');
  	end if;end process;
end description;