module Queue #(parameter msg_bit_width = 24, parameter max_msg = 100) (read, read_en, write_ack, write, write_en, read_ack);
	localparam max_width = 1 << msg_bit_width;
	output reg [msg_bit_width - 1:0] read;
	output reg write_ack;
	output reg read_en;
	input [msg_bit_width - 1:0] write;
	input write_en;
	input read_ack;
//	input clock;
	
	reg [msg_bit_width - 1:0] q_in;
	reg [msg_bit_width - 1:0] q_out;
	
	reg [msg_bit_width - 1:0] q [0:max_msg - 1];


	always @(posedge write_en) 
	begin
	if (q_in != q_out)
		begin
			q[q_in] <= write;
			q_in <= (q_in + 1) % max_msg;
			write_ack <= 1'b1;
		end
		else
			write_ack <= 1'b0;
	end
	

	always @(posedge read_ack)
	begin
		if (q_in != q_out)
		begin
			read <= q[q_out];
			q_out <= (q_out + 1) % max_msg;
			read_en <= 1'b1;
		end
		else 
			read_en <= 1'b0;
	end
	
	
endmodule
