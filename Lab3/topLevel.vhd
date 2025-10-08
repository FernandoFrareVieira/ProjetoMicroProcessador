library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevel is
    port(
        clk : in std_logic;
        reset : in std_logic;
        constante : in unsigned(15 downto 0);
        wr_en_banco : in std_logic;
        wr_en_acumuladores : in std_logic;
        sel_acc: in std_logic;
        ld_or_mov_acc_rn : in std_logic; -- '0': acc ← Rn ou const (LD/MOV A,Rn); '1': Rn ← acc (MOV Rn,A)
        ld_or_mov_acc : in UNSIGNED(1 downto 0); -- 00=LD acc,const; 01=ULA pro acc; 10=MOV acc,Rn
        r_wr_banco : in unsigned(2 downto 0);
        r_rd_banco : in unsigned(2 downto 0);
        sel_op : in unsigned(1 downto 0);
        saida_ula: out unsigned(15 downto 0);
        carry : out std_logic;
        overflow : out std_logic
    );
end entity;

architecture a_topLevel of topLevel is
    component bancoreg is
        port (
            clk   : in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            data_wr : in unsigned(15  downto 0);
            reg_wr : in unsigned(2 downto 0);
            reg_r1: in unsigned(2 downto 0);
            data_out : out unsigned(15 downto 0)
        
        );
    end component;

    component acumuladores is
         port (
            clk   : in std_logic;
            wr_en : in std_logic;
            reset : in std_logic;
            data_wr : in unsigned(15 downto 0);
            sel_acc: in std_logic;
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component ULA is
        port(
            A,B : in unsigned(15 downto 0);
            sel_op : in unsigned(1 downto 0);
            saida : out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;

    signal banco_out_ula_in : unsigned(15 downto 0);
    signal acc_out_ula_in : unsigned(15 downto 0);
    signal ula_out : unsigned(15 downto 0);
    signal banco_in : unsigned(15 downto 0);
    signal acc_in : unsigned(15 downto 0);

    begin
        bancoreg_inst : bancoreg port map (
            clk => clk,
            wr_en => wr_en_banco,
            reset => reset,
            data_wr => banco_in,
            reg_wr => r_wr_banco,
            reg_r1 => r_rd_banco,
            data_out => banco_out_ula_in
        );

        acumuladores_inst : acumuladores port map(
            clk => clk,
            wr_en => wr_en_acumuladores,
            reset => reset,
            data_wr => acc_in,
            sel_acc => sel_acc,
            data_out => acc_out_ula_in
        );

        ULA_inst : ULA port map(
            A => banco_out_ula_in,
            B => acc_out_ula_in,
            sel_op => sel_op,
            saida => ula_out,
            carry => carry,
            overflow => overflow
        );

        -- Define a entrada do banco de registradores: se ld_or_mov_acc_rn = '0', carrega constante; senão, MOV Rn, Acc
        banco_in <= constante when ld_or_mov_acc_rn = '0' else acc_out_ula_in;
        -- Define a entrada dos acumuladores: "00"=LD acc,const; "01"=resultado da ULA; "10"=MOV acc,Rn; senão, zeros
        acc_in <= constante when ld_or_mov_acc = "00" else
                           ula_out when ld_or_mov_acc = "01" else
                           banco_out_ula_in when ld_or_mov_acc = "10" else
                           (others => '0');                    
        -- Saída da ULA é passada diretamente para a saída do módulo
        saida_ula <= ula_out;
end architecture;