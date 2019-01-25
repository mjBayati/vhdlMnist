library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

use work.array_pkg.all;

entity testbench is 
	generic(inputCount : Integer := 8; vectorLength : Integer := 16); 
end testbench;

architecture implementation of testbench is
	constant clk_period : time := 6 ns;
	signal clk, reset, start : std_logic :='0';
	signal inputV : array_2d(inputCount - 1 downto 0);
	signal weightV : array_2d(inputCount - 1 downto 0);
	signal neuronOutput: std_logic_vector(vectorLength-1 downto 0);
	signal i : integer := 0;
	signal done: std_logic := '0';

	component ToplevelComponent is
		generic(inputCount : Integer := 8; vectorLength : Integer := 16); 
		port(clk, reset : in std_logic;
			inputV, weightV : in array_2d;
			neuronOutput: out std_logic_vector
			);
	end component;
	for all : ToplevelComponent use entity work.neuron(implementation);
begin
	x: ToplevelComponent port map(
		clk => clk,
		reset => reset,
		inputV => inputV,
		weightV => weightV,
		neuronOutput => neuronOutput
		);
	weightV <= (
				"0000001100011000",
				"0000110001000010",
				"0001100001101110",
				"0100100100111000",
				"0100100101100010",
				"0100100101011000",
				"0100010101101010",
				"0100101010100111"
				);
	inputV <= (
				"0001100111101011",
				"0001101011101111",
				"0000011010101110",
				"1101110101010101",
				"1101111010111101",
				"0100101001011101",
				"0000110101010101",
				"0001001010010111"
				);
	clk <= not clk after clk_period/2 when done = '0';
	process(clk)
	begin 
		i <= i + 1;
		if i = 2 then
			reset <= '1';
		elsif i = 4 then
			reset <= '0';
		elsif i = 90 then
			done <= '1';
		end if;	
		--clk <= not clk after clk_period/2;
		--clk <= not clk after clk_period/2;
		--clk <= not clk after clk_period/2;
		--for i in  vectorLength*5 + 5 downto 0 loop
		--	clk <= not clk after clk_period /2;
		--end loop ;
	end process;	
end implementation;