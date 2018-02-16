library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_Std.all;
entity ALU is 
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		S_IN_1 : IN STD_LOGIC;
		clk : in std_logic;
		RESULT : out signed(N-1 downto 0)
		) ;
end ALU;

architecture beh of ALU is

signal SUPP : signed(N-1 downto 0);

begin
	SUPP <= IN_0 + IN_1 when S_IN_1 = '0' else
			IN_0 - IN_1;
			  
	P0 : process (clk)
	begin
		if clk'event and clk='1' then 
			RESULT <= SUPP ;
		end if;
	end process P0;
end beh;