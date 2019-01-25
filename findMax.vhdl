library ieee;
use ieee.std_logic_1164.all;
use work.array_pkg.all;

entity findMax is 
	generic (outputCnt : integer := 10);
	port (
		clk : in std_logic;
		results : in inputArray(outputCnt-1 downto 0);
		index : in integer
	);
end findMax;

architecture implementation of findMax is 
begin
	process (clk) 
		variable maxValue : std_logic_vector(15 downto 0) := (others => '0');
		variable maxIndex : integer := 0;
	begin
		if (clk'event and clk='1') then
			for i in 0 to outputCnt-1 loop
				if signed(results(i)) > signed(maxValue) then
					maxValue := results(i);
					index := i;
				end if;
			end loop;
			index <= i;
		end if;
	end process;
end implementation;
