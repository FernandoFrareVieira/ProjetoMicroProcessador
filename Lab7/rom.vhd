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
        0 => B"0000101_000_000_01_001", -- LD R0, 5        (R0 = ponteiro para end 5)
        1 => B"0010111_00000_0_00_001", -- LD ACC, 23      (ACC = dado 23) (Valor corrigido)
        2 => B"0000000_00_000_0_11_001", -- SW [R0], ACC    (RAM[5] <- 23)
        
        -- Escreve 42 no endereço 30 (usando R1)
        3 => B"0011110_000_001_01_001", -- LD R1, 30       (R1 = ponteiro para end 30)
        4 => B"0101010_00000_0_00_001", -- LD ACC, 42      (ACC = dado 42) (Este estava correto)
        5 => B"0000000_00_001_0_11_001", -- SW [R1], ACC    (RAM[30] <- 42)
        
        -- Escreve 19 no endereço 10 (usando R2)
        6 => B"0001010_000_010_01_001", -- LD R2, 10       (R2 = ponteiro para end 10)
        7 => B"0010011_00000_0_00_001", -- LD ACC, 19      (ACC = dado 19) (Valor corrigido)
        8 => B"0000000_00_010_0_11_001", -- SW [R2], ACC    (RAM[10] <- 19)
        
        9  => B"000000000000000000",     -- NOP
        10 => B"000000000000000000",     -- NOP
        
        -- Lê de RAM[30] (espera 42) e guarda em R3
        11 => B"0000000_00_001_0_10_001", -- LW ACC, [R1]    (ACC <- RAM[30], deve ser 42)
        12 => B"0000000_00_011_0_01_010", -- MOV R3, ACC     (R3 <- 42)
        
        -- Lê de RAM[10] (espera 19) e guarda em R4
        13 => B"0000000_00_010_0_10_001", -- LW ACC, [R2]    (ACC <- RAM[10], deve ser 19)
        14 => B"0000000_00_100_0_01_010", -- MOV R4, ACC     (R4 <- 19)
        
        -- Lê de RAM[5] (espera 23) e guarda em R5
        15 => B"0000000_00_000_0_10_001", -- LW ACC, [R0]    (ACC <- RAM[5], deve ser 23)
        16 => B"0000000_00_101_0_01_010", -- MOV R5, ACC     (R5 <- 2
        
        others => B"000000000000000000"  
    );
begin
        dado <= conteudo_rom(to_integer(endereco));
end architecture;