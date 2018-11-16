library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use work.log_pkg.all;

entity CARRY_GENERATOR is
	generic( NBIT: integer;
		 DCARRY: integer);
	port(	A: in std_logic_vector(NBIT-1 downto 0);
		B: in std_logic_vector(NBIT-1 downto 0);
		C_0: in std_logic;
		C: out std_logic_vector(NBIT/DCARRY-1 downto 0));
end CARRY_GENERATOR;


architecture STRUCTURAL of CARRY_GENERATOR is

	component PG_NET is
		generic(	NBIT: integer);
		port(	A: in std_logic_vector(NBIT-1 downto 0);
			B: in std_logic_vector(NBIT-1 downto 0);
			C_0: in std_logic;
			P_NET: out std_logic_vector(NBIT downto 1);
			G_NET: out std_logic_vector(NBIT downto 1));
	end component;

	component PG_BLOCK is
		port(	P_i_k: in std_logic;
				G_i_k: in std_logic;
				P_k_1_j: in std_logic;
				G_k_1_j: in std_logic;
				P_i_j: out std_logic;
				G_i_j: out std_logic);
	end component;

	component G_BLOCK is
		port(	P_i_k: in std_logic;
				G_i_k: in std_logic;
				G_k_1_j: in std_logic;
				G_i_j: out std_logic);
	end component;

	constant NCARRY: integer := NBIT/DCARRY;
	constant LOG2NBIT: integer := log2N(NBIT);

	type SignalVector is array (LOG2NBIT downto 0) of std_logic_vector(NBIT downto 1);
	signal P: SignalVector;
	signal G: SignalVector;

begin

		PG_NET_INIT: PG_NET
			generic map(NBIT)
			port map(A, B, C_0, P(0), G(0));

		
		GEN_LEVELS: 
		for J in 1 to LOG2NBIT generate
			--first case (generate)
			G_GEN: G_BLOCK
				port map(	P(J-1)(2**(J)), 
							G(J-1)(2**(J)),
							G(J-1)(2**(J)-2**(J-1)),
							G(J)(2**(J)));
			G_GEN_FOREACH_DCARRY:
			for A in 1 to (2**(J)/DCARRY - 1) generate
				G_NOT_GEN_FOR_DOWNHALF_CARRIES:
				if (A >= 2**(J)/(DCARRY*2)) generate
					G(J)(2**(J)-A*DCARRY) <= G(J-1)(2**(J)-A*DCARRY);
					P(J)(2**(J)-A*DCARRY) <= P(J-1)(2**(J)-A*DCARRY);
				end generate;
				G_GEN_FOR_CARRIES:
				if (A < 2**(J)/(DCARRY*2)) generate
					G_GEN_EACH_A: G_BLOCK
						port map(	P(J-1)(2**(J)-A*DCARRY), 
								G(J-1)(2**(J)-A*DCARRY),
								G(J-1)(2**(J)-2**(J-1)),
								G(J)(2**(J)-A*DCARRY));
				end generate;
			end generate;
			--second case(propagate and generate)
			PG_GEN:
			for I in 2 to (NBIT/(2**(J))) generate
				PG_GEN_POW2: PG_BLOCK
						port map(	P(J-1)(I*2**(J)), 
									G(J-1)(I*2**(J)),
									P(J-1)(I*2**(J)-2**(J-1)),
									G(J-1)(I*2**(J)-2**(J-1)),
									P(J)(I*2**(J)),
									G(J)(I*2**(J)));
				PG_GEN_FOREACH_DCARRY:
				for A in 1 to (2**(J)/DCARRY - 1) generate
					PG_NOT_GEN_CARRIES:
					if (A >= 2**(J)/(DCARRY*2)) generate
						G(J)(I*2**(J)-A*DCARRY) <= G(J-1)(I*2**(J)-A*DCARRY);
						P(J)(I*2**(J)-A*DCARRY) <= P(J-1)(I*2**(J)-A*DCARRY);
					end generate;
					PG_GEN_EACH_UPPERHALF_A:
					if (A < 2**(J)/(DCARRY*2)) generate
						PG_GEN_EACH_A: PG_BLOCK
							port map(	P(J-1)(I*2**(J)-A*DCARRY), 
										G(J-1)(I*2**(J)-A*DCARRY),
										P(J-1)(I*2**(J)-2**(J-1)),
										G(J-1)(I*2**(J)-2**(J-1)),
										P(J)(I*2**(J)-A*DCARRY),
										G(J)(I*2**(J)-A*DCARRY));
					end generate;
				end generate;
			end generate;
		end generate;


    CARRY_OUT_ASSIGNMENT: for I in 1 to NCARRY generate
        C(I-1) <= G(LOG2NBIT)(I*DCARRY);
    end generate;

end STRUCTURAL;


configuration CFG_CARRY_GENERATOR of CARRY_GENERATOR is
	for STRUCTURAL
	end for;
end CFG_CARRY_GENERATOR;
