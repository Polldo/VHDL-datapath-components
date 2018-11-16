----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	tb_rca_generic.vhd
----------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity TBRCA_GEN is 
end TBRCA_GEN; 

architecture TEST of TBRCA_GEN is

  constant num_bit: integer := 16;

  component RCA_GENERIC
        generic ( NBIT: integer := num_bit;
		  DRCAS : Time := 0 ns;
	          DRCAC : Time := 0 ns);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Co:	Out	std_logic);
  end component;
  

  constant Period: time := 1 ns; 
  signal A, B, S : std_logic_vector(num_bit-1 downto 0);
  signal Ci, Co : std_logic;

Begin

  UADDER: RCA_GENERIC
	   generic map (DRCAS => 0.02 ns, DRCAC => 0.02 ns) 
	   port map (A, B, Ci, S, Co);

  S1: process
  begin
    A <= "0000100000010101";
    B <= "0000001100100001";
    Ci <= '0';
    wait for 2 * PERIOD;
    Ci <= '1';
    A <= "1000100000010101";
    B <= "1100001100100001";
    wait for (65 * PERIOD);
  end process STIMULUS1;

end TEST;

configuration RCA_GENERIC_TEST of TBRCA_GEN is
  for TEST
    for UADDER: RCA_GENERIC
      use configuration WORK.CFG_RCA_GENERIC;
    end for;
  end for;
end RCA_GENERIC_TEST;
