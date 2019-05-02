module Receive #(parameter clockperbit = 10) (rxdata, rxfinish, rx, clock, reset);
	parameter initialclockperbit = clockperbit * 2 / 3;
	input clock, reset, rx;
	output reg rxfinish;
	output reg [7:0] rxdata;

	integer remaining_clocks;
	reg [0:3] current_bit;
	reg idle;
	
	always @(posedge reset or posedge clock)
	begin
		if (reset)
		begin
			// TODO: What to do? :D
			idle <= 1'b1;
		end
		else if (~idle)
		begin
			if (remaining_clocks == 0)
			begin
				if (current_bit < 8)
				begin
					rxdata[current_bit] <= rx;
				end
				else if (current_bit == 9)
				begin
					idle <= 1'b1
					rxfinish <= 1'b1;
				end
				remaining_clocks <= clockperbit - 1'b1;
				current_bit <= current_bit + 4'b1;
			end
			else
				remaining_clocks <= remaining_clocks - 1'b1;
		end
		else if (~rx)
		begin
			rxfinish <= 1'b0;
			idle <= 1'b0;
			remaining_clocks <= initialclockperbit - 1'b1;
			current_bit <= 4'b0;
		end
	end

endmodule

