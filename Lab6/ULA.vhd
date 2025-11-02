library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        A,B : in unsigned(15 downto 0);
        sel_op : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0);
        carry : out std_logic;
        overflow : out std_logic;
        zero : out std_logic;
        negative : out std_logic
    );

end entity;


architecture a_ULA of ULA is
    signal op_soma : unsigned(15 downto 0);
    signal op_sub : unsigned(15 downto 0);
    signal op_nand : unsigned(15 downto 0);
    signal op_xor : unsigned(15 downto 0);

    signal in_a_17, in_b_17, soma_17 : unsigned(16 downto 0);

    signal carry_soma, carry_sub : std_logic;
    signal overflow_soma, overflow_sub : std_logic;
    signal resultado : unsigned(15 downto 0);

    begin
        --Operações
        op_soma <= A + B;
        op_sub <= A - B;
        op_nand <= A nand B;
        op_xor <= A xor B;
        
        resultado <= op_soma when sel_op = "00" else
                     op_sub when sel_op = "01" else
                     op_nand when sel_op = "10" else
                     op_xor when sel_op = "11" else
                     "0000000000000000";

        saida <= resultado;
    
        --Flags
        in_a_17 <= '0' & A;
        in_b_17 <= '0' & B;
        soma_17 <= in_a_17 + in_b_17;
        carry_soma <= soma_17(16);

        carry_sub <= '0' when B <= A else '1';

        overflow_soma <= ('1' when (A(15)='0' and B(15)='0' and op_soma(15)='1') or (A(15)='1' and B(15)='1' and op_soma(15)='0') else '0');
        
        overflow_sub <= ('1' when (A(15)='0' and B(15)='1' and op_sub(15)='1') or (A(15)='1' and B(15)='0' and op_sub(15)='0') else'0');

        --Muxes
        carry <= carry_soma when sel_op = "00" else
                 carry_sub when sel_op = "01" else
                 '0';
        
        overflow <= overflow_soma when sel_op = "00" else
                    overflow_sub when sel_op = "01" else
                    '0';
        
        zero <= '1' when resultado = "0000000000000000" else '0';

        negative <= resultado(15);

end architecture;
