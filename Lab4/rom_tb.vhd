library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    constant period_time : time := 100 ns;  -- Período do clock (100 ns, como no PDF)
    signal finished : std_logic := '0';
    signal clk      : std_logic := '0';
    signal endereco : unsigned(6 downto 0);
    signal dado     : unsigned(17 downto 0);
    
    constant clk_period : time := 10 ns;
    
    component rom is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned( 17 downto 0)  
        );
    end component;
begin
    uut: rom
        port map (
            clk      => clk,
            endereco => endereco,
            dado     => dado
        );
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
    endereco <= to_unsigned(0, 7);
    wait for 100 ns;
    endereco <= to_unsigned(1, 7);
    wait for 100 ns;
    endereco <= to_unsigned(2, 7);
    wait for 100 ns;
    endereco <= to_unsigned(3, 7);
    wait for 100 ns;
    endereco <= to_unsigned(4, 7);
    wait for 100 ns;
    endereco <= to_unsigned(5, 7);
    wait for 100 ns;
    endereco <= to_unsigned(6, 7);
    wait for 100 ns;
    endereco <= to_unsigned(7, 7);
    wait for 100 ns;
    endereco <= to_unsigned(8, 7);
    wait for 100 ns;
    endereco <= to_unsigned(9, 7);
    wait for 100 ns;
    endereco <= to_unsigned(10, 7);
    wait for 100 ns;
    endereco <= to_unsigned(11, 7);
    wait for 100 ns;
    endereco <= to_unsigned(12, 7);
    wait for 100 ns;
    endereco <= to_unsigned(13, 7);
    wait for 100 ns;
    endereco <= to_unsigned(14, 7);
    wait for 100 ns;
    endereco <= to_unsigned(15, 7);
    wait;
    end process;
        
end architecture;
        
