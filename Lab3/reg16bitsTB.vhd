library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bitsTB is
end entity;

architecture tb of reg16bitsTB is
    component reg16bits is
        port(
        clk,wr_en,reset: in std_logic;
        data_in: in unsigned(15 downto 0);
        data_out: out unsigned(15 downto 0)

    );
    end component;

    constant period_time : time := 100 ns;
    signal s_clk : std_logic;
    signal s_reset : std_logic := '0';
    signal s_wr_en : std_logic := '1';
    signal finished : std_logic := '0';
    signal data_test : UNSIGNED(15 downto 0);
    signal data_out :  UNSIGNED(15 downto 0);
    

begin
        uut : reg16bits port map(
        clk => s_clk,
        wr_en => s_wr_en,
        reset => s_reset,
        data_in => data_test,
        data_out => data_out
    );

    sim_total_time : process 
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    clk_process : process 
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
        wait for 200 ns;
        s_wr_en <= '0';
        data_test <= "1111111100000000";
        wait for 100 ns;
        data_test <= "1000110100000000";
        wait for 50 ns;
        s_wr_en <= '1';
        wait for 100 ns;
        data_test <= "1000011010000000";
        wait for 100 ns;
        data_test <= "1110001100110100";
        wait for 100 ns;
        s_reset <= '1';
        wait for 100 ns;
        s_reset <= '0';
        wait;
    end process;
end architecture;