library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_Std.all;
entity ALU_CU is 
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		RESULT : out signed(N-1 downto 0)
		) ;
end ALU_CU;

architecture beh of ALU_CU is
begin
process ( IN_0, IN_1)
begin
RESULT <= IN_0 + IN_1;
end process;

end beh;