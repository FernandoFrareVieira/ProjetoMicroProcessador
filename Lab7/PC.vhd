library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
end entity;

architecture a_pc of PC is
    

component reg07bits is
    port(
        clk,wr_en,reset: in std_logic;
        data_in: in unsigned(6 downto 0);
        data_out: out unsigned(6 downto 0)
    );
end component;

begin

    reg07bits_inst: reg07bits
     port map(
        clk => clk,
        wr_en => wr_en,
        reset => reset,
        data_in => data_in,
        data_out => data_out
    );

end architecture;