-- file butterflyTB_write_output.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity write_output is 
    port (clock: in std_logic;
          enable: in std_logic; -- this will be the DONE signal 
          data_in: in signed(23 downto 0));
end write_output;

architecture behavior of write_output is    
    signal data_in_int: integer;
    
begin
    output_data: process
        -- open file in write mode and define line variable
        file output_file: text open write_mode is "../outputFromButterfly.txt";
        variable buf_line: line;
    begin
        wait until enable'event and enable = '1';
		for i in 1 to 4 loop
			wait until clock'event and clock = '1';
			write(buf_line, to_integer(data_in)); -- write data to buffer
			write(buf_line, string'(" ")); -- write a space
		end loop;	
		
		report "Written: '" & buf_line.all & "'";
        writeline(output_file, buf_line); -- write buffer to file
		
    end process;
end behavior;