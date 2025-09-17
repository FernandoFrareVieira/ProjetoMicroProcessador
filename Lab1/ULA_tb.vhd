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
            saida : out unsigned(15 downto 0)
        );
    end component;

    signal A, B, saida: unsigned(15 downto 0);
    signal sel_op: unsigned(1 downto 0);

    begin
        uut: ULA port map(
            A => A,
            B => B,
            sel_op => sel_op,
            saida => saida
        );

    process 
    begin
        sel_op <= "00";
        
        A <= "0000000000000101"; -- 5
        B <= "0000000000001010"; -- 10
        wait for 50 ns;

        A <= "0000000000001010"; -- 10
        B <= "1111111111101100"; -- -20
        wait for 50 ns;
        
        sel_op <= "01";
        
        A <= "0000000001100100"; -- 100
        B <= "0000000000101000"; -- 40
        wait for 50 ns;
        
        A <= "0000000000110010"; -- 50
        B <= "0000000001010000"; -- 80
        wait for 50 ns;
        
        sel_op <= "10";
        
        A <= "1111111111111111"; -- FFFF
        B <= "0000111100001111"; -- 0F0F
        wait for 50 ns;

        A <= "1010101010101010"; -- AAAA
        B <= "0101010101010101"; -- 5555
        wait for 50 ns;

        
        sel_op <= "11";
        
        A <= "0001001000110100"; -- 1234
        B <= "0001001000110100"; -- 1234
        wait for 50 ns;
        
        A <= "1010101010101010"; -- AAAA
        B <= "1111111111111111"; -- FFFF
        wait for 50 ns;
        
        wait;
    end process;
end architecture;