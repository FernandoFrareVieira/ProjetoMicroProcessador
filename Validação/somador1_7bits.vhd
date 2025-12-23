library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- usado para o pc+1 do top-level
entity somador1_7bits is
    port (
        data_in : in unsigned(6 downto 0);
        data_out   : out unsigned(6 downto 0)
    );
end entity;

architecture a_somador1_7bits of somador1_7bits is

begin
    data_out <= data_in + 1;
end architecture;