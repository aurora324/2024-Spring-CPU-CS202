set_property SRC_FILE_INFO {cfile:e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/cpuclk/cpuclk.xdc rfile:../CPU.srcs/sources_1/ip/cpuclk/cpuclk.xdc id:1 order:EARLY scoped_inst:clk1/inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1]] 0.1
