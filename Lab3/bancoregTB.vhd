library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoregTB is
end entity;

architecture bancoregtb of bancoregTB is
    -- Componente a testar (seu bancoreg)
    component bancoreg is
        port (
            clk   : in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            data_wr : in unsigned(15 downto 0);
            reg_wr : in unsigned(2 downto 0);
            reg_r1: in unsigned(2 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Sinais pro TB (como no PDF)
    constant period_time : time := 100 ns;  -- Período do clock (100 ns, como no PDF)
    signal finished : std_logic := '0';
    signal clk: std_logic;
    signal reset: std_logic := '0';
    signal wr_en : std_logic := '0';
    signal data_wr : unsigned(15 downto 0);
    signal reg_wr, reg_r1 : unsigned(2 downto 0);
    signal data_out : unsigned(15 downto 0);

begin
    -- Instância da UUT (Unit Under Test)
    uut: bancoreg port map (
        clk => clk,
        wr_en => wr_en,
        reset => reset,
        data_wr => data_wr,
        reg_wr => reg_wr,
        reg_r1 => reg_r1,
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

    -- Processo de estímulos (testes específicos pro banco)
    stimulus: process
    begin
        -- Processo de reset global
        reset <= '1';
        wait for period_time * 2;  
        reset <= '0';
        wait for 200 ns;
        wr_en <= '1';
        wait for 100 ns;
        reg_r1 <= "111";
        reg_wr <= "000";
        data_wr <= to_unsigned(2342,16);
        wait for 100 ns;
        reg_r1 <= "000";
        wait for 100 ns;
        reset <= '1';
        reg_wr <= "001";
        wait for period_time * 2;  
        reset <= '0';
        wait for 100 ns;
        data_wr <= to_unsigned(1004,16);
        wait for 100 ns;
        reg_r1 <= "001";
        wait for 100 ns;
        reg_wr <= "100";
        data_wr <= TO_UNSIGNED(14909,16);
        wait for 100 ns;
        reg_r1 <= "100";
        wait for 100 ns;
        reg_r1 <= "001";
        wr_en <= '0';
        wait for 100 ns;
        data_wr <= TO_UNSIGNED(5555,16);
        wait for 100 ns;
        reg_wr <= "001";
        wait for 100 ns;
        reg_wr <= "100";
        reg_r1 <= "100";
        wait for 100 ns;
        wr_en <= '1';
        wait for 100 ns;
        reg_wr <= "001";
        reg_r1 <= "001";
        wait for 100 ns;
        wr_en <= '0';
        wait for 100 ns;
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait for 100 ns;
        reg_wr <= "100";
        reg_r1 <= "100";
        wait for 100 ns;
        reg_wr <= "001";
        reg_r1 <= "001";
        wait for 100 ns;
        wr_en <= '1';
        wait for 100 ns;
        reg_wr <= "011";
        data_wr <= TO_UNSIGNED(32767,16);
        wait for 100 ns;
        wr_en <= '0';
        wait for 100 ns;
        reg_r1 <= "011";
        wait for 100 ns;
        reg_r1 <= "001";
    wait;
    end process;

end architecture;