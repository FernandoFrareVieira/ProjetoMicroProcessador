@echo off
REM Compila todos os arquivos VHDL da pasta Lab7

echo Compilando arquivos VHDL...

ghdl -a reg01bit.vhd
ghdl -a reg07bits.vhd
ghdl -a reg16bits.vhd
ghdl -a reg18bits.vhd
ghdl -a maq_estados.vhd
ghdl -a somador1_7bits.vhd
ghdl -a ext_sinal7p16.vhd
ghdl -a somador_endereco_relativo.vhd
ghdl -a ULA.vhd
ghdl -a ram.vhd
ghdl -a rom.vhd
ghdl -a PC.vhd
ghdl -a registrador_instr.vhd
ghdl -a acumuladores.vhd
ghdl -a bancoreg.vhd
ghdl -a UC.vhd
ghdl -a topLevel.vhd
ghdl -a processador_tb.vhd

echo.
echo Compilacao concluida!
pause