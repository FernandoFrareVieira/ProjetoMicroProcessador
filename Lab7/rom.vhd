library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(17 downto 0)
    );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        -- Ponteiros e Contadores do LOOP DE ESCRITA
        0 => B"0001010_000_000_01_001", -- LD R0, 10   (Ponteiro de Escrita)
        1 => B"0010000_000_001_01_001", -- LD R1, 16   (Gerador de Dados)
        2 => B"0000100_000_010_01_001", -- LD R2, 4    (Contador do Loop de Escrita)
        
        -- Constantes
        3 => B"0000101_000_011_01_001", -- LD R3, 5    (Incremento de Endereço)
        4 => B"0000011_000_100_01_001", -- LD R4, 3    (Incremento de Dado)
        5 => B"1111111_000_101_01_001", -- LD R5, 127  (Decremento '-1')

        -- Ponteiros e Contadores do LOOP DE LEITURA 
        6 => B"0001010_000_110_01_001", -- LD R6, 10   (Ponteiro de Leitura)
        7 => B"0000100_000_111_01_001", -- LD R7, 4    (Contador do Loop de Leitura)

        -- LOOP 1: ESCRITA NA RAM 
        8  => B"0000000_00_001_0_00_010", -- MOV ACC, R1    (Prepara dado)
        9  => B"0000000_00_000_0_11_001", -- SW [R0], ACC   (RAM[R0] <- R1)
        
        -- Atualiza Ponteiro de Escrita (R0 = R0 + 5)
        10 => B"0000000_00_000_0_00_010", -- MOV ACC, R0
        11 => B"0000000_00_011_0_00_011", -- ADD ACC, R3    (ACC = R0 + 5)
        12 => B"0000000_00_000_0_01_010", -- MOV R0, ACC
        
        -- Atualiza Dado (R1 = R1 + 3)
        13 => B"0000000_00_001_0_00_010", -- MOV ACC, R1
        14 => B"0000000_00_100_0_00_011", -- ADD ACC, R4    (ACC = R1 + 3)
        15 => B"0000000_00_001_0_01_010", -- MOV R1, ACC
        
        -- Decrementa Contador de Escrita (R2 = R2 - 1)
        16 => B"0000000_00_010_0_00_010", -- MOV ACC, R2
        17 => B"0000000_00_101_0_00_011", -- ADD ACC, R5    (ACC = R2 - 1)
        18 => B"0000000_00_010_0_01_010", -- MOV R2, ACC
        
        -- Verifica Loop 1 (Pula se ACC > 0)
        19 => B"0000000_00000_0_01_100",  -- CMPI ACC, 0    (Compara R2 com 0)
        -- Alvo = 8. Atual = 20. Delta = 8 - 20 = -12 (1110100)
        20 => B"1110100_00000_0_01_101",  -- BHI -12        (Salta para o endereço 8)

        -- PAUSA (NOPs)
        21 => B"000000000000000000",      -- NOP
        22 => B"000000000000000000",      -- NOP
        23 => B"000000000000000000",      -- NOP

        -- LOOP 2: LEITURA DA RAM 
        -- O R6 e R7 já foram inicializados
        24 => B"0000000_00_110_0_10_001", -- LW ACC, [R6]   (Lê RAM[R6]. Espera-se 16, 19, 22, 25)
        
        -- Atualiza Ponteiro de Leitura (R6 = R6 + 5)
        25 => B"0000000_00_110_0_00_010", -- MOV ACC, R6
        26 => B"0000000_00_011_0_00_011", -- ADD ACC, R3    (ACC = R6 + 5)
        27 => B"0000000_00_110_0_01_010", -- MOV R6, ACC
        
        -- Decrementa Contador de Leitura (R7 = R7 - 1)
        28 => B"0000000_00_111_0_00_010", -- MOV ACC, R7
        29 => B"0000000_00_101_0_00_011", -- ADD ACC, R5    (ACC = R7 - 1)
        30 => B"0000000_00_111_0_01_010", -- MOV R7, ACC
        
        -- Verifica Loop 2 (Pula se ACC > 0)
        31 => B"0000000_00000_0_01_100",  -- CMPI ACC, 0    (Compara R7 com 0)
        -- Alvo = 24. Atual = 32. Delta = 24 - 32 = -8 (1111000)
        32 => B"1111000_00000_0_01_101",  -- BHI -8         (Salta para o endereço 24)

        others => B"000000000000000000"
    );
begin
        dado <= conteudo_rom(to_integer(endereco));
end architecture;