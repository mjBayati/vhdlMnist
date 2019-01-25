library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_bit.all;

entity MACtoplevel is 
	generic(vectorLength : Integer := 16);
	port(
	    clk : in std_logic;
	    reset: in std_logic;
	    en_mac: in std_logic;
	    input_first: IN STD_LOGIC_VECTOR(vectorLength-1 downto 0);
		weight: IN STD_LOGIC_VECTOR(vectorLength-1 downto 0);

		pastInput: IN STD_LOGIC_VECTOR(vectorLength-1 downto 0);

		output_num: out STD_LOGIC_VECTOR(vectorLength-1 downto 0);
		mult_result: out std_logic_vector(vectorLength-1 downto 0);
		overflow: out std_logic
);
end MACtoplevel;

ARCHITECTURE description OF MACtoplevel IS
signal adderInput: STD_LOGIC_VECTOR(vectorLength - 1 downto 0);
signal adder_out_result: STD_LOGIC_VECTOR(vectorLength-1 downto 0);
signal accu_result: STD_LOGIC_VECTOR(vectorLength-1 downto 0):= (vectorLength-1 downto 0 => '0');
signal adder_ov: std_logic := '0';
signal temp_ov: std_logic := '0';
signal mult_ov: std_logic := '0';
signal output_temp: std_logic_vector(vectorLength-1 downto 0):= (vectorLength-1 downto 0 => '0'); 
--BEGIN
	component adder1 port(
		adder_input_first, adder_input_second: in STD_LOGIC_VECTOR;
		adder_output_num: out STD_LOGIC_VECTOR;
		adder_overflow: out std_logic
		);
	end component;

	component mult3 port(
		mult_input_num_first, mult_input_num_second: in STD_LOGIC_VECTOR;
		mult_output_num: out STD_LOGIC_VECTOR;
		mult_overflow: out std_logic
		);
	end component;

	component reg2 port(
		reg_input_num: in STD_LOGIC_VECTOR;
		clk, reset: in std_logic;
		reg_output_num: out STD_LOGIC_VECTOR
		);
	end component;

	for all: adder1 use entity work.adder(description);
	for all: reg2 use entity work.register_16(description);
	for all: mult3 use entity work.multiplier(mult);
BEGIN
	process(clk)
	begin
		if (rising_edge (clk) and input_first = pastInput) then
			adderInput <= pastResultMatrice;
		else
			adderInput <= mult_result;
		end if;
	end process;

	multiplier: mult3 port map(
		mult_input_num_first => input_first,
		mult_input_num_second => weight,
		mult_output_num=> mult_result,
		mult_overflow => mult_ov
		);
	adder: adder1 port map(
		adder_input_first => adderInput,
		adder_input_second => accu_result,
		adder_output_num => adder_out_result,
		adder_overflow => adder_ov
		);
	reg: reg2 port map(
		reg_input_num => adder_out_result,
		clk => clk,
		reset => reset, 
		reg_output_num => accu_result
		);
	output_temp <= accu_result when en_mac = '1' else output_temp;
	output_num <= output_temp;
	temp_ov <= adder_ov or mult_ov or temp_ov;
	overflow <= temp_ov;   

END description;
