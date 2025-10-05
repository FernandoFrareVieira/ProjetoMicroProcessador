library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        A,B : in unsigned(15 downto 0);
        sel_op : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0);
        carry : out std_logic;
        overflow : out std_logic
    );

end entity;


architecture a_ULA of ULA is
    signal op1,op2,op3,op4 : unsigned(15 downto 0);

    begin
        op1 <= A + B;
        op2 <= A - B;
        op3 <= A nand B;
        op4 <= A xor B;

        carry <= '1' when ((A(15) = '0' and B(15) = '1' and op1(15) = '0') or (A(15) = '1' and B(15) = '0' and op1(15) = '0') or (A(15) = '1' and B(15) = '1')) and (sel_op = "00") else
                 '0'; -- aqui ele confere se o basicamente se o MSB de A e de B forem 1, então a soma vai dar carry.
                      -- se o MSB DE A ou B for 1 e a soma der com MSB 0, então também ocorreu carry.
        
        overflow <= '1' when (((A(15) and B(15) and not(op1(15))) or (not(A(15)) and not(B(15)) and (op1(15)))) = '1') and (sel_op = "00") else
                    '1' when (((not(A(15)) and B(15) and op2(15)) or (A(15) and not(B(15)) and not(op2(15)))) = '1') and (sel_op = "01") else
                    '0'; --Aqui ele confere basicamente se um número positivo com positivo der um negativo quer dizer q ouve overflow.
                         --A mesma coisa vale para somar um negativo com um negativo, se der positivo, ouve overflow também, isso para a soma.

                         -- para a subtração vale a regra de se subtrair um negativo com um positivo e o resultado deu positivo, deu overflow
                         -- se subtraimos um número negativo de um positivo e der positivo, tbm deu overflow.

                         -- para nand e xor não tem essas flags.
    
        saida <= op1 when sel_op = "00" else
                op2 when sel_op = "01"   else
                op3 when sel_op = "10"   else
                op4 when sel_op = "11"   else
                "0000000000000000";
                

end architecture;
