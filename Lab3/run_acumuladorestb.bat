@echo off
REM Compila todos os arquivos VHDL do projeto
ghdl -a acumuladores.vhd
ghdl -a acumuladoresTB.vhd

REM Roda o testbench e gera o arquivo de onda
ghdl -r acumuladoresTB --wave=acumuladoresTB.ghw

