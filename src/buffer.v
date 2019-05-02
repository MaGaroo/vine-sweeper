module Buffer #(parameter N = 16, ADDR_WIDTH = 4, BUFFER_SIZE = 4)
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
	reg [7:0] ri, rj, rstatus, ti, tj, tstatus;
	integer rxcnt;

	reg [MESSAGE_WIDTH-1:0] recieved_message, message_totransmit;

	initial begin
		rxcnt = 0;
	end


	always @(posedge clk)
	begin
		// receive i, j, status from UART
		if (rxfinish)
		begin
			case (rxcnt)
				0: 	ri <= rxdata;
				1: 	rj <= rxdata;
				2: 	rstatus <= rxdata;
			endcase
			rxcnt <= rxcnt + 1;
			if (rxcnt == 3) 
			begin
				// TODO push to Queue
			end
		end

		// transmit i, j, status from Queue to UART
		// TODO ti, tj, tstatus assignment from Queue	
		

		// transmit MESSAGE from cell to buffer
		if (ack_txmessage)
		begin
			//push txmessage to Queue
			ack_txmessage <= 0;
		end
		else
			ack_txmessage <= 1;

		// cell receives MESSAGE from buffer
		if (~ack_rxmessage)
		begin
			//pop message from Queue to send it 
		end

		

//		به به دوباره آمد فصل بهاری بلبل چقدر میخواند با بیقراری چقدر قشنگ و زیباست آینه و شمعدون سیر و سماق و سرکه قرمه و فسنجون 
//		مشقای امشب تو خوبی و مهربونی است پس بنویس هزار بار تا بشه نمرهات بیست
	end
endmodule


