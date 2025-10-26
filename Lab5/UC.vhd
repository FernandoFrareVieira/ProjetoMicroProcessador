library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port (
        instruc : in UNSIGNED(17 downto 0);
        clk   : in std_logic;
        reset : in std_logic;
        --sinais de controle
        pc_wr_en : out std_logic; -- Escreve no PC
        reg_instr_wr_en : out std_logic; -- Registrador de instrução
        jump_en : out std_logic;   -- Comando de Jump que controla o MUX do jump
        banco_wr_en : out std_logic;
        acc_wr_en : out std_logic;
        estado_atual :  out UNSIGNED(1 downto 0);
        instr_ld_rn_const_en : out std_logic; -- LD rn cons
        instr_mov_rn_acc_en : out std_logic; -- MOV rn acc;
        instr_mov_acc_rn_en : out std_logic; -- MOV acc rn;
        instr_ld_acc_const_en : out std_logic; -- LD acc cons
        instr_op_en : out std_logic;
        select_op : out unsigned(1 downto 0);
        const : out unsigned(6 downto 0)     -- Constante em Complemento de 2 Direto da UC
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
    signal instr_op :  STD_LOGIC;
    signal instr_op_soma : STD_LOGIC;
    signal instr_op_sub : STD_LOGIC;
    signal instr_invalida : STD_LOGIC;

    --Sinais de controle de mux
 
    component maq_estados is
        port (
        clk, rst : in std_logic;
        estado   : out unsigned(1 downto 0)
        );
    end component;

begin

    maq_estados_inst: maq_estados
     port map(
        clk => clk,
        rst => reset,
        estado => estado
    );
    --Organizando os sinais
    opcode <= instruc(2 downto 0);
    func <= instruc(4 downto 3);
    const <= instruc(17 downto 11);

    --Indentificando quando quando instrução é feita;

    instr_nop            <= '1' when func = "00" and opcode = "000" else '0';
    instr_jump           <= '1' when func = "00" and opcode = "111" else '0';
    instr_ld_acc_const   <= '1' when func = "00" and opcode = "001" else '0';  -- Ld acc <- const (linha 6)
    instr_ld_rn_const   <= '1' when func = "01" and opcode = "001" else '0';  -- Ld Rn <- const (linha 7, assumindo renomeação para const to acc/Rn)
    instr_mov_acc_rn     <= '1' when func = "00" and opcode = "010" else '0';  -- Mov A <- Rn (linha 8)
    instr_mov_rn_acc     <= '1' when func = "01" and opcode = "010" else '0';  -- Mov Rn <- A (linha 9)
    instr_op             <= '1' when opcode = "011" else '0';
    instr_op_soma        <= '1' when func = "00" and opcode = "011" else '0';  -- Op soma (add), Rn <- A op (linha 10; para Nand/Xor, use tipo(10:9) se precisar estender)
    instr_op_sub         <= '1' when func = "01" and opcode = "011" else '0';  -- Op subtração, Rn <- A op (linha 11)


  -- Instrução inválida: NOT do OR de todas as válidas (lógica correta!)
    instr_invalida <= not(instr_nop or instr_jump or instr_ld_acc_const or instr_ld_rn_const or
                      instr_mov_acc_rn or instr_mov_rn_acc or instr_op_soma or instr_op_sub);

    
    --Controle de gravação do PC
   pc_wr_en <= '1' when ((instr_jump = '1' and estado = "11") or 
                          (estado = "00" )) else '0';
    --Controle do registrador de instrução    
    reg_instr_wr_en <= '1' when estado = "00" else '0';

    --Controle do jump;
    jump_en <= instr_jump;

    --Mux do banco
     instr_ld_rn_const_en <= instr_ld_rn_const;
     instr_mov_rn_acc_en  <= instr_mov_rn_acc;

     --Mux dos Acumuladores
    instr_ld_acc_const_en <= instr_ld_acc_const;
    instr_op_en <= instr_op;
    instr_mov_acc_rn_en <= instr_mov_acc_rn;


    --ESTADOS para ENABLE
    banco_wr_en <= '1' when (instr_ld_rn_const = '1' or instr_mov_rn_acc ='1') and (estado = "10") else '0';
    acc_wr_en <= '1' when (instr_ld_acc_const ='1' or instr_mov_acc_rn = '1' or instr_op = '1') and (estado = "10") else '0';
    
    --Seleção de operação na ULA

    select_op <= "00" when instr_op_soma = '1' else "01" when instr_op_sub = '1' else "00";

    --Controle de Estado
    estado_atual <= estado;

end architecture;