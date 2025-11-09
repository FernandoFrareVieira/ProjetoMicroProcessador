library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumuladores is
    port (
        clk   : in std_logic;
        wr_en : in std_logic;
        reset : in std_logic;
        data_wr : in unsigned(15 downto 0);
        sel_acc: in std_logic;  -- '0' para o acumulador A, '1' para o acumulador B
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_acumuladores of acumuladores is

    component reg16bits is
        port (
            clk,wr_en,reset: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    signal a_data_in, b_data_in : unsigned(15 downto 0);
    signal a_data_out, b_data_out : unsigned(15 downto 0);
    signal wr_en_a, wr_en_b : std_logic;

begin

    accA : reg16bits port map(
        clk => clk,
        wr_en => wr_en_a,
        reset => reset,
        data_in => a_data_in,
        data_out => a_data_out
    );
    accB : reg16bits port map(
        clk => clk,
        wr_en => wr_en_b,
        reset => reset,
        data_in => b_data_in,
        data_out => b_data_out
    );

    wr_en_a <= wr_en when sel_acc = '0' else '0';
    wr_en_b <= wr_en when sel_acc = '1' else '0';

    a_data_in <= data_wr when sel_acc = '0' else TO_UNSIGNED(0,16);
    b_data_in <= data_wr when sel_acc = '1' else TO_UNSIGNED(0,16);

    data_out <= a_data_out when sel_acc = '0' else b_data_out;

end architecture;