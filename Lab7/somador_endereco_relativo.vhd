library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador_endereco_relativo is
    port (
        endereco_pc : in unsigned(6 downto 0);
        deslocamento   : in unsigned(6 downto 0);
        endereco_rel   : out unsigned(6 downto 0)
    );
end entity;

architecture a_somador_endereco_relativo of somador_endereco_relativo is
    signal endereco_pc_signed : signed(6 downto 0);
    signal endereco_pc_menos1 : signed(6 downto 0);
    signal deslocanto_signed : signed(6 downto 0);
    signal endereco_rel_signed : signed(6 downto 0);
begin

deslocanto_signed <= signed(deslocamento);
endereco_pc_signed <= SIGNED(endereco_pc);
endereco_pc_menos1 <= endereco_pc_signed - 1;
endereco_rel_signed <= endereco_pc_menos1 + deslocanto_signed;
endereco_rel <= UNSIGNED(endereco_rel_signed);


end architecture;
