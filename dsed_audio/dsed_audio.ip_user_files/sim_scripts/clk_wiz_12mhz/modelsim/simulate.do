onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L xil_defaultlib -L secureip -lib xil_defaultlib xil_defaultlib.clk_wiz_12mhz

do {wave.do}

view wave
view structure
view signals

do {clk_wiz_12mhz.udo}

run -all

quit -force
