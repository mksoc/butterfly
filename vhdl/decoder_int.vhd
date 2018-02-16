library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decoder_int is
Port ( sel : in STD_LOGIC_VECTOR (3 downto 0);
y : out INTEGER range 0 to 15);
end decoder_int;

architecture Behavioral of decoder_int is
begin
with sel select
y<= 
0 when "0000",
1 when "0001",
2 when "0010",
3 when "0011",
4 when "0100",
5 when "0101",
6 when "0110",
7 when "0111",
8 when "1000",
9 when "1001",
10 when "1010",
11 when "1011", 
12 when "1100",
0 when others;

end Behavioral;
