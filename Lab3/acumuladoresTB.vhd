library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumuladoresTB is
end entity;

architecture acumuladorestb of acumuladoresTB is
    -- Componente a testar (seu acumuladores)
    component acumuladores is
        port (
            clk   : in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            data_wr : in unsigned(15 downto 0);
            sel_acc: in std_logic;  -- '0' para A, '1' para B
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Sinais pro TB (como no PDF)
    constant period_time : time := 100 ns;  -- Período do clock (100 ns, como no PDF)
    signal finished : std_logic := '0';
    signal clk: std_logic;
    signal reset: std_logic := '0';
    signal wr_en : std_logic := '0';
    signal sel_acc : std_logic := '0';
    signal data_wr : unsigned(15 downto 0);
    signal data_out : unsigned(15 downto 0);

begin
    -- Instância da UUT (Unit Under Test)
    uut: acumuladores port map (
        clk => clk,
        wr_en => wr_en,
        reset => reset,
        data_wr => data_wr,
        sel_acc => sel_acc,
        data_out => data_out
    );
    -- Processo de tempo total de simulação (10 us, como no PDF)
    sim_time_proc: process
    begin
        wait for 10 us;  -- TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;
    -- Processo de clock (gera até o sim_time_proc terminar, como no PDF)
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
    
    principal : process
    begin
        reset <= '1';
        wait for period_time * 2;  
        reset <= '0';
        wait for 200 ns;
        data_wr <= to_unsigned(400,16);
        sel_acc <= '0';
        wait for 100 ns;
        wr_en <= '1';
        wait for 100 ns;
        wr_en <= '0';
        data_wr <= to_unsigned(4344,16);
        wait for 100 ns;
        sel_acc <= '1';
        wait for 100 ns;
        data_wr <= TO_UNSIGNED(2314,16);
        wr_en <= '1';
        wait for 100 ns;
        wr_en <= '0';
        wait for 100 ns;
        sel_acc <= '0';
        wait for 100 ns;
        sel_acc <= '1';
        wait for 100 ns;
        reset <= '1';
        wait for period_time * 2;  
        reset <= '0';
        wait for 100 ns;
        sel_acc <= '0';
    wait;
    end process;

end architecture;