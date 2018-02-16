library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
 port (address : in STD_LOGIC_VECTOR (14 downto 0);
 data : out std_logic_vector (16 downto 0));
end entity ROM;
architecture beh of ROM is


begin 
--BIT PER JUMP SONO  4-0-0-11
--                   lsb->MSB
--BIT RELATIVI  : CC0	en_ff/en_reg2_Wr	en_reg0_BrAr	en_reg3_WiAi	en_reg4_BrAr	en_reg5_WiAi/JADDR(3)	en_reg_M/en_reg_OUT/rst_n	en_reg_S1	en_reg_S2	sel_mux_B	sel_mux_A1/sel_mux_A2/en_reg1_Bi	sel_mux_0/sel_mux_5	sel_mux_2/sel_mux_4/sel_mux_W/sel_mux_AW/JADDR(0)	sel_mux_3/sel_mux_6/sel_mux_1/sel_mux_Wi/sel_mux_Br	SUB_ADD_N_S1	SUB_ADD_N_S2	DONE/JADDR(2)/JADDR(1)
with address select
data<= 	"00000000000000000" when "000000000000001"  ,
		"11100010001010000" when "000000000000010"  ,
		"00010010001010000" when "000000000000100" ,
		"00100010000000000" when "000000000001000" ,
		"00010010010000000" when "000000000010000" ,
		"01001010010011100" when "000000000100000" ,
		"00000111001011100" when "000000001000000" ,
		"00001011100001000" when "000000010000000" ,
		"00000111010001100" when "000000100000000" ,
		"11100011010110110" when "000001000000000" ,
		"00010011101110111" when "000010000000000" ,
		"00100011100100000" when "000100000000000" ,
		"00010010110100010" when "001000000000000" ,
		"11001010110011110" when "010000000000000" ,
		"10000111101011111" when "100000000000000" ,
		"00000000000000000" when others;
										

end architecture beh;