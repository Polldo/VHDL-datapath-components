library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity MUL_ENCODER is
    port(B: in std_logic_vector(2 downto 0);
        S: out std_logic_vector(2 downto 0));
end MUL_ENCODER;

architecture BEHAVIORAL of MUL_ENCODER is
begin
    process(B)
    begin
        case B is
            when "000"|"111" => S <= "000";
            when "001"|"010" => S <= "001";
            when "101"|"110" => S <= "010";
            when others => S <= B;
            --when "011" => S <= "011";
            --when "100" => S <= "100";
        end case;
    end process;

end BEHAVIORAL;

