library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ext_sinal7p16_tb is
end entity;

architecture a_ext_sinal7p16_tb of ext_sinal7p16_tb is

    component ext_sinal7p16 is
        port (
        const : in unsigned(6 downto 0);
        const_ext : out unsigned(15 downto 0)      
        );
    end component;

    signal const : unsigned(6 downto 0);
    signal const_ext_s : unsigned(15 downto 0);      

begin

    ext_sinal7p16_inst: ext_sinal7p16
     port map(
        const => const,
        const_ext => const_ext_s
    );

    principal : process
        begin
        -- Teste 1: Zero
        const <= "0000000";  -- 0
        wait for 100 ns;
        
        -- Teste 2: Número positivo +1
        const <= "0000001";  -- +1
        wait for 100 ns;
        
        -- Teste 3: Número positivo +10
        const <= "0001010";  -- +10
        wait for 100 ns;
        
        -- Teste 4: Maior positivo +63
        const <= "0111111";  -- +63
        wait for 100 ns;
        
        -- Teste 5: -1 (todos bits em 1)
        const <= "1111111";  -- -1
        wait for 100 ns;
        
        -- Teste 6: -2
        const <= "1111110";  -- -2
        wait for 100 ns;
        
        -- Teste 7: -10
        const <= "1110110";  -- -10
        wait for 100 ns;
        
        -- Teste 8: Menor negativo -64
        const <= "1000000";  -- -64
        wait for 100 ns;
        
        -- Teste 9: +32
        const <= "0100000";  -- +32
        wait for 100 ns;
        
        -- Teste 10: -32
        const <= "1100000";  -- -32
        wait for 100 ns;
        
        wait;
        
    end process;

end architecture;