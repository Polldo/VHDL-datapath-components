library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;
use WORK.log_pkg.all;

entity TB_LOGICRF is
end TB_LOGICRF;

architecture TEST of TB_LOGICRF is

component LOGIC_REGISTER_FILE is
 generic(	NBIT: integer := 64;
		NREG: integer := 32;
		M: integer := 8; --number of global registers
		N: integer := 8; --number of registers in each block of a window
		F: integer := 8); --number of windows
 port ( CLK: 		IN std_logic;
        RESET: 		IN std_logic;
	CALL:		IN std_logic;
	RET:		IN std_logic;
	FILL:		OUT std_logic;
	SPILL:		OUT std_logic;
	CWP:		OUT integer range 0 to F-1;
	SWP:		OUT integer range 0 to F-1;
	SWP_OFFSET:	OUT integer range 0 to N*2-1);
end component;

  constant F : integer := 4;
  constant N : integer := 4;
  constant M : integer := 4;

  signal CLK : std_logic := '0';
  signal RESET, CALL, RET, FILL, SPILL : std_logic;
  signal CWP, SWP : integer range 0 to F-1;
  signal SWP_OFFSET : integer range 0 to N*2-1;

  constant period : time := 1 ns;

begin

	RG: LOGIC_REGISTER_FILE
		generic map(4,64,M,N,F)
		port map(CLK, RESET, CALL, RET, FILL, SPILL, CWP, SWP, SWP_OFFSET);
	RESET <= '0','1' after 2 ns,'0' after 4 ns;
	CALL <= '0','1' after 4 ns,'0' after 28 ns;
	RET <= '0','1' after 28 ns;


PCLOCK : process(CLK)
	begin
		CLK <= not(CLK) after period;	
	end process;


end TEST;

configuration TEST_LOGIC_RF of TB_LOGICRF is
	for TEST
		for RG : LOGIC_REGISTER_FILE
			use configuration WORK.CFG_LOGIC_RF;
		end for; 
	end for;
end configuration;
