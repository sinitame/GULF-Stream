/*
Copyright (c) 2019, Qianfeng Shen
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.// Copyright (c) 2019, Qianfeng Shen.
************************************************/

#include <ap_int.h>
#include "flow_control_sender.h"

#define PAUSE 0
#define UDP 1

void flow_control_senderswitch(
	AXISBUS		eth_pause_in,
	AXISBUS		eth_udp_in,
	ap_uint<1>	&udp_ready,
	AXISBUS		&eth_out,
	ap_uint<1>	eth_out_ready
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=eth_pause_in
	#pragma HLS INTERFACE ap_none port=eth_udp_in
	#pragma HLS INTERFACE ap_none port=eth_out
	#pragma HLS INTERFACE ap_none port=udp_ready
	#pragma HLS INTERFACE ap_none port=eth_out_ready

	ap_uint<1> output_sw;
	static ap_uint<1>	output_sw_reg;
	static AXISBUS		eth_out_reg;
	static ap_uint<1>	arbiter = 1;

	eth_out = eth_out_ready ? eth_out_reg : DUMMY;

	if ((eth_out_reg.valid & eth_out_reg.last) | arbiter) {
		if (eth_pause_in.valid) {
			output_sw = PAUSE;
			arbiter = 0;
			output_sw_reg = PAUSE;
		} else if (eth_udp_in.valid) {
			output_sw = UDP;
			arbiter = 0;
			output_sw_reg = UDP;
		} else {
			output_sw = output_sw_reg;
			arbiter = 1;
		}
	} else {
		output_sw = output_sw_reg;
	}

	if (eth_out_ready) {
		if (output_sw == PAUSE) {
			eth_out_reg = eth_pause_in;
		} else {
			eth_out_reg = eth_udp_in;
		}
	}
	udp_ready = (output_sw == UDP) & eth_out_ready;
}
