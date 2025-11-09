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
        
        -- A: Carrega R3 com 0
        0      => B"0000000_000_011_01_001", -- LD R3, 0      
        
        -- B: Carrega R4 com 0
        1      => B"0000000_000_100_01_001", -- LD R4, 0      
        
        2      => B"0000001_000_001_01_001", -- LD R1, 1       
        
        -- Começo do loop (LOOP_START):
        -- C: R4 <- R3 + R4
        3      => B"0000000_00_100_0_00_010", -- MOV A, R4      (A = R4)
        4      => B"0000000_00_011_0_00_011", -- ADD A, R3      (A = A + R3)
        5      => B"0000000_00_100_0_01_010", -- MOV R4, A      (R4 = A)
        
        -- D: Soma 1 em R3
        6      => B"0000000_00_011_0_00_010", -- MOV A, R3      (A = R3)
        7      => B"0000000_00_001_0_00_011", -- ADD A, R1      (A = A + R1)
        8      => B"0000000_00_011_0_01_010", -- MOV R3, A      (R3 = A)
        
        -- E: Se R3 < 30, salta para C
        9      => B"0000000_00_011_0_00_010", -- MOV A, R3      (A=R3)
        10     => B"0011110_00000_0_01_100", -- CMPI A, 30     (Compara 30 - A)
        11     => B"1111000_000000_01_101", --BHI -8 (Salta para o endereço 3)

        -- F: Copia R4 para R5
        12     => B"0000000_00_100_0_00_010", -- MOV A, R4      (A = R4)
        13     => B"0000000_00_101_0_01_010", -- MOV R5, A      (R5 = A)
          
        others => B"000000000000000000"     -- NOP
    );
begin
        dado <= conteudo_rom(to_integer(endereco));
end architecture;