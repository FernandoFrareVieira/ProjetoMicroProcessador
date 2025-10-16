library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevel_tb is
end entity topLevel_tb;

architecture a_tb of topLevel_tb is

    component topLevel is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            pc_write_en : out std_logic;
            jump_enable : out std_logic;
            saida_pc        : out unsigned(6 downto 0);
            saida_instrucao : out unsigned(17 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal clk_s   : std_logic;
    signal reset_s : std_logic;
    signal pc_write_en_s : std_logic;
    signal jump_enable_s : std_logic;
    signal saida_pc_s        : unsigned(6 downto 0);
    signal saida_instrucao_s : unsigned(17 downto 0);

begin

    uut: topLevel port map (
        clk             => clk_s,
        reset           => reset_s,
        pc_write_en     => pc_write_en_s,
        jump_enable     => jump_enable_s,
        saida_pc        => saida_pc_s,
        saida_instrucao => saida_instrucao_s
    );

    reset_global: process
    begin
        reset_s <= '1';
        wait for  200 ns; 
        reset_s <= '0';
        wait; 
    end process reset_global;

    sim_time_proc: process
    begin
        wait for 2 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk_s <= '0';
            wait for period_time / 2;
            clk_s <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    process
        begin
        wait; 
    end process;

end architecture a_tb;