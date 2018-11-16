library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity TB_P4_ADDER is 
end TB_P4_ADDER; 

architecture TEST of TB_P4_ADDER is

  constant num_bit: integer := 32;
  constant dcarry : integer := 4;

  component P4_ADDER is
	generic( NBIT: integer;
		 DCARRY: integer);
	port(	A: in std_logic_vector(NBIT-1 downto 0);
		B: in std_logic_vector(NBIT-1 downto 0);
		C_0: in std_logic;
		S: out std_logic_vector(NBIT-1 downto 0));
  end component;
  

  constant Period: time := 1 ns; -- Clock period (1 GHz)
  signal A, B, S, RES : std_logic_vector(num_bit-1 downto 0);
  signal C_0 : std_logic;

Begin

  UADDER: P4_ADDER
	   generic map (num_bit, dcarry) 
	   port map (A, B, C_0, S);

-- Open file, make a load, and wait for a timeout in case of design error.
  STIMULUS1: process
  begin

    A <=   "11111111111111101111111111111110";
    B <=   "00111000100000010011100010000001";
    RES <= "00111000100000000011100001111111";
    C_0 <= '0';
    wait for 2 * PERIOD;
    C_0 <= '1';
    RES <= "00111000100000000011100010000000";
    wait for 2 * PERIOD;
    A <=   "11111111111111111111111111111111";
    B <=   "00000000000000000000000000000000";
    RES <= "00000000000000000000000000000000";
    C_0 <= '1';
    wait for (65 * PERIOD);
  end process STIMULUS1;

end TEST;

configuration P4_ADDER_TEST of TB_P4_ADDER is
  for TEST
    for UADDER: P4_ADDER
      use configuration WORK.CFG_P4_ADDER;
    end for;
  end for;
end P4_ADDER_TEST;
