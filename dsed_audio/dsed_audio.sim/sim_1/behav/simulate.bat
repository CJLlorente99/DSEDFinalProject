@echo off
set xv_path=D:\\Vivado\\Instalacion\\Vivado\\2017.2\\bin
call %xv_path%/xsim half_mul_tb_behav -key {Behavioral:sim_1:Functional:half_mul_tb} -tclbatch half_mul_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
