library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;
use work.array_pkg.all;

entity neuralNetwork is 
	generic (
		imgCnt : integer := 750;
		featureCnt : integer := 62;
		firstLayerCnt : integer := 20;
		secondLayerCnt : integer := 10
	);
	port (
		clk, reset, start : std_logic;
		firstLayerWeights : in InputMatrice(featureCnt-1 downto 0)(firstLayerCnt-1 downto 0);
		firstLayerBias : in array_2d(firstLayerCnt-1 downto 0);
		secondLayerWeights : in InputMatrice(firstLayerCnt-1 downto 0);
		secondLayerBias : in array_2d(secondLayerCnt-1 downto 0);
		images : in InputMatrice(imgCnt-1 downto 0)(featureCnt-1 downto 0);
		done : out std_logic
	);
end neuralNetwork;

architecture implementation of neuralNetwork is 
	component imageSelector is
		generic(imageCnt : integer := 750; featureCnt : integer := 62);
		port (
			clk : in std_logic;
			images : in inputMatrice(imageCnt-1 downto 0)(featureCnt-1 downto 0);
			giveNext : in std_logic;
			endOfImages : out std_logic;
			outImage : out array_2d(featureCnt-1 downto 0)
		);
	end component;
	for all imageSelector use entity work.imageSelector(implementation);


	component firstHiddenLayer is
		generic(
			inputCnt : Integer := 62;
			vectorLength : Integer := 16;
			layerCnt: Integer := 20
		);
		port(
			clk, reset, start : in std_logic;
			inputV : in array_2d(inputCount - 1 downto 0);
			weightMatrice: in inputMatrice(layerCount-1 downto 0)(inputCount-1 downto 0);
			biasVector: in array_2d(layerCount-1 downto 0);
			isFirstLayer: in std_logic;
			layerOutput: out array_2d(layerCount-1 downto 0);
			done : out std_logic
		);
	end component;
	for all firstHiddenLayer use entity work.layer(implementation);

	
	component secondHiddenLayer is
		generic(
			inputCnt : Integer := 20;
			vectorLength : Integer := 16;
			layerCnt: Integer := 10
		);
		port(
			clk, reset, start : in std_logic;
			inputV : in array_2d(inputCount - 1 downto 0);
			weightMatrice: in inputMatrice(layerCount-1 downto 0)(inputCount-1 downto 0);
			biasVector: in array_2d(layerCount-1 downto 0);
			isFirstLayer: in std_logic;
			layerOutput: out array_2d(layerCount-1 downto 0);
			done : out std_logic
		);
	end component;
	for all secondHiddenLayer use entity work.layer(implementation);
	
	component maxLayer is 
		generic (outputCnt : integer := 10);
		port (
			clk : in std_logic;
			results : in array_2d(outputCnt-1 downto 0);
			index : in integer
		);
	end component;
	for all maxLayer use entity work.findMax(implementation);

	component networkController is 
		port (
			clk, reset : in std_logic;
			start, firstLayerDone, secondLayerDone : in std_logic;
			startFirstLayer, startSecondLayer, giveNextImg : out std_logic
		);
	end component;
	for all networkController use entity work.networkController(implementation);

	signal startFirstLayer, startSecondLayer, giveNextImg : std_logic;
	signal firstLayerDone, secondLayerDone, endOfImages : std_logic;
	signal newImage : array_2d(featureCnt-1 downto 0);
	signal firstLayerResult : array_2d(firstLayerCnt-1 downto 0);
	signal secondLayerResult : array_2d(secondLayerCnt-1 downto 0);
	signal predictedDigit : integer;
begin
	
	ims: imageSelector port map(
		clk => clk;
		images => images;
		giveNext => giveNextImg;
		endOfImages => endOfImages;
		outImage => newImage
	);

	fhl: firstHiddenLayer port map(
		clk => clk;
		reset => reset;
		start => startSecondLayer
		inputV => newImage;
		weightMatrice => firstLayerWeights;
		biasVector => firstLayerBias;
		isFirstLayer => '1';
		layerOutput => firstLayerResult;
		done => firstLayerDone

	);

	shl: secondHiddenLayer port map(
		clk => clk;
		reset => reset;
		start => startSecondLayer;
		inputV => firstLayerResult;
		weightMatrice => secondLayerWeights;
		biasVector => secondLayerBias;
		isFirstActive => '0';
		layerOutput => secondLayerResult;
		done => secondLayerDone
	);

	fm: findMax port map(
		clk => clk;
		results => secondLayerResult;
		index => predictedDigit
	);

	cu: networkController port map(
		clk => clk;
		reset => reset;
		start => start;
		firstLayerDone => firstLayerDone;
		secondLayerDone => secondLayerDone;
		startFirstLayer => startFirstLayer;
		startSecondLayer => startSecondLayer;
		giveNextImg => giveNextImg
	);

end implementation;
