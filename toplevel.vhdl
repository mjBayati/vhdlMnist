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


entity neuron is
	generic(inputCount : Integer := 62;
		vectorLength : Integer := 16;
		firstLayerCount: Integer :=20
	); 
	port(clk, reset : in std_logic;
		inputV, weightV : in array_2d(inputCount - 1 downto 0);
		neuronOutput: out std_logic_vector(vectorLength-1 downto 0)
	);
end neuron;

architecture implementation of neuron is
	signal overflow : std_logic :='0';
	signal firstInput, weight: std_logic_vector(vectorLength-1 downto 0);
	signal macResult: std_logic_vector(vectorLength-1 downto 0);
	signal controllerReady, controllerNext : std_logic;
	signal neuronOutputTemp: std_logic_vector(vectorLength-1 downto 0);
	signal result_matrice: inputMatrice(firstlayerCount - 1 downto 0)(inputCount - 1 downto 0);

	signal pastResult: std_logic_vector(vectorLength-1 downto 0);
	signal layerIndex, inputIndex: Integer:= 0;
	signal	mult_result: std_logic_vector(vectorLength-1 downto 0);

	component MAC_component is 
	generic(vectorLength : Integer := 16); 
	port(
	clk : in std_logic;
    reset: in std_logic;
    en_mac: in std_logic;
    input_first: IN STD_LOGIC_VECTOR;
	weight: IN STD_LOGIC_VECTOR;

	pastInput: IN STD_LOGIC_VECTOR;
	pastResultMatrice: in STD_LOGIC_VECTOR;

	output_num: out STD_LOGIC_VECTOR;
	mult_result: out std_logic_vector;
	overflow: out std_logic
	);
	end component;
	for all: MAC_component use entity work.MACtoplevel(description);


	component InputSelectionComponent is 
	generic(inputCount : Integer := 62; vectorLength : Integer := 16);
	port(
		inputVector, weightVector, pastInputVector: in  array_2d;
		nextNumber, clk : in std_logic;
		value, weight, pastInput: out std_logic_vector
		);
	end component;
	for all: InputSelectionComponent use entity work.inputSelection(implementation);

	component ActivationFunctionComponent is 
	generic (bitVectorLength: integer:= 16);
	port(
		ready: in std_logic;
		input_vector: in std_logic_vector;
		output_vector: out std_logic_vector
		);
	end component;
	for all: ActivationFunctionComponent use entity work.ActivationFunction(description);

	component ControllerComponent is 
	generic(inputCount : Integer := 8; vectorLength : Integer := 16); 
	port(
		clk : in std_logic;
 		nextNum, ready: out std_logic
		);
	end component;
	for all: ControllerComponent use entity work.controller(implementation);

BEGIN
	neuronOutput <= neuronOutputTemp;
	process(clk)
	begin
		if (rising_edge (clk)) then
			result_matrice(layerIndex)(inputIndex) := mult_result;
			layerIndex := layerIndex + 1;			
		end if;
	end process;
 	-- do some thing for leyer index
 	-- the first hidden layer is ready
 	-- now think about matching this stuff
 	
	mac: MAC_component port map(
		clk => clk,
		reset => reset,
		en_mac => controllerNext,
		input_first => firstInput,
		weight => weight,
		pastInput => pastResult,
		pastResultMatrice => result_matrice(layerIndex)(inputIndex)
		output_num => macResult,
		mult_result => mult_result,
		overflow => overflow
		);

	func: ActivationFunctionComponent port map(
		ready => controllerReady,
		input_vector => macResult,
		output_vector => neuronOutputTemp
		);

	selector: InputSelectionComponent port map(
		inputVector => inputV, 
		weightVector => weightV,
		pastInputVector => result_matrice(layerIndex),
		nextNumber => controllerNext, 
		clk => clk,
		value => firstInput, 
		weight => weight,
		pastInput => pastResult 
		);


	controller: ControllerComponent port map(
		clk => clk,
 		nextNum => controllerNext,
 		ready => controllerReady
		);

	  
  

END implementation;





