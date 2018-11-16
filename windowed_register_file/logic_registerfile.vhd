library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.all;
use WORK.log_pkg.all;

entity LOGIC_REGISTER_FILE is
 generic(	NBIT: integer := 64;
		NREG: integer := 32;
		M: integer := 8; --number of global registers
		N: integer := 8; --number of registers in each block of a window
		F: integer := 8); --number of windows
 port ( CLK: 		IN std_logic;
        RESET: 		IN std_logic;
	CALL:		IN std_logic;
	RET:		IN std_logic;
	FILL:		OUT std_logic;
	SPILL:		OUT std_logic;
	CWP:		OUT integer range 0 to F-1;
	SWP:		OUT integer range 0 to F-1;
	SWP_OFFSET:	OUT integer range 0 to N*2-1);
end LOGIC_REGISTER_FILE;

architecture BEHAVIORAL of LOGIC_REGISTER_FILE is

    signal INTERNAL_CWP, INTERNAL_SWP : integer range 0 to F-1 := 0;
    signal CANSAVE : integer range 0 to F-2 := F-2;
    signal CANRESTORE : integer range 0 to F-2 := 0;
    signal INTERNAL_FILL, INTERNAL_SPILL : std_logic := '0';
    signal INTERNAL_SWP_OFFSET : integer range 0 to N*2-1 := 0;
    signal COUNT : integer range 0 to N*2-1 := 0;
	
begin 

	FILL <= INTERNAL_FILL;
	SPILL <= INTERNAL_SPILL;
	CWP <= INTERNAL_CWP;
	SWP <= INTERNAL_SWP;
	SWP_OFFSET <= INTERNAL_SWP_OFFSET;

	process(CLK)
	begin
	if (CLK'event and CLK='1') then
		--RESET signal has precedence over all
		if (RESET = '1') then
			--clear pointers and internal signals
			INTERNAL_CWP <= 0;
			INTERNAL_SWP <= 0;
			CANSAVE <= F-2; --indicates how many 'consecutive' CALL can be done without freeing other windows 
			CANRESTORE <= 0;	
			INTERNAL_FILL <= '0';
			INTERNAL_SPILL <= '0';
			INTERNAL_SWP_OFFSET <= 0;
			COUNT <= 0;

		--if the RF is spilling or filling then other operations are locked
		elsif (INTERNAL_SPILL = '1') then
			--during a SPILL all the registers of the oldest window must be saved by a memory through the RD1 OUTPUT BUS
			if (COUNT = 0) then
				INTERNAL_SPILL <= '0';
				INTERNAL_SWP_OFFSET <= 0; --the SWP_OFFSET is used to select the current register to spill
				INTERNAL_SWP <= (INTERNAL_SWP + 1) mod F;  --the SWP points to the first register of the window to be spilled
			else
				COUNT <= COUNT - 1;
				INTERNAL_SWP_OFFSET <= INTERNAL_SWP_OFFSET + 1;
			end if;

		elsif (INTERNAL_FILL = '1') then
			--during a FILL the registers of the first spilled window must be restored through the WRITE BUS.
			if (COUNT = 0) then
				INTERNAL_FILL <= '0';
				INTERNAL_SWP_OFFSET <= 0;
			else			
				COUNT <= COUNT - 1;
				INTERNAL_SWP_OFFSET <= INTERNAL_SWP_OFFSET + 1;	
			end if;
	

		elsif (CALL = '1') then
			INTERNAL_CWP <= (INTERNAL_CWP + 1) mod F;
			if (CANSAVE = 0) then  --if all the windows are busy, spill the oldest window
				INTERNAL_SPILL <= '1';
				COUNT <= (N*2)-1; --used to count the cycles needed to spill/fill the entire window.
			else
				CANSAVE <= CANSAVE - 1;
				CANRESTORE <= CANRESTORE + 1;
			end if;


		elsif (RET = '1') then
			INTERNAL_CWP <= (INTERNAL_CWP - 1) mod F;
			if (CANRESTORE = 0) then
				INTERNAL_FILL <= '1';
				COUNT <= (N*2)-1;
				INTERNAL_SWP <= (INTERNAL_SWP - 1) mod F; --updates the SWP to make it pointing to the window to fill.
			else
				CANRESTORE <= CANRESTORE - 1;
				CANSAVE <= CANSAVE + 1;
			end if;		
		
		end if;
	end if;
	end process;


end BEHAVIORAL;


configuration CFG_LOGIC_RF of LOGIC_REGISTER_FILE is
  for BEHAVIORAL
  end for;
end configuration;
