library ieee;
use ieee.std_logic_1164.all;

package imageSelectorPkg is 
  type array_2d is array(natural range <>) of std_logic_vector(15 downto 0);
  subtype imageArray is array_2d(61 downto 0);
  type matriceArray is array(natural range <>) of imageArray;
  subtype matArr is matriceArray(749 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use work.imageSelectorPkg.all;

entity imageSelector is
	generic (imageCnt : integer := 750; featureCnt : integer := 62);
	port (
		clk : in std_logic;
		images : in matArr;
		giveNext : in std_logic;
		endOfImages : out std_logic;
		outImage : out array_2d(featureCnt-1 downto 0)
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
				outImage <= (featureCnt - 1 downto 0 => (others => '0'));
			end if;
		end if;
		if index = imageCnt - 1 then
			endOfImages <= '1';
		else
			endOfImages <= '0';
		end if;
	end process;

end implementation;
