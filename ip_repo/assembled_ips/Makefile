all: GULF_Stream lbus_axis_converter flow_control

GULF_Stream: scripts/full_core.tcl arp_server_100g udp_ip_server_100g ../hls_ips/ether_protocol_assembler ../hls_ips/ether_protocol_spliter
	rm -rf GULF_Stream
	vivado -mode tcl -source  scripts/full_core.tcl -nolog -nojournal

arp_server_100g: scripts/arp.tcl ../hls_ips/arp_server
	rm -rf arp_server_100g
	vivado -mode tcl -source scripts/arp.tcl -nolog -nojournal

lbus_axis_converter: scripts/lbus_axis_converter.tcl ../hls_ips/lbus_axis_converter
	rm -rf lbus_axis_converter
	vivado -mode tcl -source scripts/lbus_axis_converter.tcl -nolog -nojournal

udp_ip_server_100g: scripts/udp_ip.tcl ../hls_ips/udp_ip_server
	rm -rf udp_ip_server_100g
	vivado -mode tcl -source scripts/udp_ip.tcl -nolog -nojournal

eth_flow_control: scripts/flow_control.tcl ../hls_ips/flow_control
	rm -rf eth_flow_control
	vivado -mode tcl -source scripts/flow_control.tcl -nolog -nojournal

clean:
	rm -rf arp_server_100g lbus_axis_converter udp_ip_server_100g GULF_Stream flow_control
