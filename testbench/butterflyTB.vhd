-- file butterflyTB.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity butterflyTB is
end butterflyTB;

architecture behavior of butterflyTB is
	--clock period
	constant T: time := 100 ns;
	
	--component declarations
	component Butterfly is 
		port(
			   start : in std_logic_vector(0 downto 0);
				IN_W,IN_AB : in signed(23 downto 0);
				clk,nReset : in std_logic;
				Out_BUTTERFLY : out SIGNED(23 downto 0);
				done : out std_logic
				) ;			
	end component;
	
	component read_input is
		port (clock: in std_logic;
			  read_enable: in std_logic;
			  start_out: out std_logic;
			  data_out: out signed(23 downto 0);
			  twiddle_out: out signed(23 downto 0));
	end component;
	
	component write_output is 
		port (clock: in std_logic;
			  enable: in std_logic; -- this will be the DONE signal 
			  data_in: in signed(23 downto 0));
	end component;
	
	--signal declarations
	signal clock, reset_n: std_logic;
	signal read_enable, start_int, done_int: std_logic;
	signal data_in_int, twiddle_int, data_out_int: signed(23 downto 0);
	
begin
	--clock generation process
	clk_gen: process
	begin
		clock <= '1';
		wait for T/2;
		clock <= '0';
		wait for T/2;
	end process;
	
	-- signal assignments
	reset_n <= '1', '0' after 15 ns, '1' after 55 ns;
	read_enable <= '0', '1' after 2*T;
	
	-- component intantiations
	read: read_input port map  (clock => clock,
								read_enable => read_enable,
								start_out => start_int,
								data_out => data_in_int,
								twiddle_out => twiddle_int);
								
	write: write_output port map   (clock => clock,
									enable => done_int,
									data_in => data_out_int);
									
	farfalla: Butterfly port map   (start(0) => start_int,
									IN_W => twiddle_int,
									IN_AB => data_in_int,
									clk => clock,
									nReset => reset_n,
									Out_BUTTERFLY => data_out_int,
									done => done_int);
end behavior;