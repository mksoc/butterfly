library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity CU is
port(clk,nReset : in std_logic;
      start : in std_logic_vector(0 downto 0);
      done : out std_logic;
		reset_DP : buffer std_logic;
		command : out std_logic_vector(14 downto 0));
end CU;

ARCHITECTURE BHV OF CU IS


component ALU_CU
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		RESULT : out signed(N-1 downto 0)
		) ;
end component;

component reg_M 
GENERIC ( N : NATURAL := 25);
   port
   (
      CLK : in std_logic;
      CLRN : in std_logic;
      ENA : in std_logic;      
      D : in std_logic_vector(N-1 downto 0);
      Q : out std_logic_vector(N-1 downto 0)
   );
end  component;

component reg_L 
GENERIC ( N : NATURAL := 25);
   port
   (
      CLK : in std_logic;
      CLRN : in std_logic;
      ENA : in std_logic;      
      D : in std_logic_vector(N-1 downto 0);
      Q : out std_logic_vector(N-1 downto 0)
   );
end  component;

component ROM 
 port (address : in STD_LOGIC_VECTOR (14 downto 0);
 data : out std_logic_vector (16 downto 0)
 );
end component;

component decoder
Port ( sel : in STD_LOGIC_VECTOR (3 downto 0);
y : out STD_LOGIC_VECTOR (14 downto 0));
end component;

component PLA 
port( start,CC_ROM,STARTX_8  : in std_logic;
		Cond : in std_logic_vector(1 downto 0);
		OUT_PLA : out std_logic);
end component;


component MUX2TO1 
GENERIC ( N : NATURAL := 25);
port(
		IN_0 : in STD_LOGIC_vector(N-1 downto 0);
		IN_1 : in STD_LOGIC_vector(N-1 downto 0);
		SEL  : IN STD_LOGIC;
		OUT_M : OUT STD_LOGIC_vector(N-1 downto 0)
);
END component;

--SIGNAL GENERAL

signal STARTX_8,START_1 : std_logic_vector(0 downto 0);
signal JUMP_ADDR : std_logic_vector(3 downto 0);

-- signal PLA_CC

signal START_PLA_CC : std_logic;
signal CC_ROM : std_logic;
signal COND_PLA_CC : std_logic_vector(1 downto 0);
signal OUT_PLA_CC : std_logic;

-- signal MUX_uAR

signal IN_0_MUX_uAR : std_logic_vector(3 downto 0);
signal IN_1_MUX_uAR : std_logic_vector(3 downto 0);
signal SEL_MUX_uAR : std_logic;
signal OUT_M_MUX_uAR : std_logic_vector(3 downto 0);

--signal uAR

signal D_uAR : std_logic_vector(3 downto 0);
signal Q_uAR : std_logic_vector(3 downto 0);

--signal dec_int

signal Sel_DEC : std_logic_vector(3 downto 0);
signal OUT_DEC : STD_LOGIC_VECTOR (14 downto 0);

--signal ROM_0

signal ADDRESS_ROM_0 : STD_LOGIC_VECTOR (14 downto 0) ;
signal DATA_OUT_ROM_0 : std_logic_vector (16 downto 0);

--signal uIR

signal D_uIR : std_logic_vector (16 downto 0) ;
signal Q_uIR : std_logic_vector (16 downto 0) ;

--signal start_REG
signal ena_ff : std_logic;

--signal ALUP1
signal IN_0_ALUP1 : signed(3 downto 0) ;
signal IN_1_ALUP1 :  signed(3 downto 0) ;
signal RESULT_ALUP1 : signed(3 downto 0) ;

begin

--------CONNECTIONS-------
      JUMP_ADDR <= Q_uIR(13) & Q_uIR(0) & Q_uIR(0) & Q_uIR(10);
      
		IN_0_MUX_uAR<=std_logic_vector(RESULT_ALUP1);
		IN_1_MUX_uAR<= JUMP_ADDR;
		D_uAR<=OUT_M_MUX_uAR;
		
	   IN_0_ALUP1 <= signed(Q_uAR);
    	IN_1_ALUP1 <= "0001";
   	Sel_DEC<= Q_uAR;
		
		command<=Q_uIR(15 downto 1);
		done <= Q_uIR(0);
	   ADDRESS_ROM_0<=OUT_DEC;
		D_uIR<=DATA_OUT_ROM_0;
		SEL_MUX_uAR<=OUT_PLA_CC;
		
		START_PLA_CC <= Start(0);
		COND_PLA_CC <=Q_uAR(3) & Q_uAR(0);
		CC_ROM <= Q_uIR(16);
		reset_DP<= Q_uIR(10);
		ena_ff <= Q_uIR(15);
-----------END------------
--------COMPONENTS--------


PLA_CC : PLA  
port map( start => START_PLA_CC,
		CC_ROM => CC_ROM,
		STARTX_8 => STARTX_8(0),
		Cond => COND_PLA_CC,
		OUT_PLA => OUT_PLA_CC
		);

		
		
MUX_uAR :  MUX2TO1 GENERIC MAP(4)
		port MAP(
		IN_0 => IN_0_MUX_uAR  , 
		IN_1 => IN_1_MUX_uAR  ,
		SEL =>  SEL_MUX_uAR  ,
		OUT_M => OUT_M_MUX_uAR 
      );
		
		 
uAR : reg_L GENERIC MAP (4)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => '1',      
      D => D_uAR,
      Q => Q_uAR
   );
	
	
-- DOPPIO REGISTRO PER STARTX_8


ST1 : reg_M GENERIC MAP (1)
   port MAP   (
      CLK => CLK,
      CLRN => reset_DP ,
      ENA => ena_ff,      
      D => START,
      Q => START_1
   );
ST2 : reg_M GENERIC MAP (1)
   port MAP   (
      CLK => CLK,
      CLRN => reset_DP ,
      ENA => ena_ff,      
      D => START_1,
      Q => STARTX_8
   );


----------------------	
	
	
DEC_INT : decoder
Port  map( sel => Sel_DEC,
       y => OUT_DEC
		 );
		 
	
ROM_0 : ROM 
 port map (address => ADDRESS_ROM_0,
 data => DATA_OUT_ROM_0
 );

uIR : reg_M GENERIC MAP (17)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => '1',      
      D => D_uIR,
      Q => Q_uIR
 );
	
	
ALUP1: ALU_CU GENERIC MAP(4)
port map( 
		IN_0 => IN_0_ALUP1,
		IN_1 => IN_1_ALUP1,
		RESULT => RESULT_ALUP1
		) ;
	
end BHV;