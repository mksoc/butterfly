library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_STD.all;
entity Butterfly is 
port(
       start : in std_logic_vector(0 downto 0);
		IN_W,IN_AB : in signed(23 downto 0);
		clk,nReset : in std_logic;
		Out_BUTTERFLY : out SIGNED(23 downto 0);
		done : out std_logic
		) ;
		
end Butterfly;

architecture beh of Butterfly is

component DATAPATH
port(
		IN_W,IN_AB : in signed(23 downto 0);
		command : in std_logic_vector(14 downto 0);
		clk,nReset : in std_logic;
		Out_DP : out SIGNED(23 downto 0)
		) ;
		
end component;

component CU 
port(clk,nReset : in std_logic;
      start : in std_logic_vector(0 downto 0);
      done : out std_logic;
		reset_DP :buffer std_logic;
		command : out std_logic_vector(14 downto 0));
end component;
signal reset_DP : std_logic;
signal command : std_logic_vector(14 downto 0);
begin

ControlUnit : CU port map(
		clk => clk,
		nReset => nReset,
		Start => Start,
		done => done,
		reset_DP => reset_DP,
		command => command
		);

DP : DATAPATH  port map(
		IN_W => IN_W,
		IN_AB => IN_AB,
		command => command ,
		clk => clk,
		nReset => reset_DP,
		Out_DP => Out_BUTTERFLY
		) ;

end beh;
		
