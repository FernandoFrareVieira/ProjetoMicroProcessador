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
    signal endereco_pc_menos1 : unsigned(6 downto 0);
begin

endereco_pc_menos1 <= endereco_pc - 1;
endereco_rel <= endereco_pc_menos1 + deslocamento;

end architecture;
