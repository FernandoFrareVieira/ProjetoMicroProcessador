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
        jump_en : out std_logic;   -- Comando de Jump
        const : out unsigned(6 downto 0)     -- Constante em Complemento de 2 Direto da UC
    );
end entity;

architecture a_UC of UC is

    signal estado : unsigned(1 downto 0); -- Estados da máquina de estado
    signal opcode : unsigned(3 downto 0); --opcode
    signal func   : unsigned(1 downto 0); --func

    component maq_estados is
        port (
        clk, rst : in std_logic;
        estado   : out unsigned(1 downto 0)
        );
    end component;

begin

    maq_estados_inst: maq_estado
     port map(
        clk => clk,
        reset => reset,
        estado => estado
    );
    --Organizando os sinais
    opcode <= instruc(2 downto 0);
    func <= instruc(4 downto 3);
    const <= insturc(17 downto 11);

    
    --FETCH 1
    pc_wr_en <= '0' when estado = "00" else '1';
    --FETCH 2
    jump_en <= '1'  when (opcode = "1111" and func = "001" and estado = '1') else '0';
    --DECODE

    --EXECUTE
    

end architecture;