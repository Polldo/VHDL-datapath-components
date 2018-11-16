library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 

entity TB_CARRY_SELECT_BLOCK is 
end TB_CARRY_SELECT_BLOCK; 

architecture TEST of TB_CARRY_SELECT_BLOCK is

  constant num_bit: integer := 16;

  component CARRY_SELECT_BLOCK
	generic( N: integer);
	port(	A: in std_logic_vector(N-1 downto 0);
		B: in std_logic_vector(N-1 downto 0);
		Ci: in std_logic;
		S: out std_logic_vector(N-1 downto 0));
  end component;
  

  constant Period: time := 1 ns; -- Clock period (1 GHz)
  signal A, B, S : std_logic_vector(num_bit-1 downto 0);
  signal Ci : std_logic;

Begin

  UADDER: CARRY_SELECT_BLOCK
	   generic map (num_bit) 
	   port map (A, B, Ci, S);

-- Open file, make a load, and wait for a timeout in case of design error.
  STIMULUS1: process
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

configuration CARRY_SELECT_BLOCK_TEST of TB_CARRY_SELECT_BLOCK is
  for TEST
    for UADDER: CARRY_SELECT_BLOCK
      use configuration WORK.CFG_CARRY_SELECT_BLOCK;
    end for;
  end for;
end CARRY_SELECT_BLOCK_TEST;
