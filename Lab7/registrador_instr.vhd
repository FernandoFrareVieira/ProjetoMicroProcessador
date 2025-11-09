library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_instr is
    port (
        clk,wr_en,reset: in std_logic;
        data_in: in unsigned(17 downto 0);
        data_out: out unsigned(17 downto 0)
    );
end entity;

architecture a_registrador_instr of registrador_instr is
    

    component reg18bits is
        port (
        clk,wr_en,reset: in std_logic;
        data_in: in unsigned(17 downto 0);
        data_out: out unsigned(17 downto 0)
        );
    end component;

begin

    reg18bits_inst: reg18bits
     port map(
        clk => clk,
        wr_en => wr_en,
        reset => reset,
        data_in => data_in,
        data_out => data_out
    );
    
end architecture;