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
        
        0 => B"0000000_000_000_00_000", -- NOP​
        1 => B"0000000_000_000_00_000", -- NOP​
        2 => B"0000000_000_000_00_000", -- NOP
        3 => B"000000_0001000_00_111", -- JUMP 8
        8 => B"00001010_0000_1_00_001", -- LD B <- 10
        9 => B"00001011_00_000_01_001", -- LD R0 <- 11
        10 => B"000000000_000_0_00_010", -- MOV A <- R0
        11 => B"000000000_001_1_01_010", -- MOV R1 <- B
        12 => B"000000000_000_0_00_011", -- A <- R0 + A (tipo/add)​
        13 => B"000000000_001_1_01_011", -- B <- R1 - B (tipo/sub)​
        14 => B"000000000_000_1_10_011",  -- B <- R0 NAND B (tipo/nand)​
        15 => B"000000000_001_0_11_011",  -- A <- R1 XOR A (tipo/xor)
        16 => B"00110010_0000_0_01_100", -- CMPI A 50 
        17 => B"00000100_00000_01_101", -- BHI 4 aqui não vai porque A não é maior que 50
        18 => B"00010100_0_000_0_01_100", -- CMPI A 20
        19 => B"00000011_00000_01_101", -- BHI 3 aqui vai dar porque A é maior que 20 
        22 => B"01111111_0000_0_00_001", -- LD A <- 127
        23 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        24 => B"000000000_010_0_01_010", -- MOV R2 <- A
        25 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        26 => B"000000000_010_0_01_010", -- MOV R2 <- A
        27 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        28 => B"000000000_010_0_01_010", -- MOV R2 <- A
        29 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        30 => B"000000000_010_0_01_010", -- MOV R2 <- A
        31 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        32 => B"000000000_010_0_01_010", -- MOV R2 <- A
        33 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        34 => B"000000000_010_0_01_010", -- MOV R2 <- A
        35 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        36 => B"000000000_010_0_01_010", -- MOV R2 <- A
        37 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        38 => B"000000000_010_0_01_010", -- MOV R2 <- A
        39 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        40 => B"000000000_010_0_01_010", -- MOV R2 <- A
        41 => B"000000000_010_0_00_011", -- A <- R2 + A (tipo/add)​
        42 => B"000000000_010_0_01_010", -- MOV R2 <- A
        43 => B"00000100_00000_00_101", -- BVC 4 não vai pq tem overflow
        44 => B"111111100_000_0_01_100", -- CMPI B -2 vai zerar a flag do overflow
        45 => B"00000100_00000_00_101", -- BVC 4 vai ativar
        49 => B"11111111_00_000_01_001", -- LD R0 <- -1
        50 => B"0_0000011_0_000_1_10_101", -- CNJE B R0 3 não vai ativar porque é igual
        51 => B"00000000_0_001_1_00_011", -- B <- R1 + B (tipo/add)​
        52 => B"0_0000011_0_000_1_10_101", -- CNJE B R0 3 agora vai dar branch porque é igual
        55 => B"000000000_001_0_11_001", -- SW [R1] <- A
        56 => B"000000000_001_1_10_001", -- LW B <- dado[R1]​


        others => B"000000000000000000"
    );
begin
        dado <= conteudo_rom(to_integer(endereco));
end architecture;


--B"0000000_000_000_00_000" -- NOP​
--B"000000_0000000_00_111" -- JUMP (endereço em const)
--B"00000000_0000_0_00_001" -- LD Acc <- const​
--B"00000000_00_000_01_001" -- LD Rn <- const​
--B"000000000_000_0_00_010" -- MOV Acc <- Rn​
--B"000000000_000_0_01_010" -- MOV Rn <- Acc​
--B"000000000_000_0_00_011" -- Acc <- Rn + Acc (tipo/add)​
--B"000000000_000_0_01_011" -- Acc <- Rn - Acc (tipo/sub)​
--B"000000000_000_1_10_011" -- Acc <- Rn NAND Acc (tipo/nand)​
--B"000000000_000_0_11_011" -- Acc <- Rn XOR Acc (tipo/xor)​
--B"00000000_0000_0_01_100" -- CMPI Acc constante 
--B"0_00000000_00000_00_101" -- BVC (delta em const)​
--B"0_00000000_00000_01_101" -- BHI (delta em const)
--B"0000000_00_000_0_10_001" -- LW Acc <- dado[RN]​
--B"0000000_00_000_0_11_001" -- SW [RN] <- Acc​
--B"0_0000000_0_000_0_10_101" -- CNJE acc rn delta