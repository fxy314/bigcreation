module pulse_module(input wire reset_n, input wire key,input wire clk,output reg  sq_pulse );
	reg clk_20hz;
	reg key_now;
	reg key_delay;
	reg key_down;//key_down=1  则说明按键被按下
	reg [31:0] cnt_20hz;
	reg [63:0] cnt_width;
	//reg sq_pulse;
	integer WAVE_WIDTH = 32'd50000;//脉冲长度暂定为1ms
	initial 
		begin 
			cnt_20hz <= 32'b0;
			cnt_width <= 32'b0;
			sq_pulse <= 1'b0;
		end
	
//以下一段代码产生clk_20hz 50ms信号，用于判断按键除颤
	always @(posedge clk or negedge reset_n)
		begin 
			if(!reset_n)
				begin
					cnt_20hz <= 32'd0;
					clk_20hz <= 32'd0;
				end
			else if(cnt_20hz == 32'd2500000)
				begin
					cnt_20hz <= 32'd0;
					clk_20hz <= 1'd1;//clk_20hz每50ms只有一个clk周期为高电平
				end
			else 
				begin
					clk_20hz <= 1'd0;
					cnt_20hz <= cnt_20hz + 1'b1;
				end
		end

//以下一段用于判断按键是否按下，按下标志为key_down信号产生50ms的高电平
	always @(posedge clk or negedge reset_n)
		begin
			if(!reset_n)
				begin
					key_now <= 1'b1;
					key_delay <= 1'b1;
				end
			else if(clk_20hz)
				begin
					key_delay <= key_now;
					key_now <= key;
				end
			else
					key_now <= key_now;
		end

	always @(posedge clk)
		begin
			if(key_now == 1'b0 && key_delay == 1'b1)
				begin
					key_down <= 1'b1;
				end
			else
				begin
					key_down <= 1'b0;
				end
		end

//以下一段代码，在key_down为高电平时产生一个长度为WAVE_WIDTH的高电平输出sq_pulse
	always @(posedge clk or negedge reset_n)
		begin
			if(!reset_n)
				begin
					cnt_width <= 32'b0;
					sq_pulse <= 1'b0;
				end
			else if(key_down == 1'b1 && cnt_width < WAVE_WIDTH)
				begin
					cnt_width <= cnt_width + 1'b1;
					sq_pulse <= 1'b1;
				end
			else
				begin
					cnt_width <= 1'b0;
					sq_pulse <= 1'b0;
				end
		end

endmodule
					
	