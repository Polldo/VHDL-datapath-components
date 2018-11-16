----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	registerfile.vhd
----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.all;
use WORK.log_pkg.all;

entity REGISTER_FILE is
 generic( NBIT: integer := 64;
	  NREG: integer := 32);
 port ( CLK: 		IN std_logic;
        RESET: 		IN std_logic;
	ENABLE: 	IN std_logic;
	RD1: 		IN std_logic;
 	RD2: 		IN std_logic;
 	WR: 		IN std_logic;
 	ADD_WR: 	IN std_logic_vector(log2N(NREG)-1 downto 0);
 	ADD_RD1: 	IN std_logic_vector(log2N(NREG)-1 downto 0);
	ADD_RD2: 	IN std_logic_vector(log2N(NREG)-1 downto 0);
 	DATAIN: 	IN std_logic_vector(NBIT-1 downto 0);
        OUT1: 		OUT std_logic_vector(NBIT-1 downto 0);
 	OUT2: 		OUT std_logic_vector(NBIT-1 downto 0));
end REGISTER_FILE;

architecture BEHAVIORAL of REGISTER_FILE is

    subtype REG_ADDR is natural range 0 to NREG-1; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBIT-1 downto 0); 
	signal REGISTERS : REG_ARRAY; 

	
begin 
	
  SYNCH_REG_FILE: 
	--all the operations are synchronous, all changes occurs when CLOCK signal changes -> CLK should be the only element of the sensitivity list
	process(CLK)
	begin
		--we consider just the clock rising edge, as specified in the lab_pdf 
		if (CLK'event and CLK='1') then
			--here i'm giving to the reset the priority over all the other operations.
			if (RESET = '1') then
				REGISTERS <= (others => (others => '0')); --reset all registers
				OUT1 <= (others => '0'); --clean the reg. file outputs (i'm not sure if it's needed but it makes sense)
				OUT2 <= (others => '0');
			--if reset is not HIGH, check if other operations are enabled and eventually 'activate' them
			elsif (ENABLE = '1') then
				--all the operations here are concurrent. The read values correspond to the values contained by registers during the previous clock cycle
				if (RD1 = '1') then
					OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
				end if;

				if (RD2 = '1') then
					OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
				end if;

				if (WR = '1') then
					REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
				end if;

			end if;

		end if;

	end process;


end BEHAVIORAL;

----


configuration CFG_RF_BEH of REGISTER_FILE is
  for BEHAVIORAL
  end for;
end configuration;
