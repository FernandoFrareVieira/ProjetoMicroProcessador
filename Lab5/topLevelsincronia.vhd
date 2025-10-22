library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity topLevelsincronia is
    port(
        clk   : in std_logic;
        reset : in std_logic
    );
end entity;

architecture a_topLevelsincronia of topLevelsincronia is

    -- Componente: Program Counter
    component PC is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    -- Componente: ROM
    component rom is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out unsigned(17 downto 0)
        );
    end component;

    -- Componente: Registrador de Instrução
    component registrador_instr is
        port (
            clk      : in std_logic;
            wr_en    : in std_logic;
            reset    : in std_logic;
            data_in  : in unsigned(17 downto 0);
            data_out : out unsigned(17 downto 0)
        );
    end component;

    -- Componente: Unidade de Controle
    component UC is
        port (
            instruc  : in unsigned(17 downto 0);
            clk      : in std_logic;
            reset    : in std_logic;
            pc_wr_en : out std_logic;
            reg_instr_wr_en : out std_logic;
            jump_en  : out std_logic;
            const    : out unsigned(6 downto 0)
        );
    end component;

    -- Componente: Banco de Registradores
    component bancoreg is
        port (
            clk      : in std_logic;
            wr_en    : in std_logic;
            reset    : in std_logic;
            data_wr  : in unsigned(15 downto 0);
            reg_wr   : in unsigned(2 downto 0);
            reg_r1   : in unsigned(2 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Componente: ULA
    component ULA is
        port(
            A        : in unsigned(15 downto 0);
            B        : in unsigned(15 downto 0);
            sel_op   : in unsigned(1 downto 0);
            saida    : out unsigned(15 downto 0);
            carry    : out std_logic;
            overflow : out std_logic
        );
    end component;

    -- Componente: Acumuladores
    component acumuladores is
        port (
            clk      : in std_logic;
            wr_en    : in std_logic;
            reset    : in std_logic;
            data_wr  : in unsigned(15 downto 0);
            sel_acc  : in std_logic;
            data_out : out unsigned(15 downto 0)
        );
    end component;

    -- Componente: Extensor de Sinal 7->16 bits
    component ext_sinal7p16 is
        port (
            const     : in unsigned(6 downto 0);
            const_ext : out unsigned(15 downto 0)
        );
    end component;

    -- Componente: Somador 1 para 7 bits
    component somador1_7bits is
        port (
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    -- Sinais internos
    signal pc_out         : unsigned(6 downto 0);
    signal pc_in          : unsigned(6 downto 0);
    signal pc_wr_en       : std_logic;
    
    
    signal rom_data       : unsigned(17 downto 0);
    
    --registrador de instrução
    signal instr_reg_out  : unsigned(17 downto 0);
    
    signal uc_jump_en     : std_logic;
    signal uc_const       : unsigned(6 downto 0);
    signal uc_reg_instr_wr_en : std_logic;
    
    signal bancreg_data   : unsigned(15 downto 0);
    signal bancreg_wr_en  : std_logic;
    signal bancreg_reg_wr : unsigned(2 downto 0);
    signal bancreg_reg_r1 : unsigned(2 downto 0);
    signal bancreg_out    : unsigned(15 downto 0);
    
    signal ula_a          : unsigned(15 downto 0);
    signal ula_b          : unsigned(15 downto 0);
    signal ula_sel        : unsigned(1 downto 0);
    signal ula_out        : unsigned(15 downto 0);
    signal ula_carry      : std_logic;
    signal ula_overflow   : std_logic;
    
    signal acc_wr_en      : std_logic;
    signal acc_sel        : std_logic;
    signal acc_data_wr    : unsigned(15 downto 0);
    signal acc_out        : unsigned(15 downto 0);
    
    signal const_ext      : unsigned(15 downto 0);
    
    signal soma1_out      : unsigned(6 downto 0);

begin

    -- Instância do Program Counter
    pc_inst: PC
        port map(
            clk      => clk,
            reset    => reset,
            wr_en    => pc_wr_en,
            data_in  => pc_in,
            data_out => pc_out
        );

    -- Instância da ROM
    rom_inst: rom
        port map(
            clk      => clk,
            endereco => pc_out,
            dado     => rom_data
        );

    -- Instância do Registrador de Instrução
    reg_instr_inst: registrador_instr
        port map(
            clk      => clk,
            wr_en    => uc_reg_instr_wr_en,
            reset    => reset,
            data_in  => rom_data,
            data_out => instr_reg_out
        );

    -- Instância da Unidade de Controle
    uc_inst: UC
        port map(
            instruc  => instr_reg_out,
            clk      => clk,
            reset    => reset,
            pc_wr_en => pc_wr_en,
            reg_instr_wr_en => uc_reg_instr_wr_en,
            jump_en  => uc_jump_en,
            const    => uc_const
        );

    -- Instância do Banco de Registradores
    bancoreg_inst: bancoreg
        port map(
            clk      => clk,
            wr_en    => bancreg_wr_en,
            reset    => reset,
            data_wr  => bancreg_data,
            reg_wr   => bancreg_reg_wr,
            reg_r1   => bancreg_reg_r1,
            data_out => bancreg_out
        );

    -- Instância da ULA
    ula_inst: ULA
        port map(
            A        => ula_a,
            B        => ula_b,
            sel_op   => ula_sel,
            saida    => ula_out,
            carry    => ula_carry,
            overflow => ula_overflow
        );

    -- Instância dos Acumuladores
    acumuladores_inst: acumuladores
        port map(
            clk      => clk,
            wr_en    => acc_wr_en,
            reset    => reset,
            data_wr  => acc_data_wr,
            sel_acc  => acc_sel,
            data_out => acc_out
        );

    -- Instância do Extensor de Sinal
    ext_sinal_inst: ext_sinal7p16
        port map(
            const     => uc_const,
            const_ext => const_ext
        );

    -- Instância do Somador 1 para 7 bits
    somador1_7bits_inst: somador1_7bits
        port map(
            data_in  => pc_out,
            data_out => soma1_out
        );
        
    -- TODO: Conectar os sinais internos conforme a arquitetura do processador

    pc_in <= instr_reg_out(11 downto 5) when uc_jump_en = '1' else soma1_out; -- mux que controla se é jump ou pc+1


end architecture;
