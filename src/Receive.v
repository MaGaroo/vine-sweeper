module Receive #(parameter clockperbit = 10) (rxdata, rxfinish, rx, clock, reset);
	parameter initialclockperbit = clockperbit * 3 / 2;
	input clock, reset, rx;
	output reg rxfinish;
	output reg [7:0] rxdata;

	integer remaining_clocks;
	reg [0:3] current_bit;
	reg ready;

	initial
	begin
		rxfinish <= 1'b0;
		rxdata <= 8'b0;
		ready <= 1'b1;
	end
	
	always @(posedge clock or posedge reset)
	begin
		if (reset)
		begin
			rxfinish <= 1'b0;
			rxdata <= 8'b0;
			ready <= 1'b1;
		end
		else if (~ready)
		begin
			if (remaining_clocks == 0)
			begin
				if (current_bit < 8)
				begin
					rxdata[current_bit] <= rx;
					rxfinish <= 1'b0;
				end
				else if (current_bit == 8)
				begin
					ready <= 1'b1;
					rxfinish <= 1'b1;
				end
				remaining_clocks <= clockperbit - 1;
				current_bit <= current_bit + 1;
			end
			else
			begin
				remaining_clocks <= remaining_clocks - 1;
				rxfinish <= 1'b0;
			end
		end
		else if (~rx)
		begin
			ready <= 1'b0;
			rxfinish <= 1'b0;
			remaining_clocks <= initialclockperbit - 1;
			current_bit <= 4'b0;
		end
		else
			rxfinish <= 1'b0;
	end

endmodule

