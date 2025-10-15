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
        jump_en : out std_logic   -- Comando de Jump

    );
end entity;

architecture a_UC of UC is

    signal estado : std_logic;
    signal opcode : unsigned(3 downto 0);
    signal func   : unsigned(1 downto 0);

    component maq_estado is
        port (
            clk : in std_logic;
            reset : in std_logic;
            estado : out std_logic
        );
    end component;

begin

    maq_estado_inst: maq_estado
     port map(
        clk => clk,
        reset => reset,
        estado => estado
    );
    --Organizando os sinais
    opcode <= instruc(3 downto 0);
    func <= instruc(5 downto 4);    

    pc_wr_en <= '0' when estado = '0' else '1';--FETCH
    jump_en <= '1'  when (opcode = "1111" and func = "00" and estado = '1') else '0';
    

end architecture;