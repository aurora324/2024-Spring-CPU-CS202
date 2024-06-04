# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir E:/vivado/code/2024-Spring-CPU-CS202/CPU.cache/wt [current_project]
set_property parent.project_path E:/vivado/code/2024-Spring-CPU-CS202/CPU.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths e:/vivado/code/2024-Spring-CPU-CS202/SEU_CSE_507_user_uart_bmpg_1.3 [current_project]
set_property ip_output_repo e:/vivado/code/2024-Spring-CPU-CS202/CPU.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/ParamDef.vh
read_verilog -library xil_defaultlib {
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/ALU.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/Controller.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/DMemory32.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/EX.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/GenImm.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/ID.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/IF.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/MemOrIO.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/PC.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/PCselect.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/Register.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/WB.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/button.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/compare.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/leds.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/programROM.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/segs.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/switchs.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/vga_char.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/vga_num.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/vgas.v
  E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/new/top.v
}
read_ip -quiet e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg_0.xci

read_ip -quiet e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

read_ip -quiet e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/inst_mem/inst_mem.xci
set_property used_in_implementation false [get_files -all e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/inst_mem/inst_mem_ooc.xdc]

read_ip -quiet e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/data_mem/data_mem.xci
set_property used_in_implementation false [get_files -all e:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/sources_1/ip/data_mem/data_mem_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/constrs_1/new/constraint.xdc
set_property used_in_implementation false [get_files E:/vivado/code/2024-Spring-CPU-CS202/CPU.srcs/constrs_1/new/constraint.xdc]


synth_design -top top -part xc7a35tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"