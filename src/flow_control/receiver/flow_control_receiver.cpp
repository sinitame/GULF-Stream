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
#include "flow_control_receiver.h"
void flow_control_receiver(
	AXISBUS		&m_axis_rx,
	AXISBUS		s_axis_rx,
	AXISBUS		&m_axis_tx,
	AXISBUS		s_axis_tx,
	ap_uint<1>	m_axis_ready_tx,
	ap_uint<1>	&s_axis_ready_tx
) {
	#pragma HLS INTERFACE ap_ctrl_none port=return
	#pragma HLS INTERFACE ap_none port=m_axis_rx
	#pragma HLS INTERFACE ap_none port=s_axis_rx
	#pragma HLS INTERFACE ap_none port=m_axis_tx
	#pragma HLS INTERFACE ap_none port=s_axis_tx
	#pragma HLS INTERFACE ap_none port=m_axis_ready_tx
	#pragma HLS INTERFACE ap_none port=s_axis_ready_tx

	static ap_uint<16> pause_counter;
	static ap_uint<1> tx_pause;
	m_axis_tx = s_axis_tx;
	s_axis_ready_tx = m_axis_ready_tx & !tx_pause;

	if (s_axis_rx.valid && s_axis_rx.data(511,464) == PAUSE_MAC && s_axis_rx.data(415,400) == PAUSE_TYPE && s_axis_rx.data(399,384) == 1) {
		pause_counter = s_axis_rx.data(383,368);
	} else {
		m_axis_rx = s_axis_rx;
		if (pause_counter != 0 && tx_pause) {
			pause_counter--;
		} else if (pause_counter == 0) {
			tx_pause = 0;	
		} else if (pause_counter != 0 && (s_axis_tx.valid & s_axis_tx.last)) {
			tx_pause = 1;
			pause_counter--;
		}
	}
}
