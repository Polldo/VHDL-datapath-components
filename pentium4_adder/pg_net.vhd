----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	pg_net.vhd
----------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity PG_NET is
	generic(NBIT: integer);
	port(	A: in std_logic_vector(NBIT-1 downto 0);
		B: in std_logic_vector(NBIT-1 downto 0);
		C_0: in std_logic;
		P_NET: out std_logic_vector(NBIT downto 1);
		G_NET: out std_logic_vector(NBIT downto 1));
end PG_NET;

architecture STRUCTURAL of PG_NET is
	component PG_NET_GENERATOR is
		port(	A: in std_logic;
			B: in std_logic;
			P: out std_logic;
			G: out std_logic);
	end component;

	signal P_1, G_1 : std_logic;
begin

	C_0_NET_GEN: 
		PG_NET_GENERATOR
			port map(A(0), B(0), P_1, G_1);
	P_NET(1) <= '0';
	G_NET(1) <= G_1 OR (P_1 AND C_0); 

	PG_NET_GENERATE: 
	for i in 1 to NBIT-1 generate
		PG_NET_GENEREATORS: PG_NET_GENERATOR
			port map(A(i), B(i), P_NET(i+1), G_NET(i+1));
	end generate;

end STRUCTURAL;

configuration CFG_PG_NET of PG_NET is
	for STRUCTURAL
		for PG_NET_GENERATE
			for all : PG_NET_GENERATOR
					use configuration WORK.CFG_PG_NET_GENERATOR;
			end for;
		end for;
	end for;
end CFG_PG_NET;
