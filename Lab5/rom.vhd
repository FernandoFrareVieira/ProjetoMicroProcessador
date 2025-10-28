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

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        -- Carrega R3 (o registrador 3) com o valor 5
        0      => B"0000101_000_011_01_001", -- LD R3, 5
        
        -- Carrega R4 com 8
        1      => B"0001000_000_100_01_001", -- LD R4, 8

        -- Soma R3 com R4 e guarda em R5 
        2      => B"0000000_00_011_0_00_010", -- MOV A, R3
        3      => B"0000000_00_100_0_00_011", -- ADD A, R4  
        4      => B"0000000_00_101_0_01_010", -- MOV R5, A  

        -- Subtrai 1 de R5
        5      => B"0000001_00000_0_00_001", -- LD A, 1   (A = 1)
        6      => B"0000000_00_101_0_01_011", -- SUB A, R5  (A = R5 - A = R5 - 1)
        7      => B"0000000_00_101_0_01_010", -- MOV R5, A  (R5 = A)

        -- Salta para o endereço 20
        8      => B"000000_0010100_00_111",   -- JUMP 20 (Decimal 20)

        -- Zera R5 (nunca será executada)
        9      => B"0000000_000_101_01_001", -- LD R5, 0 (Nunca executa)
        
        -- No endereço 20, copia R5 para R3 
        20     => B"0000000_00000_1_00_001", -- LD B, 0
        21     => B"0000000_00_101_1_00_011", -- ADD B, R5 (B = 0 + R5)
        22     => B"0000000_00_011_1_01_010", -- MOV R3, B (R3 = B)

        -- Salta para o passo C desta lista
        23     => B"000000_0000010_00_111",   -- JUMP 2

        -- Zera R3 (nunca será executada)
        24     => B"0000000_000_011_01_001", -- LD R3, 0 (Nunca executa)
        
        others => (others=>'0')    
    );
begin
        dado <= conteudo_rom(to_integer(endereco));

end architecture;
