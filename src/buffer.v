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
	integer rxmessagecnt;

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


		
		// Buffer To UART
		if (fromcell_readen) 
		begin
			case (txcnt):
			0:
			begin
				fromcell_readack <= 1'b0;
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
		
		//Buffer to Cell
		if(fromuart_readen)
		begin
			case (rxmessagecnt)
			begin
				0:
				begin
					fromuart_readack <= 1'b0;
					rxmessage <= readmsgfromuart;
					rxmessagecnt <= 1;
				end
				1:
				begin
					if (ack_rxmessage)
					begin
						fromuart_readack <= 1'b1;
						rxmessagecnt <= 0;
					end
				end
			end
			
		end
		
		
		if (txmessage[MESSAGE_WIDTH-1:MESSAGE_WIDTH-4] != 15)
		begin
			fromcell_writeen <= 1'b1;
			writemsgfromcell <= txmessage;
			
		end
		
		

		

//		به به دوباره آمد فصل بهاری بلبل چقدر میخواند با بیقراری چقدر قشنگ و زیباست آینه و شمعدون سیر و سماق و سرکه قرمه و فسنجون 
//		مشقای امشب تو خوبی و مهربونی است پس بنویس هزار بار تا بشه نمرهات بیست
	end
endmodule


