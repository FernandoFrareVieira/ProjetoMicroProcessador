library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC_tb is
end entity UC_tb;

architecture a_UC_tb of UC_tb is

    constant period_time : time := 100 ns; 
    signal finished : std_logic := '0';
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal pc_wr_en : std_logic;

    component UC is
        port (
            instruc : in UNSIGNED(17 downto 0);
            clk   : in std_logic;
            reset : in std_logic;
            pc_wr : out std_logic
        );
    end component;

begin

    UC_inst: UC
     port map(
        instruc => "000000000000000000",
        clk => clk,
        reset => reset,
        pc_wr => pc_wr_en
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
