library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_tb is
end entity PC_tb;

architecture a_PC_tb of PC_tb is

    constant period_time : time := 100 ns;  -- Período do clock (100 ns, como no PDF)
    signal finished : std_logic := '0';
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal pc_wr_en : std_logic;
    signal pc_data_out_somador_in : unsigned (6 downto 0);
    signal somador_out_pc_in : unsigned (6 downto 0);
    signal data_out_rom : unsigned (17 downto 0);


    component PC is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
    end component;

    component somador1_7bits is
    port (
        data_in : in unsigned(6 downto 0);
        data_out   : out unsigned(6 downto 0)
    );
    end component;

    component rom is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned( 17 downto 0)  
        );
    end component;

    component UC is
        port (
            instruc : in UNSIGNED(17 downto 0);
            clk   : in std_logic;
            reset : in std_logic;
            pc_wr_en : out std_logic
        );
    end component;

begin

    UC_inst: UC
     port map(
        instruc => "000000000000000000",
        clk => clk,
        reset => reset,
        pc_wr_en => pc_wr_en
    );

    PC_inst: PC
     port map(
        clk => clk,
        reset => reset,
        wr_en => pc_wr_en,
        data_in => somador_out_pc_in,
        data_out => pc_data_out_somador_in
    );

    somador1_inst: somador1_7bits
     port map(
        data_in => pc_data_out_somador_in,
        data_out => somador_out_pc_in
    );

    rom_inst: rom
     port map(
        clk => clk,
        endereco => pc_data_out_somador_in,
        dado => data_out_rom
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
