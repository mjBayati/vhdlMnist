library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

package array_pkg is 
  type array_2d is array(natural range <>) of std_logic_vector(15 downto 0);
end package;

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;
use work.array_pkg.all;

entity inputSelection is 
generic(inputCount : Integer; vectorLength : Integer);
port(inputVector, weightVector, pastInputVector: in  array_2d(inputCount - 1 downto 0);
  nextNumber, clk : in std_logic;
  value, weight, pastInput: out std_logic_vector(vectorLength-1 downto 0));
  
end inputSelection;

architecture implementation of inputSelection is
  signal index: Integer := 0;
begin
  process(nextNumber, clk)
    begin
    if (clk'event and clk='1' and nextNumber='1') then 
      if (index < inputCount) then
        value <= inputVector(index);
        weight <= weightVector(index);
        pastInput <= pastInputVector(index);
        index <= index + 1;
      else 
        value <= (vectorLength-1 downto 0 => '0');
        weight <= (vectorLength-1 downto 0 => '0');
        pastInput <= (vectorLength-1 downto 0 => '0');
      end if;
      
    end if;
  end process;
end implementation;
