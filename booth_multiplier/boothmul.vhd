library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all; 

entity BOOTHMUL is
	generic(NBIT: integer);
	port(A: in std_logic_vector(NBIT-1 downto 0);
		 B: in std_logic_vector(NBIT-1 downto 0);
		 S: out std_logic_vector(2*NBIT-1 downto 0));
end BOOTHMUL;

--UNSIGNED MULTIPLICATIONS --- to make it working with signed numbers i need to change the 'extension' of A and B signals.
architecture STRUCTURAL of BOOTHMUL is

	component RCA_GENERIC is 
		generic (	NBIT: integer;
					DRCAS : Time := 0 ns;
		         	DRCAC : Time := 0 ns);
		port (	A:	in	std_logic_vector(NBIT-1 downto 0);
				B:	in	std_logic_vector(NBIT-1 downto 0);
				Ci:	in	std_logic;
				S:	out	std_logic_vector(NBIT-1 downto 0);
	   			Co:	out	std_logic);
	end component; 

    component MUL_ENCODER is
        port(B: in std_logic_vector(2 downto 0);
            S: out std_logic_vector(2 downto 0));
    end component;

    component MUX51_GEN is
    	generic (NBIT: integer);
    	port (	  A:  in std_logic_vector(NBIT-1 downto 0);
		  B:  in std_logic_vector(NBIT-1 downto 0);
		  C:  in std_logic_vector(NBIT-1 downto 0);
		  D:  in std_logic_vector(NBIT-1 downto 0);
		  E:  in std_logic_vector(NBIT-1 downto 0);
        	  SEL: in std_logic_vector(2 downto 0);
        	  S: out std_logic_vector(NBIT-1 downto 0));
    end component;

    constant B_BIT : integer := NBIT+3;
    constant N: integer := B_BIT/2;
    constant RES_NBIT: integer := 2*NBIT;

    type SignalVector is array(4 downto 0) of std_logic_vector(RES_NBIT-1 downto 0);
    type SignalMatrix is array(N-1 downto 0) of SignalVector;
    signal A_signals: SignalMatrix;

    type n_vector_of_nbit is array(N-1 downto 0) of std_logic_vector(RES_NBIT-1 downto 0);
    signal SUM_signals: n_vector_of_nbit;
    signal MUX_out_signals: n_vector_of_nbit;
    type n_vector_of_3bit is array(N-1 downto 0) of std_logic_vector(2 downto 0);
    signal MUX_sel_signals: n_vector_of_3bit;

    signal A_EXT: std_logic_vector(RES_NBIT-1 downto 0);
    signal B_EXT: std_logic_vector(B_BIT-1 downto 0);

begin
    
    B_EXT <= "00" & B & "0";
    A_EXT(NBIT-1 downto 0) <= A;
    A_EXT(RES_NBIT-1 downto NBIT) <= (others => '0');

    SUM_signals(0) <= MUX_out_signals(0);

    A_SIGNALS_GEN:
	--FIRST_A_SIGNALS_GEN:
		A_signals(0)(0) <= (others => '0');
		A_signals(0)(1) <= A_EXT;
		A_signals(0)(2) <= not A_signals(0)(1) + 1;
		A_signals(0)(3) <= std_logic_vector(shift_left(signed(A_EXT), 1));
		A_signals(0)(4) <= not A_signals(0)(3) + 1;
	GENERICS_A_SIGNALS_GEN:
	for I in 1 to N-1 generate
		A_signals(I)(0) <= (others => '0');
		A_signals(I)(1) <= std_logic_vector(shift_left(signed(A_signals(I-1)(1)), 2));
		A_signals(I)(2) <= not A_signals(I)(1) + 1;
		A_signals(I)(3) <= std_logic_vector(shift_left(signed(A_signals(I-1)(3)), 2));
		A_signals(I)(4) <= not A_signals(I)(3) + 1;
	end generate;

    MUXES_GEN:
	for I in 0 to N-1 generate
	   GEN_MUX: MUX51_GEN 
            generic map(RES_NBIT)
            port map(A_signals(I)(0), A_signals(I)(1), A_signals(I)(2), A_signals(I)(3), 
		     A_signals(I)(4), MUX_sel_signals(I), MUX_out_signals(I));
	end generate;

    ENCODERS_GEN:
	for I in 1 to N generate
	   GEN_ENCODER: MUL_ENCODER
            port map(B_EXT(2*I downto 2*I-2), MUX_sel_signals(I-1));
	end generate;

    RCAS_GEN:
	for I in 1 to N-1 generate
           GEN_RCA: RCA_GENERIC
            generic map(RES_NBIT)
            port map(MUX_out_signals(I), SUM_signals(I-1), '0', SUM_signals(I), open);
	end generate;

    S <= SUM_signals(N-1);

end STRUCTURAL; 

configuration CFG_BOOTHMUL of BOOTHMUL is
	for STRUCTURAL
	end for;
end CFG_BOOTHMUL;
