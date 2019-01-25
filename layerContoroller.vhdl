library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

entity layerContoroller is
	generic(
		layerCount: Integer
	);
	port(
		clk, reset: in std_logic;
		start: in std_logic;
		neuronDone: in std_logic;
		startNeuron: out std_logic;
		done: out std_logic;
		layerIndex: Integer
	);
end layerContoroller;

architecture layerContorollerImplementation of layerContoroller is
	signal counter: Integer := 0;
	signal state: Integer := 0;
begin 
	 	controllerStates : process(clk)
		begin 
			if(rising_edge(clk) and  start = '1') then
				if(start = '1' and state = 0) then
					state <= 1;
				elsif (state = 1 and counter < layerCount) then 
					startNeuron <= '1';
					state <= 2;
				elsif (state = 1 and counter = layerCount) then 
					state <= 3;
				elsif(state = 2 and neuronDone = '1') then 
					state <= 1;
				elsif(state = 3) then 
					state <= 0;
					done <= '1';
				else
					done <= '0';
					startNeuron <= '0';
					state <= 0;
				end if;
			end if;				
		end process;


		counterImplementation : process(clk, reset)
		begin
			if (reset) then 
				counter <= 0;
			elsif (state = 2 and rising_edge(clk) and neuronDone = '1') then 
				counter <= counter + 1;
			elsif (state = 3 and rising_edge(clk)) then 
				counter <= 0; 
			end if;
		end process;
		layerIndex <= counter;

end layerContorollerImplementation;