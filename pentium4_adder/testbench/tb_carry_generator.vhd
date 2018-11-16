library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity TB_CARRY_GENERATOR is 
end TB_CARRY_GENERATOR; 

architecture TEST of TB_CARRY_GENERATOR is

  constant num_bit: integer := 32;
  constant dcarry : integer := 4;

component CARRY_GENERATOR is
  generic( NBIT: integer;
     DCARRY: integer);
  port( A: in std_logic_vector(NBIT-1 downto 0);
      B: in std_logic_vector(NBIT-1 downto 0);
	C_0: in std_logic;
      C: out std_logic_vector(NBIT/DCARRY-1 downto 0));
  end component;
  

  constant Period: time := 1 ns; -- Clock period (1 GHz)
  signal A, B : std_logic_vector(num_bit-1 downto 0);
  signal Ci : std_logic_vector(num_bit/dcarry-1 downto 0);
  signal C_0 : std_logic;
  signal C_correct: std_logic_vector(num_bit/dcarry-1 downto 0);
Begin

  UADDER: CARRY_GENERATOR
	   generic map (num_bit, dcarry) 
	   port map (A, B, C_0, Ci);

-- Open file, make a load, and wait for a timeout in case of design error.
  STIMULUS1: process
  begin
    --A <= "0000 1000 1001 1101 0000 1000 1001 1101";
    --B <= "0000 0001 1010 0101 0000 1000 1001 0101";
    A <= "00001000100111010000100010011101";
    B <= "00000001101001010000100010010101";
    C_0 <= '0';
    C_correct <= "00110111";
    wait for 2 * PERIOD;
    --C_correct <= '1';
    --A <= "10001000000101010000100010010101";
    --B <= "11000011001000011000100000010101";
    wait for (65 * PERIOD);
  end process STIMULUS1;

end TEST;

configuration CARRY_GENERATOR_TEST of TB_CARRY_GENERATOR is
  for TEST
    for UADDER: CARRY_GENERATOR
      use configuration WORK.CFG_CARRY_GENERATOR;
    end for;
  end for;
end CARRY_GENERATOR_TEST;
