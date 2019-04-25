set project_dir [file dirname [file dirname [file normalize [info script]]]]
set project_name "flow_control"
source ${project_dir}/scripts/util.tcl

create_project $project_name $project_dir/$project_name -part xczu19eg-ffvc1760-2-i
set_property board_part fidus.com:sidewinder100:part0:1.0 [current_project]
create_bd_design $project_name

set_property ip_repo_paths "${project_dir}/../hls_ips" [current_project]
update_ip_catalog -rebuild

addip flow_control_receiver flow_control_receiver_0
addip flow_control_sender flow_control_sender_0
addip flow_control_senderswitch flow_control_senders_0
addip fifo_generator fifo_generator_0
set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.Reset_Type {Asynchronous_Reset} CONFIG.TDATA_NUM_BYTES {64} CONFIG.TUSER_WIDTH {0} CONFIG.Enable_TLAST {true} CONFIG.TSTRB_WIDTH {64} CONFIG.HAS_TKEEP {true} CONFIG.TKEEP_WIDTH {64} CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wach {15} CONFIG.Empty_Threshold_Assert_Value_wach {14} CONFIG.FIFO_Implementation_wdch {Common_Clock_Builtin_FIFO} CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wrch {15} CONFIG.Empty_Threshold_Assert_Value_wrch {14} CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_rach {15} CONFIG.Empty_Threshold_Assert_Value_rach {14} CONFIG.FIFO_Implementation_rdch {Common_Clock_Builtin_FIFO} CONFIG.FIFO_Implementation_axis {Common_Clock_Block_RAM} CONFIG.Input_Depth_axis {512} CONFIG.Enable_Data_Counts_axis {true} CONFIG.Full_Threshold_Assert_Value_axis {511} CONFIG.Empty_Threshold_Assert_Value_axis {510}] [get_bd_cells fifo_generator_0]

addip util_vector_logic util_vector_logic_0
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells util_vector_logic_0]

make_bd_pins_external  [get_bd_pins flow_control_receiver_0/s_axis_tx_data_V] [get_bd_pins flow_control_receiver_0/s_axis_rx_valid_V] [get_bd_pins flow_control_receiver_0/m_axis_rx_valid_V] [get_bd_pins flow_control_receiver_0/s_axis_rx_last_V] [get_bd_pins flow_control_receiver_0/ap_rst] [get_bd_pins flow_control_receiver_0/m_axis_rx_last_V] [get_bd_pins flow_control_receiver_0/s_axis_tx_valid_V] [get_bd_pins flow_control_receiver_0/ap_clk] [get_bd_pins flow_control_receiver_0/s_axis_rx_keep_V] [get_bd_pins flow_control_receiver_0/s_axis_tx_last_V] [get_bd_pins flow_control_receiver_0/s_axis_rx_data_V] [get_bd_pins flow_control_receiver_0/s_axis_ready_tx_V] [get_bd_pins flow_control_receiver_0/m_axis_rx_keep_V] [get_bd_pins flow_control_receiver_0/m_axis_rx_data_V] [get_bd_pins flow_control_receiver_0/s_axis_tx_keep_V]

make_bd_pins_external  [get_bd_pins flow_control_senders_0/eth_out_ready_V] [get_bd_pins flow_control_senders_0/eth_out_keep_V] [get_bd_pins flow_control_senders_0/eth_out_last_V] [get_bd_pins flow_control_senders_0/eth_out_data_V] [get_bd_pins flow_control_senders_0/eth_out_valid_V]

make_bd_pins_external  [get_bd_pins flow_control_sender_0/my_mac_V]

make_bd_intf_pins_external  [get_bd_intf_pins fifo_generator_0/S_AXIS]
make_bd_intf_pins_external  [get_bd_intf_pins fifo_generator_0/M_AXIS]

connect_bd_net [get_bd_ports ap_clk_0] [get_bd_pins flow_control_senders_0/ap_clk]
connect_bd_net [get_bd_ports ap_clk_0] [get_bd_pins fifo_generator_0/s_aclk]
connect_bd_net [get_bd_ports ap_clk_0] [get_bd_pins flow_control_sender_0/ap_clk]

connect_bd_net [get_bd_ports ap_rst_0] [get_bd_pins flow_control_senders_0/ap_rst]
connect_bd_net [get_bd_ports ap_rst_0] [get_bd_pins flow_control_sender_0/ap_rst]
connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins fifo_generator_0/s_aresetn]
connect_bd_net [get_bd_ports ap_rst_0] [get_bd_pins util_vector_logic_0/Op1]

connect_bd_net [get_bd_pins flow_control_sender_0/m_axis_tx_data_V] [get_bd_pins flow_control_senders_0/eth_pause_in_data_V]
connect_bd_net [get_bd_pins flow_control_sender_0/m_axis_tx_keep_V] [get_bd_pins flow_control_senders_0/eth_pause_in_keep_V]
connect_bd_net [get_bd_pins flow_control_sender_0/m_axis_tx_last_V] [get_bd_pins flow_control_senders_0/eth_pause_in_last_V]
connect_bd_net [get_bd_pins flow_control_sender_0/m_axis_tx_valid_V] [get_bd_pins flow_control_senders_0/eth_pause_in_valid_V]

connect_bd_net [get_bd_pins flow_control_receiver_0/m_axis_tx_data_V] [get_bd_pins flow_control_senders_0/eth_udp_in_data_V]
connect_bd_net [get_bd_pins flow_control_receiver_0/m_axis_tx_keep_V] [get_bd_pins flow_control_senders_0/eth_udp_in_keep_V]
connect_bd_net [get_bd_pins flow_control_receiver_0/m_axis_tx_last_V] [get_bd_pins flow_control_senders_0/eth_udp_in_last_V]
connect_bd_net [get_bd_pins flow_control_receiver_0/m_axis_tx_valid_V] [get_bd_pins flow_control_senders_0/eth_udp_in_valid_V]
connect_bd_net [get_bd_pins flow_control_receiver_0/m_axis_ready_tx_V] [get_bd_pins flow_control_senders_0/udp_ready_V]

connect_bd_net [get_bd_pins fifo_generator_0/axis_data_count] [get_bd_pins flow_control_sender_0/rx_fifo_cnt_V]

set_property name clk [get_bd_ports ap_clk_0]
set_property name rst [get_bd_ports ap_rst_0]
foreach port [get_bd_ports *_V_0] {
        set_property name [regsub "_V_0" [regsub "/" $port ""] ""] $port
}
set_property name payload_to_user_in [get_bd_intf_ports S_AXIS_0]
set_property name payload_to_user_out [get_bd_intf_ports M_AXIS_0]

save_bd_design

make_wrapper -files [get_files $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top
add_files -norecurse $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v

ipx::package_project -root_dir $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name} -vendor clarkshen.com -library user -taxonomy /UserIP
set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]

set_property vendor_display_name {clarkshen.com} [ipx::current_core]
set_property name $project_name [ipx::current_core]
set_property display_name $project_name [ipx::current_core]
set_property description $project_name [ipx::current_core]

ipx::add_bus_interface m_axis_rx [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property display_name m_axis_rx [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property physical_name m_axis_rx_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property physical_name m_axis_rx_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property physical_name m_axis_rx_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]
set_property physical_name m_axis_rx_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces m_axis_rx -of_objects [ipx::current_core]]]

ipx::add_bus_interface s_axis_tx [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property display_name s_axis_tx [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property physical_name s_axis_tx_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property physical_name s_axis_tx_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property physical_name s_axis_tx_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property physical_name s_axis_tx_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]
set_property physical_name s_axis_ready_tx [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces s_axis_tx -of_objects [ipx::current_core]]]

ipx::add_bus_interface s_axis_rx [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
set_property display_name s_axis_rx [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
set_property physical_name s_axis_rx_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
set_property physical_name s_axis_rx_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
set_property physical_name s_axis_rx_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]
set_property physical_name s_axis_rx_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces s_axis_rx -of_objects [ipx::current_core]]]

ipx::add_bus_interface m_axis_tx [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property display_name m_axis_tx [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property physical_name eth_out_data [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TLAST [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property physical_name eth_out_last [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property physical_name eth_out_valid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TKEEP [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property physical_name eth_out_keep [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]
set_property physical_name eth_out_ready [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces m_axis_tx -of_objects [ipx::current_core]]]

ipx::associate_bus_interfaces -busif m_axis_rx -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif m_axis_tx -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axis_tx -clock clk [ipx::current_core]
ipx::associate_bus_interfaces -busif s_axis_rx -clock clk [ipx::current_core]

set_property core_revision 0 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property ip_repo_paths [list "$project_dir" "${project_dir}/../hls_ips"] [current_project]
update_ip_catalog
ipx::check_integrity -quiet [ipx::current_core]
ipx::archive_core $project_dir/$project_name/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}_1.0.zip [ipx::current_core]
close_project
exit
