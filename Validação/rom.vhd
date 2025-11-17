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
        
        0 => B"00000001_00_000_01_001", -- LD R0 <- 1 --Loop para adicionar os números 1 a 31 nas posições 111 até 141 da memória
        1 => B"01101111_00_001_01_001", -- LD R1 <- 111
        2 => B"00100000_00_010_01_001", -- LD R2 <- 32
        3 => B"00000001_0000_0_00_001", -- LD A <- 1
        4 => B"00000000_0_001_0_11_001", -- SW [R1] <- Acc​
        5 => B"00000000_0_000_0_00_011", -- A <- R0 + A (tipo/add)​
        6 => B"00000000_0_011_0_01_010", -- MOV R3 <- A​
        7 => B"00000000_0_000_0_00_010", -- MOV A <- R0
        8 => B"00000000_0_001_0_00_011", -- A <- R1 + A (tipo/add)​
        9 => B"00000000_0_001_0_01_010", -- MOV R1 <- A​
        10 => B"00000000_0_011_0_00_010", -- MOV A <- R3
        11 => B"0_1111001_0_010_0_10_101", -- CNJE R2 A -7 volta para instrução 4
        12 => B"01101111_00_001_01_001", -- LD R1 <- 111 -- loop para ler se deu tudo certo
        13 => B"00100000_00_010_01_001", -- LD R2 <- 32
        14 => B"0000000_00_001_1_10_001", -- LW B <- dado[R1]
        15 => B"00000000_0_000_0_00_010", -- MOV A <- R0
        16 => B"00000000_0_001_0_00_011", -- A <- R1 + A (tipo/add)
        17 => B"00000000_0_001_0_01_010", -- MOV R1 <- A​
        18 => B"00000001_0000_0_00_001", -- LD A <- 1
        19 => B"00000000_0_010_0_01_011", -- A <- R2 - A (tipo/sub)​
        20 => B"00000000_0_010_0_01_010", -- MOV R2 <- A​
        21 => B"00000001_0000_0_00_001", -- LD A <- 1
        22 => B"0_1111000_0_010_0_10_101", -- CNJE R2 A -8 -- volta para a instrução 14
        


        others => B"000000000000000000"
    );
begin
        dado <= conteudo_rom(to_integer(endereco));
end architecture;


--B"0000000_000_000_00_000" -- NOP​
--B"0000000_000_000_00_111" -- JUMP (endereço em const)
--B"00000000_0000_0_00_001" -- LD Acc <- const​
--B"00000000_00_000_01_001" -- LD Rn <- const​
--B"00000000_0_000_0_00_010" -- MOV Acc <- Rn​
--B"00000000_0_000_0_01_010" -- MOV Rn <- Acc​
--B"00000000_0_000_0_00_011" -- Acc <- Rn + Acc (tipo/add)​
--B"00000000_0_000_0_01_011" -- Acc <- Rn - Acc (tipo/sub)​
--B"00000000_0_000_0_00_011"  Acc <- Rn NAND Acc (tipo/nand)​
--B"00000000_0_000_0_00_011"  Acc <- Rn XOR Acc (tipo/xor)​
--B"00000000_0_000_0_01_100" -- CMPI Acc constante 
--B"0_00000000_0000_00_101" -- BVC (delta em const)​
--B"0_00000000_0000_01_101" -- BHI (delta em const)
--B"0000000_00_000_0_10_001" -- LW Acc <- dado[RN]​
--B"0000000_00_000_0_11_001" -- SW [RN] <- Acc​
--B"0_0000000_0_000_0_10_101" -- CNJE acc rn delta