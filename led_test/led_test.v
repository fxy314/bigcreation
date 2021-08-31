module led_test( input clk, input reset_n, input [3:0] key, output reg [3:0] led);
reg [23:0] period;
reg [1:0] status;
always @(posedge clk or negedge reset_n)
	begin if(!reset_n)
				period <= 24'd0;
			else if(period < 24'd1000_0000)
				period <= period + 1'd1;
			else 
				period <= 24'd0;
	end
	
always @(posedge clk or negedge reset_n)
	begin if(!reset_n)
				status <= 2'b0;
			else if(period == 24'd1000_0000)
				status <= status + 1'b1;
			else 
				status <= status;
	end

always @(posedge clk or negedge reset_n)
	begin if(!reset_n)
				led <=  4'b0;
			else if(key[0] == 1'b0)
				case(status)
					2'd0: led <= 4'b1000;
					2'd1: led <= 4'b0100;
					2'd2: led <= 4'b0010;
					2'd3: led <= 4'b0001;
				endcase
			else if(key[1] == 1'b0)
				case(status)
					2'd0: led <= 4'b0001;
					2'd1: led <= 4'b0010;
					2'd2: led <= 4'b0100;
					2'd3: led <= 4'b1000;
				endcase
			else if(key[2] == 1'b0)
				case(status)
					2'd0: led <= 4'b1111;
					2'd1: led <= 4'b0000;
					2'd2: led <= 4'b1111;
					2'd3: led <= 4'b0000;
				endcase
			else if(key[3] == 1'b0)
							led <= 4'b1111;
			else 
							led <= 4'b0000;
	end
endmodule