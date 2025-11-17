library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port (
        instruc : in UNSIGNED(17 downto 0);
        clk   : in std_logic;
        reset : in std_logic;
        carry_in : in std_logic;
        overflow_in : in std_logic;
        zero_in : in std_logic;
        negative_in : in std_logic;

        --sinais de controle
        pc_wr_en : out std_logic; -- Escreve no PC
        reg_instr_wr_en : out std_logic; -- Registrador de instrução
        jump_en : out std_logic;   -- Comando de Jump que controla o MUX do jump
        banco_wr_en : out std_logic;
        ram_wr_en : out std_logic;
        acc_wr_en : out std_logic;
        estado_atual :  out UNSIGNED(1 downto 0);
        instr_ld_rn_const_en : out std_logic; -- LD rn cons
        instr_mov_rn_acc_en : out std_logic; -- MOV rn acc;
        instr_mov_acc_rn_en : out std_logic; -- MOV acc rn;
        instr_ld_acc_const_en : out std_logic; -- LD acc cons
        instr_ula_en : out std_logic;
        instr_b_en : out std_logic;
        instr_cmpi_en : out std_logic;
        instr_lw_en : out std_logic;
        instr_sw_en : out std_logic;
        select_ula_op : out unsigned(1 downto 0);
        const : out unsigned(7 downto 0)     -- Constante em Complemento de 2 Direto da UC
    );
end entity;

architecture a_UC of UC is

    signal estado : unsigned(1 downto 0); -- Estados da máquina de estado
    signal opcode : unsigned(2 downto 0); --opcode
    signal func   : unsigned(1 downto 0); --func

    --Sinais que indiciam que foi executado uma uma intrução especifica

    signal instr_nop : STD_LOGIC;
    signal instr_jump: STD_LOGIC;
    signal instr_ld_acc_const : STD_LOGIC;
    signal instr_ld_rn_const  : STD_LOGIC;
    signal instr_mov_acc_rn : STD_LOGIC;
    signal instr_mov_rn_acc : STD_LOGIC;
    signal instr_ula :  STD_LOGIC;
    signal instr_ula_soma : STD_LOGIC;
    signal instr_ula_sub : STD_LOGIC;
    signal instr_ula_nand : STD_LOGIC;
    signal instr_ula_xor : STD_LOGIC;
    signal instr_cmpi : STD_LOGIC;
    signal instr_bvc : STD_LOGIC;
    signal instr_bhi : STD_LOGIC;
    signal instr_branch: STD_LOGIC;
    signal instr_lw: std_logic;
    signal instr_sw: std_logic;
    signal instr_cnje : std_logic;
    signal instr_invalida : STD_LOGIC;

    --Sinais de controle das flags
    signal wr_en_carry : std_logic;
    signal wr_en_overflow : std_logic;
    signal wr_en_zero : std_logic;
    signal wr_en_negative : std_logic; 
    signal carry : std_logic;
    signal overflow : std_logic;
    signal zero : std_logic;
    signal negative : std_logic;

    --Sinais de detecçao de branch

    signal bvc_en : std_logic;
    signal bhi_en : std_logic;
    signal cnje_en : std_logic;
    
 
    component maq_estados is
        port (
        clk, rst : in std_logic;
        estado   : out unsigned(1 downto 0)
        );
    end component;
  
    component reg01bit is
    port(
        clk,wr_en,reset: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic
    );
    end component;
begin

    maq_estados_inst: maq_estados
     port map(
        clk => clk,
        rst => reset,
        estado => estado
    );

    reg01bit_inst_carry: reg01bit
    port map (
        clk => clk,
        reset => reset,
        wr_en => wr_en_carry,
        data_in => carry_in,
        data_out => carry
    );
    reg01bit_inst_overflow: reg01bit
    port map (
        clk => clk,
        reset => reset,
        wr_en => wr_en_overflow,
        data_in => overflow_in,
        data_out => overflow
    );
    reg01bit_inst_zero: reg01bit
    port map (
        clk => clk,
        reset => reset,
        wr_en => wr_en_zero,
        data_in => zero_in,
        data_out => zero
    );

    reg01bit_inst_negative: reg01bit
    port map (
        clk => clk,
        reset => reset,
        wr_en => wr_en_negative,
        data_in => negative_in,
        data_out => negative
    );

    

    --Organizando os sinais
    opcode <= instruc(2 downto 0);
    func <= instruc(4 downto 3);
    const <= instruc(17 downto 10);

    --Indentificando quando quando instrução é feita;

    instr_nop          <= '1' when func = "00" and opcode = "000" else '0';
    instr_jump         <= '1' when func = "00" and opcode = "111" else '0'; -- Salto absoluto
    instr_bvc          <= '1' when func = "00" and opcode = "101" else '0'; -- Salto relativo
    instr_bhi          <= '1' when func = "01" and opcode = "101" else '0'; -- Salto relativo    
    instr_cmpi         <= '1' when func = "01" and opcode = "100" else '0'; -- Acc - conts
    instr_ld_acc_const <= '1' when func = "00" and opcode = "001" else '0'; -- Ld acc <- const 
    instr_ld_rn_const  <= '1' when func = "01" and opcode = "001" else '0'; -- Ld Rn <- const 
    instr_mov_acc_rn   <= '1' when func = "00" and opcode = "010" else '0'; -- Mov A <- Rn 
    instr_mov_rn_acc   <= '1' when func = "01" and opcode = "010" else '0'; -- Mov Rn <- A 
    instr_ula          <= '1' when opcode = "011" else '0'; -- instrução que ativa operações da ULA
    instr_ula_soma     <= '1' when func = "00" and opcode = "011" else '0'; -- Op soma (add)
    instr_ula_sub      <= '1' when func = "01" and opcode = "011" else '0'; -- Op subtração
    instr_ula_nand     <= '1' when func = "10" and opcode = "011" else '0'; -- Op nand
    instr_ula_xor      <= '1' when func = "11" and opcode = "011" else '0'; -- Op xor
    instr_lw           <= '1' when func = "10" and opcode = "001" else '0'; -- lw Acc <- dado[Rn]
    instr_sw           <= '1' when func = "11" and opcode = "001" else '0'; -- sw [Rn] <- Acc 
    instr_cnje         <= '1' when func = "10" and opcode = "101" else '0'; -- cnje Acc - Rn


  -- Instrução inválida: NOT do OR de todas as válidas
    instr_invalida <= not(instr_nop or instr_jump or instr_bvc or instr_bhi or 
                      instr_ld_acc_const or instr_ld_rn_const or
                      instr_mov_acc_rn or instr_mov_rn_acc or 
                      instr_ula_soma or instr_ula_sub or instr_ula_nand or instr_ula_xor or
                      instr_cmpi or instr_lw or instr_sw or instr_cnje);

    --Instrução se for branch
    instr_branch <= '1' when bhi_en = '1' or bvc_en = '1' or cnje_en  = '1'  else '0';

    --Controle de gravação do PC
    pc_wr_en <= '1' when ((instr_jump = '1' and estado = "11") or 
                          (instr_branch = '1' and estado = "11") or 
                          (estado = "00")) else '0';

    --Controle do registrador de instrução    
    reg_instr_wr_en <= '1' when estado = "00" else '0';

    --Controle de instrução jump;
    jump_en <= instr_jump; 

    --Controle de instrução CMPI
    instr_cmpi_en <= instr_cmpi;

    --Condição de branch
    bvc_en <= '1' when overflow = '0' and instr_bvc = '1' else '0';
    bhi_en <= '1' when carry = '1' and zero = '0' and instr_bhi = '1' else '0';
    cnje_en <= '1' when zero = '0' and instr_cnje = '1' else '0';

    --Controle de instrução Branch
    instr_b_en <= instr_branch;

    --Controle da atualização de flags
    wr_en_carry    <= '1' when (instr_cmpi = '1' or instr_ula = '1' or instr_cnje ='1') and estado = "10" else '0';
    wr_en_overflow <= '1' when (instr_cmpi = '1' or instr_ula = '1' or instr_cnje ='1') and estado = "10" else '0';
    wr_en_zero     <= '1' when (instr_cmpi = '1' or instr_ula = '1' or instr_cnje ='1') and estado = "10" else '0';
    wr_en_negative <= '1' when (instr_cmpi = '1' or instr_ula = '1' or instr_cnje ='1') and estado = "10" else '0';

    --Mux do banco
    instr_ld_rn_const_en  <= instr_ld_rn_const;
    instr_mov_rn_acc_en   <= instr_mov_rn_acc;

    --Mux dos Acumuladores
    instr_ld_acc_const_en <= instr_ld_acc_const;
    instr_ula_en          <= instr_ula;
    instr_mov_acc_rn_en   <= instr_mov_acc_rn;
    instr_lw_en           <= instr_lw;

    --ESTADOS para ENABLE
    banco_wr_en <= '1' when (instr_ld_rn_const = '1' or instr_mov_rn_acc = '1') and 
                            (estado = "10") else '0';

    acc_wr_en <= '1' when (instr_ld_acc_const = '1' or instr_mov_acc_rn = '1' or 
                           instr_ula = '1' or instr_lw = '1') and 
                          (estado = "10") else '0';

    ram_wr_en <= '1' when instr_sw = '1' and estado = "10" else '0';
    
    --Seleção de operação na ULA
    select_ula_op <= "00" when instr_ula_soma = '1' else
                     "01" when instr_ula_sub = '1' or instr_cmpi = '1' or instr_cnje = '1' else
                     "10" when instr_ula_nand = '1' else
                     "11" when instr_ula_xor = '1' else
                     "00";

    --Controle de Estado
    estado_atual <= estado;
end architecture;