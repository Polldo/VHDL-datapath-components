----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	p4_adder.vhd
----------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity P4_ADDER is
	generic( NBIT: integer;
		 DCARRY: integer);
	port(	A: in std_logic_vector(NBIT-1 downto 0);
		B: in std_logic_vector(NBIT-1 downto 0);
		C_0: in std_logic;
		S: out std_logic_vector(NBIT-1 downto 0));
end P4_ADDER;

architecture STRUCTURAL of P4_ADDER is

	component CARRY_GENERATOR is
		generic(	NBIT: integer;
				DCARRY: integer);
		port(	A: in std_logic_vector(NBIT-1 downto 0);
			B: in std_logic_vector(NBIT-1 downto 0);
			C_0: in std_logic;
			C: out std_logic_vector(NBIT/DCARRY-1 downto 0));
	end component;

	component SUM_GENERATOR is
		generic(NBIT: integer;
			NBLOCK: integer);
		port(	A : in std_logic_vector(NBIT*NBLOCK-1 downto 0);
			B : in std_logic_vector(NBIT*NBLOCK-1 downto 0);
			Ci : in std_logic_vector(NBLOCK-1 downto 0);
			S : out std_logic_vector(NBIT*NBLOCK-1 downto 0));
	end component;

	constant NCARRY: integer := NBIT/DCARRY;
	signal CARRY_VECTOR: std_logic_vector(NCARRY downto 0);
begin
	
	CARRY_VECTOR(0) <= C_0;

	CARRY_GEN: CARRY_GENERATOR
		generic map(NBIT, DCARRY)
		port map(A, B, C_0, CARRY_VECTOR(NCARRY downto 1));
	
	SUM_GEN: SUM_GENERATOR
		generic map(DCARRY, NCARRY)
		port map(A, B, CARRY_VECTOR(NCARRY-1 downto 0), S);

end STRUCTURAL;

configuration CFG_P4_ADDER of P4_ADDER is
	for STRUCTURAL
	end for;
end CFG_P4_ADDER;
