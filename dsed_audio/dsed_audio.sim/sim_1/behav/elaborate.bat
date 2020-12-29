@echo off
set xv_path=D:\\Vivado\\Instalacion\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 57c794d15a2945ca9f5ce459fb299daf -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot dsed_audio_1_tb_behav xil_defaultlib.dsed_audio_1_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
