library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_flags is
    port(
        clk, wr_en, reset : in std_logic;
        
        carry_in : in std_logic;
        overflow_in : in std_logic;
        zero_in : in std_logic;
        negative_in : in std_logic;
        
        carry_out : out std_logic;
        overflow_out : out std_logic;
        zero_out : out std_logic;
        negative_out : out std_logic
    );
end entity;

architecture a_reg_flags of reg_flags is  
    signal carry : std_logic;
    signal overflow : std_logic;
    signal zero : std_logic;
    signal negative : std_logic;
begin

    process(clk, wr_en, reset)
    begin
        if reset = '1' then
            carry <= '0';
            overflow <= '0';
            zero <= '0';
            negative <= '0';
        elsif wr_en = '1' then  
            if  rising_edge(clk) then      
                carry <= carry_in;
                overflow <= overflow_in;
                zero <= zero_in;
                negative <= negative_in;
            end if;
        end if;
    end process;
    
    carry_out <= carry;
    overflow_out <= overflow;
    zero_out <= zero;
    negative_out <= negative;

end architecture;