----------------------------------------
--		author: Paolo Calao			
--		mail:	paolo.calao@gmail.com
--		title:	mux51_gen.vhd
----------------------------------------

library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity MUX51_GEN is
    generic (NBIT: integer);
    port (A:  in std_logic_vector(NBIT-1 downto 0);
	  B:  in std_logic_vector(NBIT-1 downto 0);
	  C:  in std_logic_vector(NBIT-1 downto 0);
	  D:  in std_logic_vector(NBIT-1 downto 0);
	  E:  in std_logic_vector(NBIT-1 downto 0);
          SEL: in std_logic_vector(2 downto 0);
          S: out std_logic_vector(NBIT-1 downto 0));
end MUX51_GEN;


architecture BEHAVIORAL of MUX51_GEN is
begin

    process(A, B, C, D, E, SEL)
    begin
        case SEL is
            when "000" => S <= A;
            when "001" => S <= B;
            when "010" => S <= C;
            when "011" => S <= D;
            when others => S <= E;
        end case;
    end process;

end BEHAVIORAL;
