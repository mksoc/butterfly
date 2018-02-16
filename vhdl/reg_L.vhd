library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- FF CON RESET ATTIVO BASSO E CAMPIONAMENTO SU FRONTE DI DISCESA
entity reg_L is
GENERIC ( N : NATURAL := 25);
   port
   (
      CLK : in std_logic;
      CLRN : in std_logic;
      ENA : in std_logic;      
      D : in std_logic_vector(N-1 downto 0);
      Q : out std_logic_vector(N-1 downto 0)
   );
end  reg_L;
 
architecture Behavioral of reg_L is
begin
 P0 :  process (CLK,CLRN) 
BEGIN

IF (CLRN ='0') THEN
Q<=(others => '0'); --uscita del registro

ELSIF ((CLK'EVENT ) AND (CLK = '0')) THEN

IF (ENA='1') THEN --viene abilitata l'uscita
Q<= D;
END IF;
END IF;
   end process P0;
end Behavioral;