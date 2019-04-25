set root_dir [file dirname [file dirname [file dirname [file dirname [file dirname [file normalize [info script]]]]]]]
set ip_name "flow_control"
set sub_dir_name "sender"
set module_name "flow_control_senderswitch"
cd $ip_name
open_project $module_name
set_top $module_name
add_files $root_dir/src/$ip_name/$sub_dir_name/$module_name.cpp
open_solution "solution1"
set_part {xczu19eg-ffvc1760-2-i} -tool vivado
config_rtl -reset all
create_clock -period 3.103 -name default
csynth_design
export_design -rtl verilog
