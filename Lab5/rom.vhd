library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned( 17 downto 0)  
    );
end entity;
--Esse programa simples apenas pula para frente, simulando um condicional, e depois tem um pulo para tras, simulando um loop.  
--Contandos os Clocks pelo arquivo ghw, vemos que o programa precisa de 10 clocks para completar to\do seu funcionamento, sendo elas as instruções nas posições: 0,1,4,5,6. 
--Isso acontece principalmente porque temos um estado para pegar a instrução(FETCH), e outro executa-la, isso adiciona um ciclo de 2 clocks para cada instrução.
architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        0      => B"0000000000000_00_000", -- NOP
        1      => B"000000_0000100_00_111", -- JUMP 4 (Salto para frente)
        2      => B"000000_0000000_00_111", -- JUMP 0 (Deve ser pulado)
        3      => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        4      => B"0000011_000_000_01_001", -- LD R0 3
        5      => B"0000000_00_000_0_00_011", -- ADD A R0
        6      => B"000000_0000100_00_111", -- JUMP 4 (Salto para trás, cria o loop)
        7      => B"000000_0000000_00_111", -- JUMP 0 (Nunca deve ser alcançado)
        9      => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        10     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        11     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        12     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        13     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        14     => B"0000000000000_00_000", -- NOP (Deve ser pulado)

        B"000000_0000100_00_111"
        others => (others=>'0')
    );
begin
        dado <= conteudo_rom(to_integer(endereco));

end architecture;
