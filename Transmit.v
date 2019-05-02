module Transmit #(parameter clockperbit)
(txdata, txdone, send, tx, reset, clock);

	parameter clockperbitminus = clockperbit - 1;
	input reset, clock;
	input [7:0] txdata;
	input send;
	output reg tx;
	output reg txdone;
	
	reg [3:0] current_bit;
	reg [3:0] remaining_clocks;
	
	reg idle;
	
	always @(posedge reset or posedge clock)
	begin
		if (reset)
		begin
			idle <= 1'b1;
		end
		else if (send)
		begin
			if (~idle) 
			begin
				if (remaining_clocks == 0)
				begin
					if (current_bit == 4'b1001)
					begin
						txdone <= 1b'1;
					end
					else
					begin
						if (current_bit == 4'b1000) 
						begin 
							tx <= 1'b1;
						end
						else
						begin
							tx <= txdata[current_bit];
						end
						current_bit <= current_bit + 1'b1;
						remaining_clocks <= clockperbitminus;
					end
				end
				else 
					remaining_clocks <= remaining_clocks - 1;
					
			end
			else 
				if (tx) 
				begin
					idle <= 1'b0;
					txdone <= 1'b0;
					current_bit = 4'b0000;
					remaining_clocks <= remaining_clocks
					tx <= 1'b0;
				end
		end
	end
	
	
endmodule
