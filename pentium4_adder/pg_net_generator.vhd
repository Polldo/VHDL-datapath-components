library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity PG_NET_GENERATOR is
	port(	A: in std_logic;
		B: in std_logic;
		P: out std_logic;
		G: out std_logic);
end PG_NET_GENERATOR;


architecture BEHAVIORAL of PG_NET_GENERATOR is
begin
	P <= A xor B; 
	G <= A and B;
end BEHAVIORAL;

configuration CFG_PG_NET_GENERATOR of PG_NET_GENERATOR is
	for BEHAVIORAL
	end for;
end CFG_PG_NET_GENERATOR;
