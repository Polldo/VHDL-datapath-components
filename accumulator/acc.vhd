library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;

entity ACC is

	generic( NBIT: integer);
	port(   A          : in  std_logic_vector(NBIT - 1 downto 0);
      		B          : in  std_logic_vector(NBIT - 1 downto 0);
      		CLK        : in  std_logic;
      		RST_n      : in  std_logic;
      		ACCUMULATE : in  std_logic;
       		--ACC_EN_n   : in  std_logic;  -- optional use of the enable
      		Y          : out std_logic_vector(NBIT - 1 downto 0));

end ACC;

architecture STRUCTURAL of ACC is

	component MUX21
		generic(N: integer := NBIT);
		port(	A:	in	std_logic_vector(N-1 downto 0) ;
			B:	in	std_logic_vector(N-1 downto 0);
			SEL:	in	std_logic;
			Y:	out	std_logic_vector(N-1 downto 0));
	end component;
	
	component RCA
		generic(NBIT: integer := NBIT);
		port(	A:	in	std_logic_vector(NBIT-1 downto 0);
			B:	in	std_logic_vector(NBIT-1 downto 0);
			Ci:	in	std_logic;
			S:	out	std_logic_vector(NBIT-1 downto 0);
			Co:	out	std_logic);
	end component;

	component REG
		generic(N: integer := NBIT);
		port(	D:	In	std_logic_vector(N-1 downto 0);
			CK:	In	std_logic;
			RESET:	In	std_logic;
			Q:	Out	std_logic_vector(N-1 downto 0));
	end component;

	signal	OUT_MUX, OUT_ADD, OUT_REG : std_logic_vector(NBIT-1 downto 0); 
	signal RESET, SEL : std_logic;
begin

	MUX21_1: MUX21
		generic map(NBIT)
		port map(B, OUT_REG, SEL, OUT_MUX);

	ADD_1: RCA
		generic map(NBIT)
		port map(A, OUT_MUX, '0', OUT_ADD, open);
	
	REG_1: REG
		generic map(NBIT)
		port map(OUT_ADD, CLK, RESET, OUT_REG);

	Y <= OUT_REG;
	RESET <= not RST_n;
	SEL <= not ACCUMULATE;

end STRUCTURAL;


architecture BEHAVIORAL of ACC is
	signal	OUT_MUX, OUT_ADD, OUT_REG : std_logic_vector(NBIT-1 downto 0); 
begin
	process(ACCUMULATE, B, OUT_REG)
	  begin
		if ACCUMULATE = '1' then 
			OUT_MUX <= OUT_REG;	
		else 
			OUT_MUX <= B;
		end if;
	end process;
	
	process(A, OUT_MUX)
	  begin
		OUT_ADD <= A + OUT_MUX;
	end process;

	process(CLK, RST_n)
	  begin
	  	if RST_n = '0' then
	    		OUT_REG <= (others => '0');
	  	elsif CLK'event and CLK = '1' then 
			OUT_REG <= OUT_ADD;
		end if;
	end process;

	Y <= OUT_REG;

end BEHAVIORAL;


configuration CFG_ACC_BEHAVIORAL of ACC is
	for BEHAVIORAL
	end for;
end CFG_ACC_BEHAVIORAL;

configuration CFG_ACC_STRUCTURAL of ACC is
	for STRUCTURAL
		for all: MUX21
			use configuration WORK.CFG_MUX21_GEN_STRUCTURAL;
		end for;
		for all: RCA
			use configuration WORK.CFG_RCA_GENERIC;
		end for;
		for all: REG
			use configuration WORK.CFG_REG_GEN_ASYNCH;
		end for;
	end for;
end CFG_ACC_STRUCTURAL;
