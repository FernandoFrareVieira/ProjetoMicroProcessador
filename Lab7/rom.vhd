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
        0 => B"0001010_000_000_01_001", -- LD Rn <- const​
        1 => B"0010100_00000_0_00_001", -- LD Acc <- const​
        2 => B"0000000_00_000_0_11_001",-- SW [RN] <- Acc​
        3 => B"0000000_00_000_1_10_001", -- LW Acc <- dado[RN]​
        4 => B"0001011_000_001_01_001", -- LD Rn <- const​
        5 => B"0010101_00000_0_00_001", -- LD Acc <- const​
        6 => B"0000000_00_001_0_11_001",-- SW [RN] <- Acc​
        7 => B"0000000_00000_0_00_001", -- LD Acc <- const​
        8 => B"0000000_00_000_0_10_001", -- LW Acc <- dado[RN]​
        9 => B"0000000_00_001_0_10_001", -- LW Acc <- dado[RN]​
        
          
        others => B"000000000000000000"     -- NOP
    );
begin
        dado <= conteudo_rom(to_integer(endereco));
end architecture;



--B"0000000_000_000_00_000" -- NOP​
--B"0000000_000_000_00_111" -- JUMP (endereço em const)
--B"0000000_00000_0_00_001" -- LD Acc <- const​
--B"0000000_000_000_01_001" -- LD Rn <- const​
--B"0000000_00_000_0_00_010" -- MOV Acc <- Rn​
--B"0000000_00_000_0_01_010" -- MOV Rn <- Acc​
--B"0000000_00_000_0_00_011" -- Acc <- Rn + Acc (tipo/add)​
--B"0000000_00_000_0_01_011" -- Acc <- Rn - Acc (tipo/sub)​
--B"0000000_00_000_0_00_011"  Acc <- Rn NAND Acc (tipo/nand)​
--B"0000000_00_000_0_00_011"  Acc <- Rn XOR Acc (tipo/xor)​
--B"0000000_00_000_0_01_100" -- CMPI Acc constante 
--B"00000000_00000_00_101" -- BVC (delta em const)​
--B"00000000_00000_01_101" -- BHI (delta em const)
--B"0000000_00_000_0_10_001" -- LW Acc <- dado[RN]​
--B"0000000_00_000_0_11_001" -- SW [RN] <- Acc​



--Alterar a forma de comparação, cmpi A, 30 é A-30, não 30-A
