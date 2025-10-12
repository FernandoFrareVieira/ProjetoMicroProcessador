library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg is
    port (
        clk   : in std_logic;
        wr_en : in std_logic;
        reset : in std_logic;
        data_wr : in unsigned(15  downto 0);
        reg_wr : in unsigned(2 downto 0);
        reg_r1: in unsigned(2 downto 0);
        data_out : out unsigned(15 downto 0)
        
    );
end entity;


architecture a_bancoreg of bancoreg is

    component reg16bits is
        port (
            clk,wr_en,reset: in std_logic;
            data_in: in unsigned(15 downto 0);
            data_out: out unsigned(15 downto 0)
        );
    end component;

    signal temp_data_in : unsigned(15 downto 0);
    signal temp_data_out : unsigned(15 downto 0);
    --Jeito Antigo
    --signal r0, r1, r2, r3, r4, r5, r6, r7 : unsigned(15 downto 0);
    signal r0_data_out, r1_data_out, r2_data_out, r3_data_out, r4_data_out, r5_data_out, r6_data_out, r7_data_out : unsigned(15 downto 0);
    signal wr_en_r0, wr_en_r1, wr_en_r2, wr_en_r3, wr_en_r4, wr_en_r5, wr_en_r6, wr_en_r7 : std_logic;

begin

    reg0 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r0,
        reset => reset,
        data_in => data_wr,
        data_out => r0_data_out
    );
    reg1 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r1,
        reset => reset,
        data_in => data_wr,
        data_out => r1_data_out
    );
    reg2 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r2,
        reset => reset,
        data_in => data_wr,
        data_out => r2_data_out
    );
    reg3 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r3,
        reset => reset,
        data_in => data_wr,
        data_out => r3_data_out
    );
    reg4 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r4,
        reset => reset,
        data_in => data_wr,
        data_out => r4_data_out
    );
    reg5 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r5,
        reset => reset,
        data_in => data_wr,
        data_out => r5_data_out
    );
    reg6 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r6,
        reset => reset,
        data_in => data_wr,
        data_out => r6_data_out
    );
    reg7 : reg16bits port map(
        clk => clk,
        wr_en => wr_en_r7,
        reset => reset,
        data_in => data_wr,
        data_out => r7_data_out
    );

    wr_en_r0 <= wr_en when reg_wr = "000" else '0';
    wr_en_r1 <= wr_en when reg_wr = "001" else '0';
    wr_en_r2 <= wr_en when reg_wr = "010" else '0';
    wr_en_r3 <= wr_en when reg_wr = "011" else '0';
    wr_en_r4 <= wr_en when reg_wr = "100" else '0';
    wr_en_r5 <= wr_en when reg_wr = "101" else '0';
    wr_en_r6 <= wr_en when reg_wr = "110" else '0';
    wr_en_r7 <= wr_en when reg_wr = "111" else '0';

    --Jeito Antigo    
    --r0 <= data_wr when reg_wr = "000" else "0000000000000000";
    --r1 <= data_wr when reg_wr = "001" else "0000000000000000";
    --r2 <= data_wr when reg_wr = "010" else "0000000000000000";
    --r3 <= data_wr when reg_wr = "011" else "0000000000000000";
    --r4 <= data_wr when reg_wr = "100" else "0000000000000000";
    --r5 <= data_wr when reg_wr = "101" else "0000000000000000";
    --r6 <= data_wr when reg_wr = "110" else "0000000000000000";
    --r7 <= data_wr when reg_wr = "111" else "0000000000000000";

    data_out <= r0_data_out when reg_r1 = "000" else
                r1_data_out when reg_r1 = "001" else
                r2_data_out when reg_r1 = "010" else
                r3_data_out when reg_r1 = "011" else
                r4_data_out when reg_r1 = "100" else
                r5_data_out when reg_r1 = "101" else
                r6_data_out when reg_r1 = "110" else
                r7_data_out when reg_r1 = "111" else
                "0000000000000000";    

end architecture;
