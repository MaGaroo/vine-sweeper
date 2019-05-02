module UART #(parameter clkperbit)
(rx, send, clock, reset, tx, txdata, rxdata, rxfinish, txdone);
	input rx , clock, reset, send;
	input[7:0] txdata; 
	output tx, rxfinish, txdone; 
	output[7:0] rxdata; 


endmodule
