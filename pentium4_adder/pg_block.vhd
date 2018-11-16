----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	pg_block.vhd
----------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity PG_BLOCK is
	port(	P_i_k: in std_logic;
		G_i_k: in std_logic;
		P_k_1_j: in std_logic;
		G_k_1_j: in std_logic;
		P_i_j: out std_logic;
		G_i_j: out std_logic);
end PG_BLOCK;


architecture BEHAVIORAL of PG_BLOCK is
begin
	P_i_j <= P_i_k AND P_k_1_j;
	G_i_j <= G_i_k OR (P_i_k AND G_k_1_j);

end BEHAVIORAL;

configuration CFG_PG_BLOCK of PG_BLOCK is
	for BEHAVIORAL
	end for;
end CFG_PG_BLOCK;
