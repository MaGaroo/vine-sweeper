module Transmiter #(parameter clockperbit)
(txdata, txdone, send, tx, reset, clock);
	input reset, clock;
	input [7:0] txdata;
	input send;
	output reg tx;
	output reg txdone;
	
	
endmodule
