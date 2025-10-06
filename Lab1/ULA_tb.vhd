library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end entity;

architecture a_ULA_tb of ULA_tb is
    component ULA
        port(
            A,B : in unsigned(15 downto 0);
            sel_op : in unsigned(1 downto 0);
            saida : out unsigned(15 downto 0);
            carry : out std_logic;
            overflow : out std_logic
        );
    end component;

    signal A, B, saida: unsigned(15 downto 0);
    signal sel_op: unsigned(1 downto 0);
    signal carry_s,overflow_s : std_logic;

    begin
        uut: ULA port map(
            A => A,
            B => B,
            sel_op => sel_op,
            saida => saida,
            carry => carry_s,
            overflow => overflow_s
        );

    process 
    begin
sel_op <= "00"; --soma
        
        A <= "0000000000000101"; -- 5
        B <= "0000000000001010"; -- 10
        wait for 50 ns;

        A <= "0000000000001010"; -- 10
        B <= "1111111111101100"; -- -20
        wait for 50 ns;

        A <= "1111111111111111"; -- 65535
        B <= "0000000000000001"; -- 1
        wait for 50 ns;
        
        A <= "0111111111111111"; -- 32767
        B <= "0000000000000001"; -- 1
        wait for 50 ns;

        A <= "1000000000000000"; -- -32768
        B <= "1111111111111111"; -- -1
        wait for 50 ns;
        
        A <= "1000000000000000"; -- -32768
        B <= "1000000000000000"; -- -32768
        wait for 50 ns;

        sel_op <= "01"; --subtração
        
        A <= "0000000001100100"; -- 100
        B <= "0000000000101000"; -- 40
        wait for 50 ns;
        
        A <= "0000000000110010"; -- 50
        B <= "0000000001010000"; -- 80
        wait for 50 ns;
        
        A <= "1000000000000000"; -- -32768
        B <= "0000000000000001"; -- 1
        wait for 50 ns;

        A <= "0111111111111111"; -- 32767
        B <= "1111111111111111"; -- -1
        wait for 50 ns;
        
        sel_op <= "10"; --nand
        
        A <= "1111111111111111"; -- FFFF
        B <= "0000111100001111"; -- 0F0F
        wait for 50 ns;

        A <= "1010101010101010"; -- AAAA
        B <= "0101010101010101"; -- 5555
        wait for 50 ns;

        A <= "1111000011110000"; -- F0F0
        B <= "1010101010101010"; -- AAAA
        wait for 50 ns;
        
        sel_op <= "11"; --xor
        
        A <= "0001001000110100"; -- 1234
        B <= "0001001000110100"; -- 1234
        wait for 50 ns;
        
        A <= "1010101010101010"; -- AAAA
        B <= "1111111111111111"; -- FFFF
        wait for 50 ns;

        A <= "1111000011110000"; -- F0F0
        B <= "1010101010101010"; -- AAAA
        wait for 50 ns;
        
        wait;
    end process;
end architecture;