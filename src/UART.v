module UART #(parameter clkperbit = 10)
(rx, send, clock, reset, tx, txdata, rxdata, rxfinish, txdone);
	input rx , clock, reset, send;
	input[7:0] txdata; 
	output tx, rxfinish, txdone; 
	output[7:0] rxdata; 
	
	Receive #(clkperbit) receiver  
		(.rxdata(rxdata),
		 .rxfinish(rxfinish),
		 .rx(rx), 
		 .clock(clock),
		 .reset(reset)
		);

	Transmit #(clkperbit) transmitter
		(.txdata(txdata),
		 .txdone(txdone),
		 .send(send),
		 .tx(tx),
		 .reset(reset),
		 .clock(clock)
		);

endmodule
