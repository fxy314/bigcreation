module wave_velo_modify(
input wire clk, 
input wire clk_20hz,
input wire reset_n, 
input wire key_up, 
input wire key_down,
output reg [7:0] velo);
reg key_up_now;
reg key_up_delay;
reg key_down_now;
reg key_down_delay;
reg key_up_value;
reg key_down_value;

	initial
		begin
			velo <= 8'd170;//默认波速为170m/s
			key_up_now <= 1'b1;
			key_up_delay <= 1'b1;
			key_down_now <= 1'b1;
			key_down_delay <= 1'b1;
			key_up_value <= 1'b0;
			key_down_value <= 1'b0;
		end

		always @(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					begin
						key_up_now <= 1'b1;
						key_up_delay <= 1'b1;
						key_down_now <= 1'b1;
						key_down_delay <= 1'b1;
					end
				else if(clk_20hz)
					begin
						key_up_delay <= key_up_now;
						key_up_now <= key_up;
						key_down_delay <= key_down_now;
						key_down_now <= key_down;
					end

			end
			
		always @(posedge clk or negedge reset_n)
			begin				
				if(!reset_n)
					begin
						key_up_value <= 1'b0;
						key_down_value <= 1'b0;
					end
				else if(key_up_now == 1'b0 && key_up_delay == 1'b1)
					begin
						key_up_value <= 1'b1;
					end
				else if(key_down_now == 1'b0 && key_down_delay == 1'b1)
					begin
						key_down_value <= 1'b1;
					end
			end
			
		always @(posedge clk or negedge reset_n)
			begin
				if(!reset_n)
					begin
						velo <= 8'd170;
					end
				else if(key_up_value == 1'b1)
					begin
						velo <= velo + 8'd1;
					end
				else if(key_down_value == 1'b1)
					begin
						velo <= velo - 8'd1;
					end
			end

endmodule
