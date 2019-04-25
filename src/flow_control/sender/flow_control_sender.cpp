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

void flow_control_sender(
	ap_uint<48>	my_mac,
	ap_uint<10>	rx_fifo_cnt,
	AXISBUS		&m_axis_tx
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=my_mac
	#pragma HLS INTERFACE ap_none port=rx_fifo_cnt
	#pragma HLS INTERFACE ap_none port=m_axis_tx

	static ap_uint<16> pause_timer;

	if (rx_fifo_cnt > 150 && pause_timer == 0) {
		m_axis_tx.data(511,464) = PAUSE_MAC;
		m_axis_tx.data(463,416) = my_mac;
		m_axis_tx.data(415,400) = PAUSE_TYPE;
		m_axis_tx.data(399,384) = 1;
		m_axis_tx.data(383,368) = rx_fifo_cnt;
		m_axis_tx.data(367,0) = 0;
		m_axis_tx.keep = ap_uint<64>("0xfffffffffffffff0",16);
		m_axis_tx.last = 1;
		m_axis_tx.valid = 1;
		pause_timer = 250;
	} else {
		m_axis_tx = DUMMY;
		if (pause_timer != 0) {
			pause_timer--;
		}
	}
}
