library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estado_tb is

end entity maq_estado_tb;

architecture a_maq_estado_tb of maq_estado_tb is

    constant period_time : time := 100 ns;  -- Período do clock (100 ns, como no PDF)
    signal finished : std_logic := '0';
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal estado   : std_logic;


    component maq_estado is 
            port(
        clk : in std_logic;
        reset : in std_logic;
        estado : out std_logic
    );
    end component;

begin


    uut: maq_estado
        port map (
            clk => clk,
            reset => reset,
            estado => estado
        );


    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us; 
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    stim_proc: process
    begin
        wait;
    end process stim_proc;

    

end architecture;