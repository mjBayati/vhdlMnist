library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use ieee.numeric_bit.UNSIGNED;


entity controller is 
	generic(vectorLength : Integer := 16; inputCount : Integer := 62);
	port(
    clk, start : in std_logic;
 	nextNum, ready, done, reset: out std_logic
);
end controller;

architecture implementation of controller is
	signal counter: Integer:= 0;
	signal state: Integer := 0;
begin
	process(clk)
	begin
		if(clk'event and clk='1' and state = 1) then
			counter <= counter + 1;
		elsif (clk'event and clk = '1' and start = '1') then 
			counter <= 0;
		end if;
	end process;
	process(clk)
	begin
    	if (clk'event and clk='1' and state = 1) then 
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
			if (counter > inputCount + 3) then
				done <= '1';
			else 
				done <= '0';

			end if;
		end if;
	end process ;
	process(clk)
	begin 
		if(rising_edge(clk) and start = '1') then
			state <= 1;
		elsif(rising_edge(clk) and counter > inputCount + 3) then
			state <= 0;
		end if;
	end process;

end implementation ; -- 