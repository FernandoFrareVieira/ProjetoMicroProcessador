library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity topLevel is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        pc_write_en : out std_logic;
        jump_enable : out std_logic;
        saida_pc        : out unsigned(6 downto 0);
        saida_instrucao : out unsigned(17 downto 0)
    );
end entity;

architecture a_topLevel of TopLevel is

    signal pc_wr_en: STD_LOGIC;
    signal jump_en : std_logic;
    signal pc_data_in: unsigned(6 downto 0);
    signal pc_data_out_somador_in : unsigned (6 downto 0);
    signal somador_out_pc_in : unsigned (6 downto 0);
    signal instuct : unsigned (17 downto 0);

    component PC is
        port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
        );
    end component;

    component UC is
        port (
        instruc : in UNSIGNED(17 downto 0);
        clk   : in std_logic;
        reset : in std_logic;
        --sinais de controle
        pc_wr_en : out std_logic; -- Escreve no PC
        jump_en : out std_logic   -- Comando de Jump
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

begin

    UC_inst: UC
     port map(
        instruc => instuct,
        clk => clk,
        reset => reset,
        pc_wr_en => pc_wr_en,
        jump_en => jump_en
    );

    PC_inst: PC
     port map(
        clk => clk,
        reset => reset,
        wr_en => pc_wr_en,
        data_in => pc_data_in,
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
        dado => instuct
    );

    pc_data_in <= somador_out_pc_in when jump_en = '0' else instuct(12 downto 6);

    saida_pc <= pc_data_out_somador_in;
    saida_instrucao <= instuct;

    pc_write_en <= pc_wr_en;
    jump_enable <= jump_en;

end architecture;