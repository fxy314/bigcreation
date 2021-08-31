module time_diver(input wire clk, output reg wave);
		reg [31:0] counter;
		always @(posedge clk)
		begin 
			if(counter < 32'd250000000)
				begin
				counter <= counter + 1'b1;
				end
			else 
				begin
				counter <= 32'b0;
				wave <= ~wave;
				end
		end
endmodule
//clk_20hz 50ms时钟信号，用于判断按键除颤