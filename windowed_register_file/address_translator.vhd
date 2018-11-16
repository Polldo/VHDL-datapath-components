----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	address_translator.vhd
----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.all;
use WORK.log_pkg.all;

entity ADDRESS_TRANSLATOR is
 generic(	NBIT: integer := 64;
		NREG: integer := 32;
		M: integer := 8; --number of global registers
		N: integer := 8; --number of registers in each block of a window
		F: integer := 8); --number of windows
 port ( ADD_WR_IN: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
 	ADD_RD1_IN: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
	ADD_RD2_IN: 	IN std_logic_vector(log2N(3*N+M)-1 downto 0);
	FILL:		IN std_logic;
	SPILL:		IN std_logic;
	CWP:		IN integer range 0 to F-1;
	SWP:		IN integer range 0 to F-1;
	SWP_OFFSET:	IN integer range 0 to N*2-1;
 	ADD_WR_OUT: 	OUT std_logic_vector(log2N(NREG)-1 downto 0);
 	ADD_RD1_OUT: 	OUT std_logic_vector(log2N(NREG)-1 downto 0);
	ADD_RD2_OUT: 	OUT std_logic_vector(log2N(NREG)-1 downto 0));
end ADDRESS_TRANSLATOR;

architecture BEHAVIORAL of ADDRESS_TRANSLATOR is
begin
	--this is a combinational unit, so it is sensitive to all its inputs
	process(ADD_WR_IN, ADD_RD1_IN, ADD_RD2_IN, FILL, SPILL, CWP, SWP, SWP_OFFSET)
	begin
		--if a SPILL or a FILL is executing, this unit will send to the internal RF the address to read/write
		if (SPILL = '1') then
			--during a SPILL all the registers of a window must be read. their address are updated here everytime the SWP_OFFSET changes 
			ADD_RD1_OUT <= std_logic_vector(to_unsigned(SWP*2*N + M + SWP_OFFSET, ADD_RD1_OUT'length));
		elsif (FILL = '1') then
			--during a FILL the registers must be written to, in every cycle of a FILL operation the DATAIN value 
			--will be written in the current register of the window to fill. 
			ADD_WR_OUT <= std_logic_vector(to_unsigned(SWP*2*N + M + SWP_OFFSET, ADD_WR_OUT'length));
		else
			--if FILL or SPILL are not being executed, the current addresses are evaluated based on the CWP.
			if (to_integer(unsigned(ADD_WR_IN)) < M) then  
				--if the external address points to a global register then it should just be extended. because the first M registers are globals.
				ADD_WR_OUT(ADD_WR_OUT'length-1 downto ADD_WR_IN'length) <= (others => '0');
				ADD_WR_OUT(ADD_WR_IN'length-1 downto 0) <= ADD_WR_IN;
			else	--else the external address must change according to the current window pointer
				ADD_WR_OUT <= std_logic_vector(to_unsigned(CWP*2*N + to_integer(unsigned(ADD_WR_IN)), ADD_WR_OUT'length));
			end if;

			if (to_integer(unsigned(ADD_RD1_IN)) < M) then
				ADD_RD1_OUT(ADD_RD1_OUT'length-1 downto ADD_RD1_IN'length) <= (others => '0');
				ADD_RD1_OUT(ADD_RD1_IN'length-1 downto 0) <= ADD_RD1_IN;
			else
				ADD_RD1_OUT <= std_logic_vector(to_unsigned(CWP*2*N + to_integer(unsigned(ADD_RD1_IN)), ADD_RD1_OUT'length));
			end if;

			if (to_integer(unsigned(ADD_RD2_IN)) < M) then
				ADD_RD2_OUT(ADD_RD2_OUT'length-1 downto ADD_RD2_IN'length) <= (others => '0');
				ADD_RD2_OUT(ADD_RD2_IN'length-1 downto 0) <= ADD_RD2_IN;
			else
				ADD_RD2_OUT <= std_logic_vector(to_unsigned(CWP*2*N + to_integer(unsigned(ADD_RD2_IN)), ADD_RD2_OUT'length));
			end if;
		end if;
	end process;

end BEHAVIORAL;

