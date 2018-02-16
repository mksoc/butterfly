-- file butterflyTB_read_input.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity read_input is
    port (clock: in std_logic;
          read_enable: in std_logic;
		  start_out: out std_logic;
          data_out: out signed(23 downto 0);
		  twiddle_out: out signed(23 downto 0));
end read_input;

architecture behavior of read_input is
begin
    read_data: process
        -- open file in read mode and define line and data variables
        file in_file: text open read_mode is "../inputVectors.txt";
        variable in_line: line;
        variable Br, Wr, Bi, Wi, Ar, Ai: integer := 0;
		variable space: character;
    begin
		wait until read_enable'event and read_enable = '1';
		while not endfile(in_file) loop
			-- read data in line
			readline(in_file, in_line);
			read(in_line, Br);
			report "in_line: '" & in_line.all & "'";
			read(in_line, Wr);
			report "in_line: '" & in_line.all & "'";
			read(in_line, Bi);
			report "in_line: '" & in_line.all & "'";
			read(in_line, Wi);
			report "in_line: '" & in_line.all & "'";
			read(in_line, Ar);
			report "in_line: '" & in_line.all & "'";
			read(in_line, Ai);
			report "in_line: '" & in_line.all & "'";
			
			-- send Br and Wr
			wait until clock'event and clock = '1';
			start_out <= '1';
			data_out <= to_signed(Br, 24);
			twiddle_out <= to_signed(Wr, 24);
			
			-- send Bi and Wi
			wait until clock'event and clock = '1';
			start_out <= '0';
			data_out <= to_signed(Bi, 24);
			twiddle_out <= to_signed(Wi, 24);
			
			-- send Ar
			wait until clock'event and clock = '1';
			data_out <= to_signed(Ar, 24);
			
			-- send Ai
			wait until clock'event and clock = '1';
			data_out <= to_signed(Ai, 24);
			
			-- wait 
			wait until clock'event and clock = '1';
			wait until clock'event and clock = '1';
			wait until clock'event and clock = '1';
			wait until clock'event and clock = '1';
			wait until clock'event and clock = '1';
			wait until clock'event and clock = '1';
			wait until clock'event and clock = '1';
			--wait until clock'event and clock = '1';
			--wait until clock'event and clock = '1';
		end loop;
    end process;
end behavior;