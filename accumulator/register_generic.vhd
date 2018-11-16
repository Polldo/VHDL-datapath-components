library IEEE;
use IEEE.std_logic_1164.all; 

entity REGISTER_GENERIC is
	generic(N: integer);
	port(	D:	In	std_logic_vector(N-1 downto 0);
		CK:	In	std_logic;
		RESET:	In	std_logic;
		Q:	Out	std_logic_vector(N-1 downto 0));
end REGISTER_GENERIC;

architecture SYNCH_ARCH of REGISTER_GENERIC is
begin
	RSYNCH: process(CK,RESET)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' then -- active high reset 
	      Q <= (others => '0'); 
	    else
	      Q <= D; -- input is written on output
	    end if;
	  end if;
	end process;
end SYNCH_ARCH;

architecture ASYNCH_ARCH of REGISTER_GENERIC is
begin
	RASYNCH: process(CK,RESET)
	begin
	  if RESET='1' then
	    Q <= (others => '0');
	  elsif CK'event and CK='1' then -- positive edge triggered:
	    Q <= D; 
	  end if;
	end process;
end ASYNCH_ARCH;

configuration CFG_REG_GEN_SYNCH of REGISTER_GENERIC is
	for SYNCH_ARCH
	end for;
end CFG_REG_GEN_SYNCH;
configuration CFG_REG_GEN_ASYNCH of REGISTER_GENERIC is
	for ASYNCH_ARCH
	end for;
end CFG_REG_GEN_ASYNCH;
