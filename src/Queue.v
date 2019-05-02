module Queue #(parameter msg_width, parameter max_msg) (read, write_ack, write, read_ack);
	output [max_msg * msg_width - 1:0] read;
	output write_ack;
	input [max_msg * msg_width - 1:0] write;
	input read_ack;
	
	
endmodule
