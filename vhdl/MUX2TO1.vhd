library ieee;
use ieee.std_logic_1164.all; 

entity MUX2TO1 is 
GENERIC ( N : NATURAL := 25);
port(
		IN_0 : in STD_LOGIC_vector(N-1 downto 0);
		IN_1 : in STD_LOGIC_vector(N-1 downto 0);
		SEL  : IN STD_LOGIC;
		OUT_M : OUT STD_LOGIC_vector(N-1 downto 0)
);
END MUX2TO1;

ARCHITECTURE BEH OF MUX2TO1 IS 
BEGIN 
p0 : PROCESS (SEL,IN_0 ,IN_1)
BEGIN 
IF SEL = '1'  THEN 
OUT_M<=IN_1 ;
ELSE 
OUT_M<=IN_0 ;
END IF ;
END PROCESS P0;
END BEH ; 