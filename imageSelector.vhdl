library ieee;
use ieee.std_logic_1164.all;
use work.array_pkg.all;

entity imageSelector is
	generic (imageCnt : integer := 750; featureCnt : integer := 62);
	port (
		clk : in std_logic;
		images : in inputMatrice(imageCnt-1 downto 0)(featureCnt-1 downto 0);
		giveNext : in std_logic;
		endOfImages : out std_logic;
		outImage : out inputArray(featureCnt-1 downto 0)
	);
end imageSelector;

architecture implementation of imageSelector is
	signal index: integer := 0;
begin
	process (clk, giveNext)
	begin
		if (clk'event and clk='1' and giveNext='1') then
			outImage <= images(index);
			index <= index + 1;
			if (index >= imageCnt) then
				outImage <= (others => '0');
			end if;
		end if;
		if index = imageCnt - 1 then
			endOfImages <= '1';
		else
			endOfImages <= '0';
		end if;
	end process;

end implementation;
