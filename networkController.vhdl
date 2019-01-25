library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

entity networkController is 
	port (
		clk, reset : in std_logic;
		start, firstLayerDone, secondLayerDone : in std_logic;
		startFirstLayer, startSecondLayer, giveNextImg : out std_logic
	);
end networkController;

architecture implementation of networkController is 
	type stateTypes is (idle, getImg, initFirst, waitFirst, initSecond, waitSecond, findMax);
	signal stateReg, stateNext: stateTypes;
begin

	--state register
	process (clk, reset)
	begin
		if (reset='1') then
			stateReg <= idle;
		elsif(rising_edge(clk)) then
			stateReg <= stateNext;
		end if;
	end process;

	--next state
	process (stateReg, firstLayerDone, secondLayerDone)
	begin
		case stateReg is 
			when idle =>
				if start = '1' then
					stateNext <= getImg;
				else
					stateNext <= idle;
				end if;

			when getImg =>
				stateNext <= initFirst;

			when initFirst =>
				stateNext <= waitFirst;

			when waitFirst =>
				if firstLayerDone = '1' then
					stateNext <= initSecond;
				else
					stateNext <= waitFirst;
				end if;

			when initSecond =>
				stateNext <= waitSecond;

			when waitSecond =>
				if secondLayerDone = '1' then
					stateNext <= findMax;
				else 
					stateNext <= waitSecond;
				end if;

			when findMax => 
				stateNext <= idle;

		end case;
	end process;

	--output generation
	process (stateReg) 
	begin
		giveNextImg <= '0';
		startFirstLayer <= '0';
		startSecondLayer <= '0';
		case stateReg is 
			when idle =>

			when getImg =>
				giveNextImg <= '1';

			when initFirst =>
				startFirstLayer <= '1';

			when waitFirst =>

			when initSecond =>
				startSecondLayer <= '1';

			when waitSecond =>

			when findMax =>


		end case;
	end process;

end implementation;
