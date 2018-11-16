library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity CARRY_SELECT_BLOCK is
	generic( N: integer);
	port(	A: in std_logic_vector(N-1 downto 0);
		B: in std_logic_vector(N-1 downto 0);
		Ci: in std_logic;
		S: out std_logic_vector(N-1 downto 0));
end CARRY_SELECT_BLOCK;

architecture STRUCTURAL of CARRY_SELECT_BLOCK is

	component RCA_GENERIC  
		generic (	NBIT: integer;
				DRCAS : Time := 0 ns;
	         		DRCAC : Time := 0 ns);
		Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
			B:	In	std_logic_vector(NBIT-1 downto 0);
			Ci:	In	std_logic;
			S:	Out	std_logic_vector(NBIT-1 downto 0);
			Co:	Out	std_logic);
	end component; 

	component MUX21_GENERIC 
		generic (	N: integer;
			 	DELAY_MUX: Time);
		port (	A:	In	std_logic_vector(N-1 downto 0) ;
			B:	In	std_logic_vector(N-1 downto 0);
			SEL:	In	std_logic;
			Y:	Out	std_logic_vector(N-1 downto 0));
	end component;

	signal Out_carry_0 : std_logic_vector(N-1 downto 0);
	signal Out_carry_1 : std_logic_vector(N-1 downto 0);

begin

	RCA_1: RCA_GENERIC
		generic map(N, 0 ns, 0 ns)
		port map(A, B, '0', Out_carry_0, open); 

	RCA_2: RCA_GENERIC
		generic map(N, 0 ns, 0 ns)
		port map(A, B, '1', Out_carry_1, open); 

	MUX21: MUX21_GENERIC
		generic map(N, 0 ns)
		port map(Out_carry_1, Out_carry_0, Ci, S); 

end STRUCTURAL;

configuration CFG_CARRY_SELECT_BLOCK of CARRY_SELECT_BLOCK is
	for STRUCTURAL
		for all : RCA_GENERIC
			use configuration WORK.CFG_RCA_GENERIC;
		end for;
		for all : MUX21_GENERIC 
			use configuration WORK.CFG_MUX21_GEN_BEHAVIORAL;
		end for;
	end for;
end CFG_CARRY_SELECT_BLOCK;
