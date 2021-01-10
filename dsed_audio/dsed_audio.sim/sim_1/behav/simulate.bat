@echo off
set xv_path=D:\\Vivado\\Instalacion\\Vivado\\2017.2\\bin
call %xv_path%/xsim delay_tb_behav -key {Behavioral:sim_1:Functional:delay_tb} -tclbatch delay_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
