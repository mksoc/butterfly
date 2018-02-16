library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_Std.all;
entity Multiplier is 
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		clk : in std_logic;
		RESULT : out signed(((2*N)-2) downto 0)
		) ;
end Multiplier;

architecture beh of Multiplier is
signal Result0 : signed(((2*N)-1) downto 0);
begin 

M0 :process(clk)
begin
if clk'event and clk='1' then 
Result0 <= IN_0 * IN_1;
end if;
end process M0;

M1 :process(clk)
begin
if clk'event and clk='1' then 
Result <= Result0(((2*N)-2) downto 0 );
end if;
end process M1;


end beh ;
