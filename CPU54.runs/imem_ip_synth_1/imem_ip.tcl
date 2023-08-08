# 
# Synthesis run script generated by Vivado
# 

set_param simulator.modelsimInstallPath C:/modeltech_pe_10.4c/win32pe
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.cache/wt} [current_project]
set_property parent.project_path {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_ip -quiet {{c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip.xci}}
set_property is_locked true [get_files {{c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip.xci}}]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top imem_ip -part xc7a100tcsg324-1 -mode out_of_context

rename_ref -prefix_all imem_ip_

write_checkpoint -force -noxdef imem_ip.dcp

catch { report_utilization -file imem_ip_utilization_synth.rpt -pb imem_ip_utilization_synth.pb }

if { [catch {
  file copy -force {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.runs/imem_ip_synth_1/imem_ip.dcp} {c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip.dcp}
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub {c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip_stub.v}
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub {c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip_stub.vhdl}
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim {c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip_sim_netlist.v}
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim {c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip_sim_netlist.vhdl}
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if {[file isdir {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.ip_user_files/ip/imem_ip}]} {
  catch { 
    file copy -force {{c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip_stub.v}} {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.ip_user_files/ip/imem_ip}
  }
}

if {[file isdir {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.ip_user_files/ip/imem_ip}]} {
  catch { 
    file copy -force {{c:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.srcs/sources_1/ip/imem_ip/imem_ip_stub.vhdl}} {C:/BaiduSyncdisk/Principles of computer composition/CPU54/CPU54/CPU54.ip_user_files/ip/imem_ip}
  }
}