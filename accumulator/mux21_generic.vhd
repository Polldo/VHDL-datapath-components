library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined

entity MUX21_GENERIC is
	Generic (N: integer:= numBit;
		 DELAY_MUX: Time:= tp_mux);
	Port (	A:	In	std_logic_vector(N-1 downto 0) ;
		B:	In	std_logic_vector(N-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(N-1 downto 0));
end MUX21_GENERIC;


architecture BEHAVIORAL of MUX21_GENERIC is

begin
	Y <= A after DELAY_MUX when SEL='1' else B after DELAY_MUX;

end BEHAVIORAL;


architecture STRUCTURAL of MUX21_GENERIC is

	signal Y1: std_logic_vector(N-1 downto 0);
	signal Y2: std_logic_vector(N-1 downto 0);
	signal SB: std_logic_vector(N-1 downto 0);

	component ND2
	
	Port (	A:	In	std_logic;
		B:	In	std_logic;
		Y:	Out	std_logic);
	end component;
	
	component IV
	
	Port (	A:	In	std_logic;
		Y:	Out	std_logic);
	end component;

begin

	MUXES_GEN: for i in 0 to N-1 generate	

	UIV : IV
	Port Map ( SEL, SB(i));

	UND1 : ND2
	Port Map ( A(i), SEL, Y1(i));

	UND2 : ND2
	Port Map ( B(i), SB(i), Y2(i));

	UND3 : ND2
	Port Map ( Y1(i), Y2(i), Y(i));

	end generate MUXES_GEN;

end STRUCTURAL;


configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;

configuration CFG_MUX21_GEN_STRUCTURAL of MUX21_GENERIC is
	for STRUCTURAL
	for MUXES_GEN
		for all : IV
			use configuration WORK.CFG_IV_BEHAVIORAL;
		end for;
		for all : ND2
			use configuration WORK.CFG_ND2_ARCH2;
		end for;
	end for;
	end for;
end CFG_MUX21_GEN_STRUCTURAL;
