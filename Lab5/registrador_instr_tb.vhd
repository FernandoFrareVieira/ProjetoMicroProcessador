library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_instr_tb is
end entity;

architecture a_registrador_instr_tb of registrador_instr_tb is
    component registrador_instr is
        port(
            clk, wr_en, reset : in std_logic;
            data_in           : in unsigned(17 downto 0);
            data_out          : out unsigned(17 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal s_clk      : std_logic;
    signal s_reset    : std_logic := '0';
    signal s_wr_en    : std_logic := '1';
    signal finished   : std_logic := '0';
    signal data_test  : unsigned(17 downto 0);
    signal data_out   : unsigned(17 downto 0);
    
begin
    uut: registrador_instr 
        port map(
            clk      => s_clk,
            wr_en    => s_wr_en,
            reset    => s_reset,
            data_in  => data_test,
            data_out => data_out
        );


    reset_global : process
    begin
        s_reset <= '1';
        wait for period_time*2;
        s_reset <= '0';
        wait;
    end process;

    sim_total_time: process 
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    clk_process: process 
    begin
        while finished /= '1' loop
            s_clk <= '0';
            wait for period_time/2;
            s_clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process;

    process 
    begin
        s_wr_en <= '0';
        data_test <= "111111110000000000";  -- 18 bits
        wait for 100 ns;
        data_test <= "100011010000000000";  -- 18 bits
        wait for 50 ns;
        s_wr_en <= '1';
        wait for 100 ns;
        data_test <= "100001101000000000";  -- 18 bits
        wait for 100 ns;
        data_test <= "111000110011010000";  -- 18 bits
        wait;
    end process;
    
end architecture;