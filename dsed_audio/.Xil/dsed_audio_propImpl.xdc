set_property SRC_FILE_INFO {cfile:d:/Vivado/Laboratorios/final_project/DSEDFinalProject/dsed_audio/dsed_audio.srcs/sources_1/ip/clk_wiz_12mhz/clk_wiz_12mhz.xdc rfile:../dsed_audio.srcs/sources_1/ip/clk_wiz_12mhz/clk_wiz_12mhz.xdc id:1 order:EARLY scoped_inst:CLK_WIZ/inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_100Mhz]] 0.1
