@echo off
REM Compila todos os arquivos VHDL do projeto
ghdl -a bancoreg.vhd
ghdl -a bancoregTB.vhd

REM Roda o testbench e gera o arquivo de onda
ghdl -r bancoregTB --wave=bancoregTB.ghw

