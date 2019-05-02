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
	
	// Queue variables
	reg [MESSAGE_WIDTH-1:0] readmsgfromcell, readmsgfromuart, writemsgfromcell, writemsgfromuart;
	reg fromcell_readen, fromcell_writeen, fromcell_readack, fromcell_writeack, fromuart_readen, fromuart_writeen, fromuart_readack, fromuart_writeack;
	
	Queue #(MESSAGE_WIDTH, 4) msgs_from_cell
		(.read(readmsgfromcell),
		 .read_en(fromcell_readen),
		 .read_ack(fromcell_readack),
		 .write(writemsgfromcell),
		 .write_en(fromcell_writeen),
		 .write_ack(fromcell_writeack),
		 .clock(clk)
		);

	Queue #(MESSAGE_WIDTH, 4) msgs_from_uart
		(.read(readmsgfromuart),
		 .read_en(fromuart_readen),
		 .read_ack(fromuart_readack),
		 .write(writemsgfromuart),
		 .write_en(fromuart_writeen),
		 .write_ack(fromuart_writeack),
		 .clock(clk)
		);

	reg [7:0] ri, rj, rstatus, ti, tj, tstatus;
	reg readytosendtouart;
	integer rxcnt, txcnt;

	reg [MESSAGE_WIDTH-1:0] rxmsg_fromuart, rxmsg_fromcell,  txmsg_touart, txmsg_tocell;

	initial begin
		rxcnt = 0;
		readytosendtouart = 0;
		// TODO initialize queue variables
	end


	always @(posedge clk)
	begin

		// receive i, j, status from UART
		if (rxfinish && rxcnt < 3)
		begin
			case (rxcnt)
				0: 	ri <= rxdata;
				1: 	rj <= rxdata;
				2: 	rstatus <= rxdata;
			endcase
			if (rxcnt == 2)
			begin 
				writemsgfromuart <= {ri[ADDR_WIDTH-1:0], 1'b0, rj[ADDR_WIDTH-1:0], 1'b0, rstatus[3:0]};
				fromuart_writeen <= 1;
				if (fromuart_writeack == 1'b1)
				begin
					rxcnt = 0;
					fromuart_writeen = 0;
				end
			end
		end

		/*if (rxcnt == 3)
		begin
			if (~fromuart_writeen)
			begin
				writemsgfromuart <= {ri[ADDR_WIDTH:0], rj[ADDR_WIDTH:0], rstatus[3:0]};
				fromuart_writeen <= 1'b1;
			end
			if (fromuart_writeack)
			begin
				rxcnt = 0;
			end
		end*/

		// transmit i, j, status from Queue to UART
		// TODO ti, tj, tstatus assignment from Queue
		
		
		if (fromcell_readen) 
		begin
			case (txcnt):
			0:
			begin
				read_ack <= 1'b0;
				txdata <= {readmsgfromcell[ADDR_WIDTH-1:0], (8-ADDR_WIDTH)'b0};
				send <= 1'b1;
				txcnt <= 1;
				
			end
			1:
			begin 
				if (txdone == 1'b1) 
				begin
					txcnt <= 2;
				end
			end
			2:
			begin
				txdata <= {readmsgfromcell[2*ADDR_WIDTH-1:ADDR_WIDTH], (8-ADDR_WIDTH)'b0};
				send <= 1'b1;
				txcnt <= 3;
			end
			3:
			begin
				if (txdone == 1'b1) 
				begin
					txcnt <= 4;
				end
			end
			4:
			begin
				txdata <= readmsgfromcell[MESSAGE_WIDTH-1:MESSAGE_WIDTH-4];
				send <= 1'b1;
				txcnt <= 5;
			end
			5:
				if (txdone == 1'b1)
				begin
					fromcell_readack <= 1'b1;
					txcnt <= 0;
				end
			casez: txcat <= 0;
		end
		
		if (txcnt < 3)
		begin
			if (~readytosendtouart)
			begin
				if (fromcell_readen)
				begin
					fromcell_readack <= 1;
					readytosendtouart <= 1;
					tstatus <= readmsgfromcell[3:0];
					tj <= readmsgfromcell[ADDR_WIDTH+4:4];
					ti <= readmsgfromcell[MESSAGE_WIDTH-1:ADDR_WIDTH+5];
				end
			end
			
			if (readytosendtouart)
			begin
				fromcell_readack <= 0;
				case (txcnt)
				begin
					0: 	begin
							send = 1;

						end
				end
			end
			else
			begin
					
			end
		end
		

		// transmit MESSAGE from cell to buffer
		if (ack_txmessage)
		begin
			// TODO push txmessage to Queue
			ack_txmessage <= 0;
		end
		else
			ack_txmessage <= 1;

		// cell receives MESSAGE from buffer
		if (~ack_rxmessage)
		begin
			// TODO pop message from Queue to send it 
		end

		

//		به به دوباره آمد فصل بهاری بلبل چقدر میخواند با بیقراری چقدر قشنگ و زیباست آینه و شمعدون سیر و سماق و سرکه قرمه و فسنجون 
//		مشقای امشب تو خوبی و مهربونی است پس بنویس هزار بار تا بشه نمرهات بیست
	end
endmodule


