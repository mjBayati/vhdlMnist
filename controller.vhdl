library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use ieee.numeric_bit.UNSIGNED;


entity controller is 
	generic(vectorLength : Integer := 16; inputCount : Integer := 62);
	port(
    clk : in std_logic;
 	nextNum, ready: out std_logic
);
end controller;

architecture implementation of controller is
	signal counter: Integer:= 0;
begin
	process(clk)
	begin
		if(clk'event and clk='1') then
			counter <= counter + 1;
		end if;
	end process;
	process(clk)
	begin
    	if (clk'event and clk='1') then 
			if (counter < inputCount + 2) then
				nextNum <= '1';
			else 
				nextNum <= '0';
			end if;
			if (counter > inputCount + 2) then
				ready <= '1';
			else
				ready <= '0';
			end if;
		end if;
	end process ;
end implementation ; -- 