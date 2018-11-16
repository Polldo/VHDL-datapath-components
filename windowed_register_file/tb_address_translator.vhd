----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	tb_address_translator.vhd
----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.all;
use WORK.log_pkg.all;

entity TB_ADDRESS is
end TB_ADDRESS;

architecture TEST of TB_ADDRESS is

component ADDRESS_TRANSLATOR is
 generic(	NBIT: integer := 64;
		NREG: integer := 32;
		M: integer := 8; --number of global registers
		N: integer := 8; --number of registers in each block of a window
		F: integer := 8); --number of windows
 port ( ADD_WR_IN: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
 	ADD_RD1_IN: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
	ADD_RD2_IN: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
	FILL:		IN std_logic;
	SPILL:		IN std_logic;
	CWP:		IN integer range 0 to F-1;
	SWP:		IN integer range 0 to F-1;
	SWP_OFFSET:	IN integer range 0 to N*2-1;
 	ADD_WR_OUT: 	OUT std_logic_vector(log2N(NREG)-1 downto 0);
 	ADD_RD1_OUT: 	OUT std_logic_vector(log2N(NREG)-1 downto 0);
	ADD_RD2_OUT: 	OUT std_logic_vector(log2N(NREG)-1 downto 0));
end component;

  constant NBIT : integer := 8;
  constant NREG : integer := 64;
  constant F : integer := 4;
  constant N : integer := 4;
  constant M : integer := 4;

  constant period : time := 1 ns;

  signal ADD_WR_IN, ADD_RD1_IN, ADD_RD2_IN : std_logic_vector(log2N(3*N+M)-1 downto 0);
  signal FILL, SPILL : std_logic;
  signal CWP, SWP : integer range 0 to F-1;
  signal SWP_OFFSET: integer range 0 to N*2-1;
  signal ADD_WR_OUT, ADD_RD1_OUT, ADD_RD2_OUT: std_logic_vector(log2N(NREG)-1 downto 0);

begin
	UUT: ADDRESS_TRANSLATOR
		generic map(NBIT,NREG,M,N,F)
		port map(ADD_WR_IN, ADD_RD1_IN, ADD_RD2_IN,FILL,SPILL,CWP,SWP,SWP_OFFSET,ADD_WR_OUT, ADD_RD1_OUT, ADD_RD2_OUT);

	process
	begin
		ADD_WR_IN <= "0000","0111" after 2 ns;
		ADD_RD1_IN <= "0000", "0110" after 2 ns;
		ADD_RD2_IN <= "0001";
		FILL <= '0';
		SPILL <= '0','1' after 10 ns;
		CWP <= 0,1 after 4 ns, 2 after 6 ns, 3 after 8 ns;
		SWP <= 0,1 after 10 ns;
		SWP_OFFSET <= 0,1 after 12 ns, 2 after 14 ns, 3 after 16 ns;
		wait for 65*period;
	end process;

end TEST;

configuration CFG_TEST_ADDRESS_TRANSLATOR of TB_ADDRESS is
for TEST
	--for UUT: ADDRESS_TRANSLATOR	
	--	use configuration: WORK.
end for;
end configuration;
