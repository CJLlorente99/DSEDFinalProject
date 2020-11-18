onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+clk_wiz_12mhz -L xil_defaultlib -L secureip -O5 xil_defaultlib.clk_wiz_12mhz

do {wave.do}

view wave
view structure

do {clk_wiz_12mhz.udo}

run -all

endsim

quit -force
