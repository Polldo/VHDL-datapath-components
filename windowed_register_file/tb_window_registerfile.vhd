----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	tb_window_registerfile.vhd
----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use WORK.all;
use WORK.log_pkg.all;

entity TB_WIN_REGISTERFILE is
end TB_WIN_REGISTERFILE;

architecture TESTA of TB_WIN_REGISTERFILE is

	constant NBIT: integer := 4;
	constant NADDR: integer := 4;
	
       signal CLK: std_logic := '0';
       signal RESET: std_logic;
       signal ENABLE: std_logic;
       signal RD1: std_logic;
       signal RD2: std_logic;
       signal WR: std_logic;
       signal CALL: std_logic;
       signal RET: std_logic;
       signal ADD_WR: std_logic_vector(NADDR-1 downto 0);
       signal ADD_RD1: std_logic_vector(NADDR-1 downto 0);
       signal ADD_RD2: std_logic_vector(NADDR-1 downto 0);
       signal DATAIN: std_logic_vector(NBIT-1 downto 0);
       signal OUT1: std_logic_vector(NBIT-1 downto 0);
       signal OUT2: std_logic_vector(NBIT-1 downto 0);
       signal FILL: std_logic;
       signal SPILL: std_logic;

component WINDOW_REGISTER_FILE is
 generic(	NBIT: integer := 64;
		NREG: integer := 32;
		M: integer := 8; 
		N: integer := 8; 
		F: integer := 8);
 port ( CLK: 		IN std_logic;
        RESET: 		IN std_logic;
	ENABLE: 	IN std_logic;
	RD1: 		IN std_logic;
 	RD2: 		IN std_logic;
 	WR: 		IN std_logic;
	CALL:		IN std_logic;
	RET:		IN std_logic;
 	ADD_WR: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
 	ADD_RD1: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
	ADD_RD2: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
 	DATAIN: 	IN std_logic_vector(NBIT-1 downto 0);
        OUT1: 		OUT std_logic_vector(NBIT-1 downto 0);
 	OUT2: 		OUT std_logic_vector(NBIT-1 downto 0);
	FILL:		OUT std_logic;
	SPILL:		OUT std_logic);
end component;

begin 

RG: WINDOW_REGISTER_FILE

GENERIC MAP(4, 64, 4, 4, 4)
PORT MAP (CLK,RESET,ENABLE,RD1,RD2,WR,CALL,RET,ADD_WR,ADD_RD1,ADD_RD2,DATAIN,OUT1,OUT2,FILL,SPILL);
	RESET <= '1', '0' after 2 ns;
	ENABLE <= '1';
	WR <= '0','1' after 2 ns,'0' after 20 ns,'1' after 42 ns;
	RD1 <= '0','1' after 42 ns; 
	RD2 <= '1','0' after 20 ns;
	CALL <= '0', '1' after 20 ns,'0' after 42 ns;
	RET <= '0';
	ADD_WR <= "0010", "0100" after 4 ns,"0101" after 6 ns,"0110" after 8 ns,"0111" after 10 ns,"1000" after 12 ns, "1001" after 14 ns,"1010" after 16 ns,"1011" after 18 ns;
	ADD_RD1 <= "0111", "1011" after 42 ns;
	ADD_RD2 <= "0010";
	DATAIN <= (others => '1'), "0001" after 4 ns,"0010" after 6 ns, "0011" after 8 ns, "0100" after 10 ns,"0101" after 12 ns, "0110" after 14 ns,"0111" after 16 ns,"1000" after 18 ns;

	PCLOCK : process(CLK)
	begin
		CLK <= not(CLK) after 1 ns;	
	end process;

end TESTA;

---
configuration CFG_TEST_WIND_RF of TB_WIN_REGISTERFILE is
  for TESTA
	for RG : WINDOW_REGISTER_FILE
		use configuration WORK.CFG_WINDOW_RF;
	end for; 
  end for;
end CFG_TEST_WIND_RF;
