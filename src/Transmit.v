module Transmit #(parameter clockperbit = 10)
(txdata, txdone, send, tx, reset, clock);

	parameter clockperbitminus = clockperbit - 1;
	input reset, clock;
	input [7:0] txdata;
	input send;
	output reg tx;
	output reg txdone;
	
	reg [3:0] current_bit;
	reg [3:0] remaining_clocks;
	
	always @(posedge reset or posedge clock)
	begin
		if (reset)
		begin
			txdone <= 1'b1;
		end
		else
			if (~txdone) 
				if (remaining_clocks == 0)
				begin
					if (current_bit == 4'b1001)
						txdone <= 1'b1;
					else
					begin
						if (current_bit == 4'b1000) 
							tx <= 1'b1;
						else
							tx <= txdata[current_bit];
						current_bit <= current_bit + 1'b1;
						remaining_clocks <= clockperbitminus;
					end
				end
				else 
					remaining_clocks <= remaining_clocks - 1;
	
			else 
				if (send) 
				begin
					txdone <= 1'b0;
					current_bit = 4'b0000;
					remaining_clocks <= remaining_clocks;
					tx <= 1'b0;
				end
	end
	
	
endmodule
