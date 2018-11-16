library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity SUM_GENERATOR is
	generic(NBIT : integer;
		NBLOCK: integer);
	port(	A : in std_logic_vector(NBIT*NBLOCK-1 downto 0);
		B : in std_logic_vector(NBIT*NBLOCK-1 downto 0);
		Ci : in std_logic_vector(NBLOCK-1 downto 0);
		S : out std_logic_vector(NBIT*NBLOCK-1 downto 0));
end SUM_GENERATOR;

architecture STRUCTURAL of SUM_GENERATOR is

	component CARRY_SELECT_BLOCK 
		generic( N: integer);
		port(	A: in std_logic_vector(N-1 downto 0);
			B: in std_logic_vector(N-1 downto 0);
			Ci: in std_logic;
			S: out std_logic_vector(N-1 downto 0));
	end component;

begin

	CARRY_BLOCKS_GENERATE: for i in 1 to NBLOCK generate
		CARRY_BLOCK: CARRY_SELECT_BLOCK 
				generic map(NBIT)
				port map(A(NBIT*i-1 downto NBIT*(i-1)), B(NBIT*i-1 downto NBIT*(i-1)), Ci(i-1), S(NBIT*i-1 downto NBIT*(i-1)));
	end generate;
	

end STRUCTURAL;

configuration CFG_SUM_GENERATOR of SUM_GENERATOR is
	for STRUCTURAL
		for CARRY_BLOCKS_GENERATE
			for all : CARRY_SELECT_BLOCK
					use configuration WORK.CFG_CARRY_SELECT_BLOCK;
			end for;
		end for;
	end for;
end CFG_SUM_GENERATOR;
