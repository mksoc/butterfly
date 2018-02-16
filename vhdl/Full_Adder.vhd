LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FullAdder IS --implementato in maniera strutturale
PORT (a,b,ci: IN STD_LOGIC;
s, co: OUT STD_LOGIC);
END FullAdder;

ARCHITECTURE behavior OF FullAdder IS
BEGIN
co <= (NOT(a XOR b) AND b) OR ((a XOR b) AND ci);
s <= (a XOR b) XOR ci;
END behavior;