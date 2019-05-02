module buffer #(parameter N = 16, ADDR_WIDTH = 4, BUFFER_SIZE = 4)
	(rxdata, rxfinish, txdata, txdone, send, rxmessage, txmessage, ack_rxmessage, ack_txmessage, clk);
	localparam MESSAGE_WIDTH = 2 * (ADDR_WIDTH + 1) + 4;
	input [7:0] rxdata;
	input rxfinish;
	output [7:0] txdata;
	output send;
	input txdone;
	input [MESSAGE_WIDTH-1:0] txmessage;
	output [MESSAGE_WIDTH-1:0] rxmessage;
	input ack_rxmessage;
	output reg ack_txmessage;
	input clk;


endmodule

