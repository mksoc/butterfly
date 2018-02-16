library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity testbench_ROM is
end testbench_ROM;

ARCHITECTURE BHV OF Testbench_ROM IS
signal clk,nReset,start : std_logic;

component CU 
port(clk,nReset,start : std_logic);
end component;

begin

ControlUnit : CU port map(
		clk => clk,
		nReset => nReset,
		Start => Start
		);
		 
clk_generator:	process
	begin
	wait for 20ns;
	clk<='1';
	wait for 20ns;
	clk<='0';
	end process clk_generator;
	
reset_generator : process
begin
		nreset <= '0' ;
		wait for 20 ns;
		nreset <= '1';
		wait;
		end process reset_generator;
	
	
end BHV;