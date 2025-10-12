library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned( 17 downto 0)  
    );
end entity;
architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        0 => TO_UNSIGNED(13,18),
        1 => TO_UNSIGNED(14,18),
        2 => TO_UNSIGNED(15,18),
        3 => TO_UNSIGNED(16,18),
        4 => TO_UNSIGNED(17,18),
        5 => TO_UNSIGNED(18,18),
        6 => TO_UNSIGNED(19,18),
        7 => TO_UNSIGNED(20,18),
        8 => TO_UNSIGNED(21,18),
        9 => TO_UNSIGNED(22,18),
        10 => TO_UNSIGNED(23,18),
        11 => TO_UNSIGNED(24,18),
        12 => TO_UNSIGNED(25,18),
        13 => TO_UNSIGNED(26,18),
        14 => TO_UNSIGNED(27,18),
        15 => TO_UNSIGNED(28,18),
        others => (others=>'0')
    );
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
