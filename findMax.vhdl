library ieee;
use ieee.std_logic_1164.all;
use work.array_pkg.all;

entity findMax is 
	generic (outputCnt : integer := 10);
	port (
		clk : in std_logic;
		results : in array_2d(outputCnt-1 downto 0);
		index : out integer
	);
end findMax;

architecture implementation of findMax is 
begin
	process (clk)
		variable m1, m2, m3, m4, m5, m6, m7, m8 : std_logic_vector(15 downto 0);
		variable i1, i2, i3, i4, i5, i6, i7, i8, i9 : integer := 0; 
	begin
		if results(0) > results(1) then
			m1 := results(0);
			i1 := 0;
		else
			m1 := results(1);
			i1 := 1;
		end if;
		
		if results(2) > results(3) then
			m2 := results(2);
			i2 := 2;
		else
			m2 := results(3);
			i2 := 3;
		end if;
		
		if results(4) > results(5) then
			m3 := results(4);
			i3 := 4;
		else
			m3 := results(5);
			i3 := 5;
		end if;

		if results(6) > results(7) then
			m4 := results(6);
			i4 := 6;
		else 
			m4 := results(7);
			i4 := 7;
		end if;

		if results(8) > results(9) then 
			m5 := results(8);
			i5 := 8;
		else
			m5 := results(9);
			i5 := 9;
		end if;

		if m1 > m2 then 
			m6 := m1;
			i6 := i1;
		else 
			m6 := m2;
			i6 := i2;
		end if;

		if m3 > m4 then
			m7 := m3;
			i7 := i3; 
		else
			m7 := m4;
			i7 := i4;
		end if;

		if m6 > m7 then
			m8 := m6;
			i8 := i6;
		else
		 	m8 := m7;
		 	i8 := i7; 
		end if; 

		if m8 > m5 then
			index <= i8;
		else
			index <= i5;
		end if;
		
	end process;
end implementation;
