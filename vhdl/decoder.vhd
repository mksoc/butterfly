library IEEE;	
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity decoder is
Port ( sel : in STD_LOGIC_VECTOR (3 downto 0);
y : out STD_LOGIC_VECTOR (14 downto 0));
end decoder;

architecture Behavioral of decoder is
begin
with sel select
y<="000000000000001" when "0000",
"000000000000010" when "0001",
"000000000000100" when "0010",
"000000000001000" when "0011",
"000000000010000" when "0100",
"000000000100000" when "0101",
"000000001000000" when "0110",
"000000010000000" when "0111",
"000000100000000" when "1000",
"000001000000000" when "1001",
"000010000000000" when "1010",
"000100000000000" when "1011",
"001000000000000" when "1100",
"010000000000000" when "1101",
"100000000000000" when "1110",
"000000000000001" when others;

end Behavioral;
