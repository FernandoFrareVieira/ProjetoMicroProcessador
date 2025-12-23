library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ext_sinal8p16 is
    port (
        const : in unsigned(7 downto 0);
        const_ext : out unsigned(15 downto 0)
    );
end entity;

architecture a_ext_sinal8p16 of ext_sinal8p16 is

begin

    const_ext <= "00000000" & const when const(7) = '0' else "11111111" & const;   

end architecture;