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
        0      => B"0000000_000_011_01_001", --  A: LD r3 0
        1      => B"0000000_000_100_01_001", --  B: LD r4 0
        2      => B"0000000_00_100_0_00_010", -- C: MOV A <- R4 
        3      => B"0000000_00_011_0_00_011", -- A <- R3 + A (tipo/add)
        4      => B"0000000_00_100_0_01_010", -- MOV R4 <- A​​
        5      => B"0000001_00000_1_00_001", --  D: LD B <- 1​
        6      => B"0000000_00_011_1_00_011", -- B <- R3 + B (tipo/add)
        7      => B"0000000_00_011_1_01_010", -- MOV R3 <- B​​
        8      => B"0000000_00_011_0_00_010", -- MOV A <- R3 
        9      => B"0000000_00_000_0_01_011", -- A <- R0 - A (tipo/sub)​
        10     => B"0000000_00_001_0_01_010", -- MOV R1 <- A​
        11     => B"1100010_00_001_0_01_100", -- CMPI R1 -30
        12     => B"1110110_000000_01_101", --   E: BHI C
        13     => B"0000000_00_100_0_00_010", -- F: MOV A <- R4
        14     => B"0000000_00_101_0_01_010", -- MOV R5 <- A​​ 
        others => (others=>'0')    
    );
begin
        dado <= conteudo_rom(to_integer(endereco));

end architecture;


--B"0000000_000_000_00_000" -- NOP​
--B"0000000_000_000_00_111" -- JUMP (endereço/delta em const)​
--B"0000000_00000_0_00_001" -- LD ACC <- const​
--B"0000000_000_000_01_001" -- LD Rn <- const​
--B"0000000_00_000_0_00_010" -- MOV A <- Rn​
--B"0000000_00_000_0_01_010" -- MOV Rn <- A​
--B"0000000_00_000_0_00_011" -- A <- Rn + A (tipo/add)​
--B"0000000_00_000_0_01_011" -- A <- Rn - A (tipo/sub)​
--B"0000000_00_000_0_00_011" ; A <- Rn NAND A (tipo/nand)​
--B"0000000_00_000_0_00_011" ; A <- Rn XOR A (tipo/xor)​
--B"1100010_00_001_0_01_100", -- CMPI R1 -30
--B"00000000_00000_00_101" -- BVC (delta em const)​
--B"00000000_00000_01_101" -- BHI (delta em const)
