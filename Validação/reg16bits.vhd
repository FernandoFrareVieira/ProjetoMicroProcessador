library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- usado no registrado do banco
entity reg16bits is
    port(
        clk,wr_en,reset: in std_logic;
        data_in: in unsigned(15 downto 0);
        data_out: out unsigned(15 downto 0)
    );
end entity;

architecture a_reg16bits of reg16bits is  
signal registro: unsigned(15 downto 0);
begin

process(clk,wr_en,reset)
begin
    if reset = '1' then
        registro <= "0000000000000000";
    elsif wr_en = '1' then
        if rising_edge(clk) then
            registro <= data_in;
        end if;
    end if;
end process;

data_out <= registro;

end architecture;