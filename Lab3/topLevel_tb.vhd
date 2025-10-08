library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevel_tb is
end entity;

architecture a_topLevel_tb of topLevel_tb is
    component topLevel is
        port(
            clk : in std_logic;
            reset : in std_logic;
            constante : in unsigned(15 downto 0);
            wr_en_banco : in std_logic;
            wr_en_acumuladores : in std_logic;
            sel_acc: in std_logic;
            ld_or_mov_acc_rn : in std_logic;
            ld_or_mov_acc : in UNSIGNED(1 downto 0);
            r_wr_banco : in unsigned(2 downto 0);
            r_rd_banco : in unsigned(2 downto 0);
            sel_op : in unsigned(1 downto 0);
            saida_ula: out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal clk, reset : std_logic;
    signal constante : unsigned(15 downto 0);
    signal wr_en_banco, wr_en_acumuladores, sel_acc, ld_or_mov_acc_rn : std_logic;
    signal ld_or_mov_acc : unsigned(1 downto 0);
    signal r_wr_banco, r_rd_banco : unsigned(2 downto 0);
    signal sel_op : unsigned(1 downto 0);
    signal saida_ula : unsigned(15 downto 0);
    signal carry, overflow : std_logic;

begin

    uut: topLevel port map(
        clk => clk,
        reset => reset,
        constante => constante,
        wr_en_banco => wr_en_banco,
        wr_en_acumuladores => wr_en_acumuladores,
        sel_acc => sel_acc,
        ld_or_mov_acc_rn => ld_or_mov_acc_rn,
        ld_or_mov_acc => ld_or_mov_acc,
        r_wr_banco => r_wr_banco,
        r_rd_banco => r_rd_banco,
        sel_op => sel_op,
        saida_ula => saida_ula,
        carry => carry,
        overflow => overflow
    );

    reset_global: process
    begin
        reset <= '1';
        wait for 200 ns; 
        reset <= '0';
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
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;


    process
    begin
        wait for 200 ns;

        -- LD R2, 1234
        ld_or_mov_acc_rn <= '0';
        constante <= to_unsigned(1234, 16);
        r_wr_banco <= "010";
        wr_en_banco <= '1';
        wr_en_acumuladores <= '0';
        sel_acc <= '0';
        r_rd_banco <= "000";
        sel_op <= "00";
        ld_or_mov_acc <= "00";
        wait for 100 ns;
        wr_en_banco <= '0';
        constante <= (others => '0');
        wait for 200 ns;


        -- ADD A, R2 
        r_rd_banco <= "010";
        sel_acc <= '0';
        sel_op <= "00";
        wr_en_acumuladores <= '1';
        ld_or_mov_acc_rn <= '0';
        wr_en_banco <= '0';
        ld_or_mov_acc <= "01";
        wait for 100 ns;
        wr_en_acumuladores <= '0';
        wait for 200 ns; 


        -- MOV R3, A 
        
        ld_or_mov_acc_rn <= '1';
        sel_acc <= '0';
        r_wr_banco <= "011";
        wr_en_banco <= '1';
        wr_en_acumuladores <= '0';
        ld_or_mov_acc <= "00";

        wait for 100 ns;

        wr_en_banco <= '0';
        wait for 100 ns;

        r_rd_banco <= "011";

        wait for 200 ns;

        -- LD A, 5678
        ld_or_mov_acc_rn <= '0';
        constante <= to_unsigned(5678, 16);
        sel_acc <= '0';
        wr_en_acumuladores <= '1';
        wr_en_banco <= '0';
        r_rd_banco <= "000";
        sel_op <= "00";
        ld_or_mov_acc <= "00";
        wait for 100 ns;
        wr_en_acumuladores <= '0';
        constante <= (others => '0');
        wait for 200 ns;

        -- MOV B, R2
        r_rd_banco <= "010";
        sel_acc <= '1';
        ld_or_mov_acc_rn <= '0';
        wr_en_acumuladores <= '1';
        wr_en_banco <= '0';
        sel_op <= "00";
        ld_or_mov_acc <= "10";
        wait for 100 ns;
        wr_en_acumuladores <= '0';
        wait for 200 ns;

        -- SUB B, R3 
        r_rd_banco <= "010";
        sel_acc <= '1';
        sel_op <= "01";
        wr_en_acumuladores <= '1';
        ld_or_mov_acc_rn <= '0';
        wr_en_banco <= '0';
        ld_or_mov_acc <= "01";
        wait for 100 ns;
        wr_en_acumuladores <= '0';
        wait for 200 ns; 

        wait; 
    end process;

end architecture;