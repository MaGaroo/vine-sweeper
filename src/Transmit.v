module Transmit #(parameter clockperbit = 10)
(txdata, txdone, send, tx, reset, clock);

	parameter clockperbitminus = clockperbit - 1;
	input reset, clock;
	input [7:0] txdata;
	input send;
	output reg tx;
	output reg txdone;
	
	reg idle;
	
	reg [3:0] current_bit;
	integer remaining_clocks;
	
	initial
	begin
		idle <= 1'b1;
		tx <= 1'b1;
		txdone <= 1'b1;
	end
	
	always @(posedge reset or posedge clock)
	begin
		if (reset)
		begin
			idle <= 1'b1;
			tx <= 1'b1;
			txdone <= 1'b1;
		end
		else
			if (~idle) 
				if (remaining_clocks == 0)
				begin
					if (current_bit == 9)
					begin
						idle <= 1'b1;
						tx <= 1'b1;
					end
					else
					begin
						if (current_bit == 8) 
						begin
							txdone <= 1'b1;
							tx <= 1'b1;
							remaining_clocks <= 0;
						end
						else
						begin
							tx <= txdata[current_bit];
							remaining_clocks <= clockperbitminus;
						end
						current_bit <= current_bit + 1;
					end
				end
				else 
					remaining_clocks <= remaining_clocks - 1;
	
			else 
				if (send) 
				begin
					txdone <= 1'b0;
					idle <= 1'b0;
					current_bit <= 4'b0000;
					remaining_clocks <= clockperbitminus;
					tx <= 1'b0;
				end
	end
	
	
endmodule
