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
--Esse programa simples apenas pula para frente, simulando um condicional, e depois tem um pulo para tras, simulando um loop.  
--Contandos os Clocks pelo arquivo ghw, vemos que o programa precisa de 10 clocks para completar to\do seu funcionamento, sendo elas as instruções nas posições: 0,1,4,5,6. 
--Isso acontece principalmente porque temos um estado para pegar a instrução(FETCH), e outro executa-la, isso adiciona um ciclo de 2 clocks para cada instrução.
architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(17 downto 0);
    constant conteudo_rom : mem := (
        0      => "000000000000000000", -- NOP
        1      => "000000000100001111", -- JUMP 4 (Salto para frente)
        2      => "000000000000000000", -- NOP (Deve ser pulado)
        3      => "000000000000000000", -- NOP (Deve ser pulado)
        4      => "000000000000000000", -- NOP (Alvo do pulo e início do loop)
        5      => "000000000000000000", -- NOP
        6      => "000000000100001111", -- JUMP 4 (Salto para trás, cria o loop)
        7      => "000000000000000000", -- NOP (Nunca deve ser alcançado)
        others => (others=>'0')
    );
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;
