library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

package layer_pkg is 
  type array_2d is array(natural range <>) of std_logic_vector(15 downto 0);
  subtype imageArray is array_2d(61 downto 0);
  type matriceArray is array(natural range <>) of imageArray;
  subtype matArr is matriceArray(19 downto 0);
end package;

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;
use work.layer_pkg.all;


entity layer is 
	generic(
		inputCnt : Integer;
		vectorLength : Integer;
		layerCnt: Integer
	);
	port(
		clk, reset, start : in std_logic;
		inputV : in array_2d(inputCnt - 1 downto 0);
		weightMatrice: in matArr;
		biasVector: in array_2d(layerCnt-1 downto 0);
		isFirstLayer: in std_logic;
		layerOutput: out array_2d(layerCnt-1 downto 0);
		done : out std_logic
	);
end layer;

architecture implementation of layer is 
	signal neuronDone, loadNeuronResult : std_logic;
	signal layIndex : Integer;
	component controller is 
		generic(layerCount: Integer := layerCnt);
		port(
			clk, reset: in std_logic;
			start: in std_logic;
			neuronDone: in std_logic;
			startNeuron: out std_logic;
			done: out std_logic;
			layerIndex:out Integer;
			loadNeuronResult: out std_logic
		);
	end component;
	for all: controller use entity work.layerContoroller(layerContorollerImplementation);

	component datapath is 
		generic(inputCount : Integer := inputCnt; vectorLength : Integer := 16;layerCount: Integer := layerCnt);
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
	end component;
	for all: datapath use entity work.layerDatapath(layerImplementation);

	
begin
	
	dp : datapath port map(
		clk => clk;
		reset => reset;
		inputV => inputV;
		biasVector => biasVector;
		neuronStart => neuronStart;
		layerIndex => layIndex;
		isFirstLayer => isFirstLayer;
		loadNeuronResult => loadNeuronResult;
		neuronDone => neuronDone;
		layerOutput => layerOutput
	);

	cu : controller port map(
		clk => clk;
		reset => reset;
		start => start;
		neuronDone => neuronDone;
		startNeuron =>  neuronStart;
		done => done;
		layerIndex => layIndex;
		loadNeuronResult =>  loadNeuronResult
	);

end implementation;
