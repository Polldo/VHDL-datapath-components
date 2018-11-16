----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	g_block.vhd
----------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity G_BLOCK is
	port(	P_i_k: in std_logic;
		G_i_k: in std_logic;
		G_k_1_j: in std_logic;
		G_i_j: out std_logic);
end G_BLOCK;


architecture BEHAVIORAL of G_BLOCK is
begin
	G_i_j <= G_i_k OR (P_i_k AND G_k_1_j);

end BEHAVIORAL;

configuration CFG_G_BLOCK of G_BLOCK is
	for BEHAVIORAL
	end for;
end CFG_G_BLOCK;
