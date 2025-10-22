library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;



entity UC is

    port (

        clk     : in  std_logic;

        reset   : in  std_logic;

        instruc : in  UNSIGNED(17 downto 0);

       

        pc_wr_en    : out std_logic; -- Habilita a escrita no PC

        pc_mux_sel  : out std_logic; -- '0' = seleciona PC+1, '1' = seleciona Endereço de JUMP

        

        -- Sinal de controle para o Registrador de Instrução

        ir_wr_en    : out std_logic;

        

        -- Sinais de controle para o Banco de Registradores e Acumulador (ACC)

        regbank_wr_en : out std_logic; -- Habilita escrita no Banco

        acc_wr_en     : out std_logic; -- Habilita escrita no Acumulador 

        

        -- Seletores de registradores 

        r_wr_banco_sel  : out unsigned(2 downto 0); -- Seleciona qual Registrador escrever

        r_rd_banco_sel  : out unsigned(2 downto 0); -- Seleciona qual Registrador ler

        

        -- Sinais para a ULA

        ula_sel_op_out  : out unsigned(1 downto 0); -- Seleciona a operação da ULA

        

        -- Saída da constante (do IR)

        const_out       : out unsigned(6 downto 0)  -- Constante 7 bits

    );

end entity;



architecture a_UC of UC is



    -- Componente da Máquina de Estados (4 estados)

    component maq_estado is

        port (

            clk   : in  std_logic;

            reset : in  std_logic;

            estado: out unsigned(1 downto 0)

        );

    end component;



    -- Sinais internos

    signal estado : unsigned(1 downto 0); -- 00, 01, 10, 11

    signal opcode : unsigned(2 downto 0);

    signal func   : unsigned(1 downto 0);

    

    -- Sinais de decodificação (para facilitar a leitura)

    signal eh_jump          : std_logic;

    signal eh_ld_acc_const  : std_logic;

    signal eh_ld_rn_const   : std_logic;

    signal eh_mov_a_rn      : std_logic;

    signal eh_mov_rn_a      : std_logic;

    signal eh_op_tipo       : std_logic;

    signal eh_escrita_reg   : std_logic; -- Sinal auxiliar

    signal eh_escrita_acc   : std_logic; -- Sinal auxiliar



begin



   

    maq_estados_inst: maq_estado

     port map(

        clk => clk,

        reset => reset,

        estado => estado

    );

    

    --    Lê a instrução que está armazenada no IR

    opcode <= instruc(2 downto 0);

    func   <= instruc(4 downto 3);

    

    -- Identifica o tipo de instrução 

    eh_jump         <= '1' when (opcode = "111" and func = "00") else '0';

    eh_ld_acc_const <= '1' when (opcode = "001" and func = "00") else '0';

    eh_ld_rn_const  <= '1' when (opcode = "001" and func = "01") else '0';

    eh_mov_a_rn     <= '1' when (opcode = "010" and func = "00") else '0';

    eh_mov_rn_a     <= '1' when (opcode = "010" and func = "01") else '0';

    eh_op_tipo      <= '1' when (opcode = "011") else '0';



    eh_escrita_reg <= '1' when (eh_ld_rn_const = '1' or eh_mov_rn_a = '1' or eh_op_tipo = '1') else '0';

    eh_escrita_acc <= '1' when (eh_ld_acc_const = '1' or eh_mov_a_rn = '1') else '0';



    

    ir_wr_en <= '1' when estado = "00" else '0';



    -- Controle do MUX de entrada do PC

    -- '0' = seleciona PC+1, '1' = seleciona Endereço de JUMP (do IR)

    pc_mux_sel <= '1' when (estado = "11" and eh_jump = '1') else '0';



    -- Controle do Write Enable do PC

    -- Escrito no estado "00" (para carregar PC+1)

    -- OU no estado "11" se for JUMP (para carregar o novo endereço)

    pc_wr_en <= '1' when (estado = "00") or

                         (estado = "11" and eh_jump = '1')

                else '0';

    

    -- Controle de Escrita do Banco de Registradores

 

    regbank_wr_en <= '1' when (estado = "11" and eh_escrita_reg = '1') else '0';

    

    -- Controle de Escrita do Acumulador

   

    acc_wr_en <= '1' when (estado = "11" and eh_escrita_acc = '1') else '0';



    -- Saída da constante de 7 bits

    const_out <= instruc(17 downto 11);

    

    -- Seletor de qual registrador escrever 

    r_wr_banco_sel <= instruc(10 downto 8);

    

    r_rd_banco_sel <= instruc(8 downto 6);

    

    ula_sel_op_out <= func when eh_op_tipo = '1' else "00"; 



end architecture;