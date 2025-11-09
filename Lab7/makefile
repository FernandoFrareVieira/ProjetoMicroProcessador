# Nome do simulador VHDL
GHDL = ghdl

# Flags de análise (compilação)
GHDL_AFLAGS = -a

# Flags de elaboração (NECESSÁRIO, mesmo que não estivesse nos seus comandos)
GHDL_EFLAGS = -e

# Flags de execução (run)
GHDL_RFLAGS = -r

# Nome do visualizador de ondas
WAVE_VIEWER = gtkwave

# Nome da entidade do testbench (top-level)
TESTBENCH = processador_tb

# Nome do arquivo de ondas a ser gerado (formato GHW)
WAVEFORM_GHW = processador_tb.ghw

# Lista dos arquivos VHDL na ordem correta de compilação
VHDL_SOURCES = \
	reg01bit.vhd \
	reg07bits.vhd \
	reg16bits.vhd \
	reg18bits.vhd \
	maq_estados.vhd \
	somador1_7bits.vhd \
	ext_sinal7p16.vhd \
	ULA.vhd \
	rom.vhd \
	PC.vhd \
	registrador_instr.vhd \
	acumuladores.vhd \
	bancoreg.vhd \
	UC.vhd \
	topLevel.vhd \
	$(TESTBENCH).vhd

# Regra padrão: Compila, elabora, executa e visualiza
all: view

# Regra para compilar todos os arquivos VHDL
# Usa os comandos 'ghdl -a' que você listou
compile: $(VHDL_SOURCES)
	$(GHDL) $(GHDL_AFLAGS) $^

# Regra para elaborar o testbench (Passo necessário antes de rodar)
elaborate: compile
	$(GHDL) $(GHDL_EFLAGS) $(TESTBENCH)

# Regra para executar a simulação e gerar o arquivo GHW
# Usa o comando 'ghdl -r --wave=...' que você listou
run: elaborate
	$(GHDL) $(GHDL_RFLAGS) $(TESTBENCH) --wave=$(WAVEFORM_GHW)

# Regra para abrir o GTKWave com o arquivo de ondas GHW
# Usa o comando 'gtkwave ...' que você listou
view: run
	$(WAVE_VIEWER) $(WAVEFORM_GHW)

# Regra para limpar os arquivos gerados pelo GHDL
clean:
	$(GHDL) --clean
	rm -f $(WAVEFORM_GHW) work-obj93.cf

# Declara as regras que não geram arquivos com o mesmo nome
.PHONY: all compile elaborate run view clean