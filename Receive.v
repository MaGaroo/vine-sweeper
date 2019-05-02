module Receive #(parameter clockperbit) (rxdata, rxfinish, rx, clock, reset);
	parameter initialclockperbit = clockperbit * 2 / 3;
	input clock, reset, rx;
	output reg rxfinish;
	output reg [7:0] rxdata;

	integer remaining_clocks;
	reg [0:3] current_bit;
	
	always @(posedge reset or posedge clock)
	begin
		if (reset)
		begin
			// TODO: What to do? :D
			rxfinish <= 1'b1;
		end
		else if (~rxfinish)
		begin
			if (remaining_clocks == 0)
			begin
				if (~current_bit[0])
				begin
					rxdata[current_bit] <= rx;
					current_bit <= current_bit + 1'b1;
				end
				else
					rxfinish <= 1'b1;
				remaining_clocks <= clockperbit - 1'b1;
			end
			else
				remaining_clocks <= remaining_clocks - 1'b1;
		end
		else if (~rx)
		begin
			rxfinish <= 1'b0;
			remaining_clocks <= initialclockperbit - 1'b1;
			current_bit <= 3'b0;
		end
	end

endmodule

