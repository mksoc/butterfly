library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_STD.all;
entity DATAPATH is 
port(
		IN_W,IN_AB : in signed(23 downto 0);
		clk,nReset : in std_logic;
		command : in std_logic_vector(14 downto 0);
		Out_DP : out SIGNED(23 downto 0)
		) ;
		
end DATAPATH;

architecture beh of DATAPATH is

component Multiplier 
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		clk : in std_logic;
		RESULT : out signed(((2*N)-2) downto 0)
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
 
component MUX2TO1 
GENERIC ( N : NATURAL := 25);
port(
		IN_0 : in STD_LOGIC_vector(N-1 downto 0);
		IN_1 : in STD_LOGIC_vector(N-1 downto 0);
		SEL : IN STD_LOGIC;
		OUT_M : OUT STD_LOGIC_vector(N-1 downto 0)
);
END component ;

component ALU 
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		S_IN_1 :IN STD_LOGIC;
		clk : in std_logic;
		RESULT : out signed(N-1 downto 0)
		) ;
end component;

component ALU_CU 
GENERIC ( N : NATURAL := 24);
port( 
		IN_0 : in signed(N-1 downto 0);
		IN_1 : in signed(N-1 downto 0);
		RESULT : out signed(N-1 downto 0)
		) ;
end component ;

		--segnali generici 
		signal PADDING : STD_LOGIC_VECTOR(22 downto 0);
     
	  --segnali _MUXAW
		signal IN_0_MUXAW  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXAW  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXAW   :  STD_LOGIC;
		signal OUT_M_MUXAW :  STD_LOGIC_vector(23 downto 0);
      
		--segnali _MUXWi
		signal IN_0_MUXWI  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXWI  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXWI   :  STD_LOGIC;
		signal OUT_M_MUXWI :  STD_LOGIC_vector(23 downto 0);
      
		--segnali _MUXBR
		signal IN_0_MUXBR  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXBR  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXBR   :  STD_LOGIC;
		signal OUT_M_MUXBR :  STD_LOGIC_vector(23 downto 0);
      
		--segnali _MUXA1
		signal IN_0_MUXA1  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXA1  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXA1   :  STD_LOGIC;
		signal OUT_M_MUXA1 :  STD_LOGIC_vector(23 downto 0);
     
	  --segnali _MUXA2
		signal IN_0_MUXA2  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXA2  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXA2   :  STD_LOGIC;
		signal OUT_M_MUXA2 :  STD_LOGIC_vector(23 downto 0);
      
      --segnali _MUXB
		signal IN_0_MUXB  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXB  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXB  :  STD_LOGIC;
		signal OUT_M_MUXB :  STD_LOGIC_vector(23 downto 0);
      
      --segnali _MUXW
		signal IN_0_MUXW  :  STD_LOGIC_vector(23 downto 0);
		signal IN_1_MUXW  :  STD_LOGIC_vector(23 downto 0);
		signal SEL_MUXW   :  STD_LOGIC;
		signal OUT_M_MUXW :  STD_LOGIC_vector(23 downto 0);
      	
		--SEGNALI _REG0_BrAr
      signal ENA_REG0_BrAr :  std_logic;      
      signal D_REG0_BrAr :  std_logic_vector(23 downto 0);
      signal Q_REG0_BrAr : std_logic_vector(23 downto 0) ;
			
		--SEGNALI _REG1_Bi
      signal ENA_REG1_Bi :  std_logic;      
      signal D_REG1_Bi :  std_logic_vector(23 downto 0);
      signal Q_REG1_Bi : std_logic_vector(23 downto 0) ;
				
		--SEGNALI _REG2_Wr
      signal ENA_REG2_Wr :  std_logic;      
      signal D_REG2_Wr :  std_logic_vector(23 downto 0);
      signal Q_REG2_Wr : std_logic_vector(23 downto 0) ;
			
		--SEGNALI _REG3_WiAi
      signal ENA_REG3_WiAi :  std_logic;      
      signal D_REG3_WiAi :  std_logic_vector(23 downto 0);
      signal Q_REG3_WiAi : std_logic_vector(23 downto 0) ;
				
		--SEGNALI _REG4_BrAr
      signal ENA_REG4_BrAr :  std_logic;      
      signal D_REG4_BrAr :  std_logic_vector(23 downto 0);
      signal Q_REG4_BrAr : std_logic_vector(23 downto 0) ;
			
		--SEGNALI _REG5_WiAi
      signal ENA_REG5_WiAi :  std_logic;      
      signal D_REG5_WiAi :  std_logic_vector(23 downto 0);
      signal Q_REG5_WiAi : std_logic_vector(23 downto 0) ;
				
		--SEGNALI _REG_S1
      signal ENA_REG_S1 :  std_logic;      
      signal D_REG_S1 :  std_logic_vector(48 downto 0);
      signal Q_REG_S1 : std_logic_vector(48 downto 0) ;
				
		--SEGNALI _REG_S2
      signal ENA_REG_S2 :  std_logic;      
      signal D_REG_S2 :  std_logic_vector(48 downto 0);
      signal Q_REG_S2 : std_logic_vector(48 downto 0) ;
				
		--SEGNALI _REG_M
      signal ENA_REG_M :  std_logic;      
      signal D_REG_M :  std_logic_vector(46 downto 0);
      signal Q_REG_M : std_logic_vector(46 downto 0) ;
		
		--SEGNALI _REG_OUT
      signal ENA_REG_OUT :  std_logic;      
      signal D_REG_OUT :  std_logic_vector(23 downto 0);
      signal Q_REG_OUT : std_logic_vector(23 downto 0) ;
		
		--segnali _MUX0
		signal IN_0_MUX0  :  STD_LOGIC_vector(24 downto 0);
		signal IN_1_MUX0  :  STD_LOGIC_vector(24 downto 0);
		signal SEL_MUX0   :  STD_LOGIC;
		signal OUT_M_MUX0 :  STD_LOGIC_vector(24 downto 0);
      
		--segnali _MUX1
		signal IN_0_MUX1  :  STD_LOGIC_vector(24 downto 0);
		signal IN_1_MUX1  :  STD_LOGIC_vector(24 downto 0);
		signal SEL_MUX1   :  STD_LOGIC;
		signal OUT_M_MUX1 :  STD_LOGIC_vector(24 downto 0);
      
		--segnali _MUX2
		signal IN_0_MUX2  :  STD_LOGIC_vector(48 downto 0);
		signal IN_1_MUX2  :  STD_LOGIC_vector(48 downto 0);
		signal SEL_MUX2   :  STD_LOGIC;
		signal OUT_M_MUX2 :  STD_LOGIC_vector(48 downto 0);
		
		--segnali _MUX3
		signal IN_0_MUX3  :  STD_LOGIC_vector(48 downto 0);
		signal IN_1_MUX3  :  STD_LOGIC_vector(48 downto 0);
		signal SEL_MUX3   :  STD_LOGIC;
		signal OUT_M_MUX3 :  STD_LOGIC_vector(48 downto 0);
      
		--segnali _MUX4
		signal IN_0_MUX4  :  STD_LOGIC_vector(48 downto 0);
		signal IN_1_MUX4  :  STD_LOGIC_vector(48 downto 0);
		signal SEL_MUX4   :  STD_LOGIC;
		signal OUT_M_MUX4 :  STD_LOGIC_vector(48 downto 0);
     --segnali _MUX5
		signal IN_0_MUX5  :  STD_LOGIC_vector(48 downto 0);
		signal IN_1_MUX5  :  STD_LOGIC_vector(48 downto 0);
		signal SEL_MUX5   :  STD_LOGIC;
		signal OUT_M_MUX5 :  STD_LOGIC_vector(48 downto 0);

		--segnali _MUX6
		signal IN_0_MUX6  :  STD_LOGIC_vector(24 downto 0);
		signal IN_1_MUX6  :  STD_LOGIC_vector(24 downto 0);
		signal SEL_MUX6   :  STD_LOGIC;
		signal OUT_M_MUX6 :  STD_LOGIC_vector(24 downto 0);

		--segnali _S1
		signal IN_0_S1 :   signed(48 downto 0);
		signal IN_1_S1 :   signed(48 downto 0);
		signal S_IN_1_S1 : std_logic;
		signal RESULT_S1 : signed(48 downto 0);
      --segnali _S2
		signal IN_0_S2 :   signed(48 downto 0);
		signal IN_1_S2 :   signed(48 downto 0);
		signal S_IN_1_S2 : std_logic;
		signal RESULT_S2 : signed(48 downto 0);
      --segnali _SADJ
		signal IN_0_SADJ :   signed(24 downto 0);
		signal IN_1_SADJ :   signed(24 downto 0);
		signal S_IN_1_SADJ : std_logic;
		signal RESULT_SADJ : signed(24 downto 0);
		--segnali  _Multiplier
		signal IN_0_Multiplier :   signed(23 downto 0);
		signal IN_1_Multiplier :   signed(23 downto 0);
		signal RESULT_Multiplier : signed(46 downto 0);

begin

-- CONNESSIONI

---------COMANDI-----------
--14
ena_reg2_Wr <= command(14);
--13
ena_reg0_BrAr <= command(13);
--12
ena_reg3_WiAi <= command(12);
--11
ena_reg4_BrAr <= command(11);
--10
ena_reg5_WiAi <= command(10);
--9
ena_reg_M <= command(9);
ena_reg_OUT <= command(9);
--8
ena_reg_S1 <= command(8);
--7
ena_reg_S2 <= command(7);
--6
sel_muxB	<= command(6);
--5
sel_muxA1 <= command(5);
sel_muxA2 <= command(5);
ena_reg1_Bi <= command(5);
--4
sel_mux0 <= command(4);
sel_mux5 <= command(4);
--3
sel_mux2 <= command(3);
sel_mux4 <= command(3);
sel_muxW <= command(3);
sel_muxAW <= command(3);
--2
sel_mux3 <= command(2);
sel_mux6 <= command(2);
sel_mux1 <= command(2);
sel_muxWi <= command(2);
sel_muxBr <= command(2);
--1
S_IN_1_S1 <= command(1);
--0
S_IN_1_S2 <= command(0);

-----------END-------------

--LIVELLO -3

--MUXAW IN0
IN_0_MUXAW <= STD_LOGIC_VECTOR(IN_AB);
--MUXAW IN1
IN_1_MUXAW <= STD_LOGIC_VECTOR(IN_W);

--LIVELLO -2

D_REG0_BRAR <= STD_LOGIC_VECTOR(IN_AB);
D_REG1_BI <= STD_LOGIC_VECTOR(IN_AB);
D_REG2_WR <= STD_LOGIC_VECTOR(IN_W);
D_REG3_WIAI <= OUT_M_MUXAW;
D_REG4_BRAR <= STD_LOGIC_VECTOR(IN_AB);
D_REG5_WIAI <= OUT_M_MUXAW;

--LIVELLO -1

--MUXBR IN0
IN_0_MUXBR <= Q_REG0_BRAR;
--MUXBR IN1
IN_1_MUXBR <= Q_REG4_BRAR;

--MUXWI IN0
IN_0_MUXWI <= Q_REG3_WIAI;
--MUXWI IN1
IN_1_MUXWI <= Q_REG5_WIAI;

--LIVELLO 0

--MUXB IN0
IN_0_MUXB <= OUT_M_MUXBR;
--MUXB IN1
IN_1_MUXB <= Q_REG1_BI;

--MUXW IN0
IN_0_MUXW <= OUT_M_MUXWI;
--MUXW IN1
IN_1_MUXW <= Q_REG2_WR;

--MUXA1 IN0
IN_0_MUXA1 <= Q_REG0_BRAR;
--MUXA1 IN1
IN_1_MUXA1 <= Q_REG3_WIAI;

--MUXA2 IN0
IN_0_MUXA2 <= Q_REG4_BRAR;
--MUXA2 IN1
IN_1_MUXA2 <= Q_REG5_WIAI;

--LIVELLO 1
-- Multiplier IN_0
IN_0_Multiplier <= Signed(OUT_M_MUXB);
-- Multiplier IN_1
IN_1_Multiplier <= SIGNED(OUT_M_MUXW);

--REG_M D
D_REG_M <= STD_LOGIC_VECTOR(RESULT_Multiplier) ;

--MUX0 IN0
IN_0_MUX0 <= OUT_M_MUXA1(23) & OUT_M_MUXA1;
--MUX0 IN1
--IN_1_MUX0 <= OUT_M_MUXA1(21) & OUT_M_MUXA1(21 downto 0) & "00";
IN_1_MUX0 <= OUT_M_MUXA1 & '0';


--MUX1 IN0
IN_0_MUX1 <= OUT_M_MUXA2(23) & OUT_M_MUXA2;
--MUX1 IN1
--IN_1_MUX1 <= OUT_M_MUXA2(21) & OUT_M_MUXA2(21 downto 0) & "00";
IN_1_MUX1 <= OUT_M_MUXA2 & '0';

--CONNESSIONI
--LIVELLO 2
PADDING <= "00000000000000000000000" ;

--MUX2 IN1
IN_1_MUX2 <= OUT_M_MUX0(24) & OUT_M_MUX0 & PADDING;
--MUx2 IN0
IN_0_MUX2 <= Q_REG_S1;

--MUX3 IN1
IN_1_MUX3 <= Q_REG_M(46) & Q_REG_M(46) & Q_REG_M(46 downto 0);
--MUx2 IN0
IN_0_MUX3 <= Q_REG_S1;

--MUX4 IN1
IN_1_MUX4 <= OUT_M_MUX1(24) & OUT_M_MUX1 & PADDING;
--MUx4 IN0
IN_0_MUX4 <= Q_REG_S2;

--MUX5 IN1
IN_1_MUX5 <= Q_REG_M(46) & Q_REG_M(46) & Q_REG_M(46 downto 0);
--MUx5 IN0
IN_0_MUX5 <= Q_REG_S2;

--Livello 3

--S1 ALU  IN1
IN_1_S1 <=  SIGNED(OUT_M_MUX3);
--S1 ALU  IN0
IN_0_S1 <=  SIGNED(OUT_M_MUX2);

--S2 ALU  IN1
IN_1_S2 <=  SIGNED(OUT_M_MUX5);
--S2 ALU  IN0
IN_0_S2 <=  SIGNED(OUT_M_MUX4);

--livello 4 

--REG_S1 D
D_REG_S1 <= STD_LOGIC_VECTOR(RESULT_S1) ;

--REG_S2 D
D_REG_S2 <= STD_LOGIC_VECTOR(RESULT_S2) ;


--livello 5

--MUX6 IN1
IN_1_MUX6 <= Q_REG_S2(48 downto 24);
--MUx6 IN0
IN_0_MUX6 <= Q_REG_S1(48 downto 24);

--livello 6

--SADJ IN1
in_1_SadJ <= SIGNED(OUT_M_MUX6);
--SADJ IN0
IN_0_SADJ <= "0000000000000000000000001";

--livello 7

--in REG_OUT
D_REG_OUT <= STD_LOGIC_VECTOR(RESULT_SADJ(24 downto 1));

--livello 8
OUT_DP <= SIGNED(Q_REG_OUT);
--PORTMAP

--MOLTIPLICATORE

M1 : Multiplier GENERIC MAP(24)
port MAP( 
		IN_0 => IN_0_Multiplier,
		IN_1 => IN_1_Multiplier,
		clk => clk,
		RESULT => RESULT_Multiplier
		) ;
		
--REGISTRI

REG0_BRAR : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG0_BRAR,      
      D => D_REG0_BRAR,
      Q => Q_REG0_BRAR
   );
	
REG1_BI : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG1_BI,      
      D => D_REG1_BI,
      Q => Q_REG1_BI
   );
	
REG2_Wr : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG2_Wr,      
      D => D_REG2_Wr,
      Q => Q_REG2_Wr
   );
	
REG3_WiAi : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG3_WiAi,      
      D => D_REG3_WiAi,
      Q => Q_REG3_WiAi
   );
	
REG4_BrAr : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG4_BrAr,      
      D => D_REG4_BrAr,
      Q => Q_REG4_BrAr
   );
REG5_WiAI : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG5_WiAi,      
      D => D_REG5_WiAi,
      Q => Q_REG5_WiAi
   );
	
Reg_M1 : reg_M GENERIC MAP (47)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG_M,      
      D => D_REG_M,
      Q => Q_REG_M
   );
	
Reg_S1 : reg_M GENERIC MAP (49)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG_S1,      
      D => D_REG_S1,
      Q => Q_REG_S1
   );
	
Reg_S2 : reg_M GENERIC MAP (49)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG_S2 ,      
      D => D_REG_S2 ,
      Q => Q_REG_S2 
   );
Reg_OUT : reg_M GENERIC MAP (24)
   port MAP   (
      CLK => CLK,
      CLRN => nRESET ,
      ENA => ENA_REG_OUT ,      
      D => D_REG_OUT ,
      Q => Q_REG_OUT 
   );
	
-- MUX


MUX_aw :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXAW , 
		IN_1 => IN_1_MUXAW ,
		SEL =>  SEL_MUXAW ,
		OUT_M => OUT_M_MUXAW
      );
		
MUX_WI :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXWI , 
		IN_1 => IN_1_MUXWI ,
		SEL =>  SEL_MUXWI ,
		OUT_M => OUT_M_MUXWI
      );
		
MUX_BR :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXBR , 
		IN_1 => IN_1_MUXBR ,
		SEL =>  SEL_MUXBR ,
		OUT_M => OUT_M_MUXBR
      );
		
MUX_B :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXB , 
		IN_1 => IN_1_MUXB ,
		SEL =>  SEL_MUXB ,
		OUT_M => OUT_M_MUXB
      );

MUX_w :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXW , 
		IN_1 => IN_1_MUXW ,
		SEL =>  SEL_MUXW ,
		OUT_M => OUT_M_MUXW
      );
		
MUX_A1 :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXA1 , 
		IN_1 => IN_1_MUXA1 ,
		SEL =>  SEL_MUXA1 ,
		OUT_M => OUT_M_MUXA1
      );	
		
MUX_A2 :  MUX2TO1 GENERIC MAP(24)
		port MAP(
		IN_0 => IN_0_MUXA2 , 
		IN_1 => IN_1_MUXA2 ,
		SEL =>  SEL_MUXA2 ,
		OUT_M => OUT_M_MUXA2
      );
--SOPRA I MUX 2 3 4 5
MUX_0 :  MUX2TO1 GENERIC MAP(25)
		port MAP(
		IN_0 => IN_0_MUX0 , 
		IN_1 => IN_1_MUX0 ,
		SEL =>  SEL_MUX0 ,
		OUT_M => OUT_M_MUX0
      );

MUX_1 :  MUX2TO1 GENERIC MAP(25)
		port MAP(
		IN_0 => IN_0_MUX1 , 
		IN_1 => IN_1_MUX1 ,
		SEL =>  SEL_MUX1 ,
		OUT_M => OUT_M_MUX1
      );	
--SOPRA I SOMMATORI S1 e S2
MUX_2 :  MUX2TO1 GENERIC MAP(49)
		port MAP(
		IN_0 => IN_0_MUX2 , 
		IN_1 => IN_1_MUX2 ,
		SEL =>  SEL_MUX2 ,
		OUT_M => OUT_M_MUX2
      );
MUX_3 :  MUX2TO1 GENERIC MAP(49)
		port MAP(
		IN_0 => IN_0_MUX3 , 
		IN_1 => IN_1_MUX3 ,
		SEL =>  SEL_MUX3 ,
		OUT_M => OUT_M_MUX3
      );
MUX_4 :  MUX2TO1 GENERIC MAP(49)
		port MAP(
		IN_0 => IN_0_MUX4 , 
		IN_1 => IN_1_MUX4 ,
		SEL =>  SEL_MUX4 ,
		OUT_M => OUT_M_MUX4
      );
MUX_5 :  MUX2TO1 GENERIC MAP(49)
		port MAP(
		IN_0 => IN_0_MUX5 , 
		IN_1 => IN_1_MUX5 ,
		SEL =>  SEL_MUX5 ,
		OUT_M => OUT_M_MUX5
      );
--SOTTO I SOMMATORI S1 S2

MUX_6 :  MUX2TO1 GENERIC MAP(25)
		port MAP(
		IN_0 => IN_0_MUX6 , 
		IN_1 => IN_1_MUX6 ,
		SEL =>  SEL_MUX6 ,
		OUT_M => OUT_M_MUX6
      );
		
--SOMMATORI 
S1 :  ALU GENERIC MAP(49) 
      PORT MAP (
		IN_0 => IN_0_S1,
		IN_1 => IN_1_S1,
		S_IN_1 => S_IN_1_S1,
		clk => clk,
		RESULT => RESULT_S1
		);

S2 :  ALU GENERIC MAP(49) 
      PORT MAP (
		IN_0 => IN_0_S2,
		IN_1 => IN_1_S2,
		S_IN_1 => S_IN_1_S2,
		clk => clk,
		RESULT => RESULT_S2
		);
		
SADJ :  ALU_CU GENERIC MAP(25) 
      PORT MAP (
		IN_0 => IN_0_SADJ,
		IN_1 => IN_1_SADJ,
		RESULT => RESULT_SADJ
		);
		


end beh;
		
