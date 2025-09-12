library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        A,B : in unsigned(15 downto 0);
        sel_op : in unsigned(1 downto 0);
        S : out unsigned(15 downto 0)
    );

end entity;


architecture a_ULA of ULA is
    signal op1,op2,op3,op4,result : unsigned(15 downto 0);

    begin
        op1 <= A + B;
        op2 <= A - B;
        op3 <= A nand B;
        op4 <= A xor B;

        result <= op1 when sel_op = "00" else
                op2 when sel_op = "01"   else
                op3 when sel_op = "10"   else
                op4 when sel_op = "11"   else
                "0000000000000000";
                
        S <= result;

end architecture;
