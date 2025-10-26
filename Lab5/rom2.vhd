library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom2 is
    port (
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned( 17 downto 0)  
    );
end entity;
--Esse programa simples apenas pula para frente, simulando um condicional, e depois tem um pulo para tras, simulando um loop.  
--Contandos os Clocks pelo arquivo ghw, vemos que o programa precisa de 10 clocks para completar to\do seu funcionamento, sendo elas as instruções nas posições: 0,1,4,5,6. 
--Isso acontece principalmente porque temos um estado para pegar a instrução(FETCH), e outro executa-la, isso adiciona um ciclo de 2 clocks para cada instrução.
architecture a_rom2 of rom2 is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        0      => B"0000101_000_011_01_001", -- LD R3 5
        1      => B"0001000_000_100_01_001", -- LD R4 8
        2      => B"000000_0000000_00_000", -- NOP
        3      => B"0000000_00_011_0_00_011", -- ADD A R3
        4      => B"0000000_00_100_0_00_011", -- ADD A R4
        5      => B"0000000_00_101_0_01_010", -- MOV R5 A
        6      => B"0000001_00000_0_00_001", -- LD A 1
        7      => B"0000000_00_101_0_01_011", -- SUB A <- R5-A 
        8      => B"0000000_00_101_0_01_010", -- MOV R5 A
        9      => B"0000000_00000_0_00_001", -- LD A 0
        10     => B"000000_0010100_00_111",   -- JUMP 20
        11     => B"0000000_000_101_01_001", -- LD R5 0 Nunca sera executada
        12     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        13     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        14     => B"0000000000000_00_000", -- NOP (Deve ser pulado)
        20     => B"0000000_00000_1_00_001", -- LD B 0
        21     => B"0000000_00_101_1_00_011", -- ADD B R5
        22     => B"0000000_00_011_1_01_010", -- MOV R3 B
        23     => B"000000_0000011_00_111",   -- JUMP 3
        24     => B"0000000_000_011_01_001", -- LD R3 0 Nunca sera executada 
        others => (others=>'0')
    );
begin
        dado <= conteudo_rom(to_integer(endereco));

end architecture;
