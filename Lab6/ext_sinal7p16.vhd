library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ext_sinal7p16 is
    port (
        const : in unsigned(6 downto 0);
        const_ext : out unsigned(15 downto 0)
    );
end entity;

architecture a_ext_sinal7p16 of ext_sinal7p16 is

    signal signed_const : signed(6 downto 0);
    signal signed_const_ext : signed(15 downto 0);

begin

    signed_const <= signed(const);
    signed_const_ext <= resize(signed_const, 16);
    const_ext <= unsigned(signed_const_ext);
        

end architecture;