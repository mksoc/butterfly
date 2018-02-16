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

COMPONENT FullAdder
PORT (a,b,ci: IN STD_LOGIC;
      s, co: OUT STD_LOGIC);
end component;

SIGNAL A1, B1: SIGNED (N-1 DOWNTO 0);
SIGNAL C: STD_LOGIC_VECTOR(N DOWNTO 0);
signal SUPP : signed(N-1 downto 0);
begin

--N bit adder


NEGAZIONE : FOR I IN 0 TO N-1 GENERATE
B1(I) <= IN_1(I) XOR S_IN_1;
A1(I) <= IN_0(I) ;
END GENERATE NEGAZIONE;

C(0)<= S_IN_1; 

GEN_ADD: FOR I IN 0 TO N-1 GENERATE
FA : FullAdder PORT MAP (A1(I), B1(I), C(I), SUPP(I), C(I+1));
END GENERATE GEN_ADD;



P0 : process (clk)
begin
if clk'event and clk='1' then 
RESULT <= SUPP ;
end if;
end process P0;
end beh;