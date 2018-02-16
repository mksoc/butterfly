library ieee;
use ieee.std_logic_1164.all;

entity PLA is 
port( start,CC_ROM,STARTX_8 : in std_logic;
		Cond : in std_logic_vector(1 downto 0);
		OUT_PLA : out std_logic
);
end PLA ;

architecture beh of PLA is 

begin

OUT_PLA <= (not(COND(0)) and CC_ROM) or (COND(1) and CC_ROM and NOT(STARTX_8)) or (not(COND(1)) and CC_ROM and NOT(START)) ;

end beh;