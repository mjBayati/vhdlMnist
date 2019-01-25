library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

package array_pkg is 
  type array_2d is array(natural range <>) of std_logic_vector(15 downto 0);
  type inputArray is array(natural range <>) of std_logic_vector(15 downto 0);
  type inputMatrice is array(natural range <>) of inputArray;
end package;

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;
use work.array_pkg.all;


entity layer is
	generic(inputCount : Integer := 62;
		vectorLength : Integer := 16;
		layerCount: Integer :=20
	); 
	port(clk, reset : in std_logic;
		inputV : in array_2d(inputCount - 1 downto 0);
		weightMatrice: in inputMatrice(layerCount-1 downto 0)(inputCount-1 downto 0);
		biasVector: in array_2d(layerCount-1 downto 0);
		neuronStart: in std_logic;
		layerIndex: in Integer;
		isFirstLayer: in std_logic;
		loadNeuronResult: in std_logic;
		neuronDone: out std_logic;
		layerOutput: out array_2d(layerCount-1 downto 0)
	);
end layer;

architecture layerImplementation of layer is
	signal weightV: array_2d(inputCount-1 downto 0);
	signal neuronOutput: std_logic_vector(vectorLength-1 downto 0);
	--signal counter: Integer:= 0;

	component neuronComponent is
		generic(inputCount : Integer := 62;
			vectorLength : Integer := 16;
			firstLayerCount: Integer :=20
		); 
		port(clk, reset : in std_logic;
			start: in std_logic;
			inputV, weightV : in array_2d(inputCount - 1 downto 0);
			isFirstLayer: in std_logic;
			neuronOutput: out std_logic_vector(vectorLength-1 downto 0);
			done: out std_logic
		);
	end component;
	for all: neuronComponent use entity work.neuron(implementation);

	begin

		neuron: neuronComponent port map(
			clk => clk,
			reset => reset,
			start => neuronStart,
			inputV => inputV,
			weightV => weightMatrice(layerIndex),
			isFirstLayer => isFirstLayer,
			neuronOutput => neuronOutput,
			done => neuronDone	
		);

	process(clk, loadNeuronResult)
	begin 
		if(clk = '1' and loadNeuronResult = '1' and rising_edge(loadNeuronResult)) then
			layerOutput(layerIndex) <= neuronOutput;
		end if;
	end process;
		
END layerImplementation;





