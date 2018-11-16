library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity TB_SUM_GENERATOR is 
end TB_SUM_GENERATOR; 

architecture TEST of TB_SUM_GENERATOR is

  constant num_bit: integer := 16;
  constant nbit : integer := 4;
  constant nblock : integer := 4;

  component SUM_GENERATOR
	generic(NBIT : integer;
		NBLOCK: integer);
	port(	A : in std_logic_vector(NBIT*NBLOCK-1 downto 0);
		B : in std_logic_vector(NBIT*NBLOCK-1 downto 0);
		Ci : in std_logic_vector(NBLOCK-1 downto 0);
		S : out std_logic_vector(NBIT*NBLOCK-1 downto 0));
  end component;
  

  constant Period: time := 1 ns; -- Clock period (1 GHz)
  signal A, B, S : std_logic_vector(num_bit-1 downto 0);
  signal Ci : std_logic_vector(nblock-1 downto 0);

Begin

  UADDER: SUM_GENERATOR
	   generic map (nbit, nblock) 
	   port map (A, B, Ci, S);

-- Open file, make a load, and wait for a timeout in case of design error.
  STIMULUS1: process
  begin
    A <= "0000100010010101";
    B <= "0000000110100001";
    Ci <= "0101";
    wait for 2 * PERIOD;
    Ci <= "0001";
    A <= "1000100000010101";
    B <= "1100001100100001";
    wait for (65 * PERIOD);
  end process STIMULUS1;

end TEST;

configuration SUM_GENERATOR_TEST of TB_SUM_GENERATOR is
  for TEST
    for UADDER: SUM_GENERATOR
      use configuration WORK.CFG_SUM_GENERATOR;
    end for;
  end for;
end SUM_GENERATOR_TEST;
