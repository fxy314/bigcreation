module time_measure(
clk,
reset_n,
wave,
data_out,
);
input          clk;
input          reset_n;
input          wave; //采样信号;
output reg[31:0]  data_out; //结果输出;
parameter      frequency_clk=50; //50MHz，时钟频率;
reg            wave_now; //存储wave;
reg            wave_rev;//输入信号的反向延迟
reg           wave_pulse; //采样信号上升沿识别;
integer     t1;
integer     t2;
wire[31:0]     t_dif;
reg[31:0]       con_period; //时钟循环计数器，假定信号和时钟同步//输入;
reg[1:0]         regN; //所测时间标记


	initial 
		begin
			wave_now <= 1'b0;
			wave_rev <= 1'b0;
			con_period <= 32'b0;
			regN <= 2'b0;
			t1 <= 32'b0;
			t2 <= 32'b0;
		end

		
	always@(posedge clk or negedge reset_n)
		if(!reset_n)
			begin
				wave_now <= 1'b0;
				wave_rev <= 1'b0 ;
				con_period <= 32'b0;
			end
		else 
			begin
				wave_rev <= ~wave_now;
				wave_now <= wave;
				con_period <= con_period + 32'b1;
			end

//以下一段标记两次的上升沿到达时间
	always @(posedge clk or negedge reset_n)
		begin
			data_out <= t2-t1;
		if(!reset_n)
			begin
				regN <= 32'b0;
				t1 <= 32'b0;
				t2 <= 32'b0;
				data_out <= 32'b0;
			end
		else if(wave_pulse)
			begin
				regN <= regN + 2'b1;
				if(regN == 2'b01)
					begin
						t1 <= con_period; //第一次上升沿到达时间/时钟周期数
					end
				else if(regN == 2'b10)
					begin
						t2 <= con_period;//第二次上升沿到达时间/时钟周期数
						//regN <= 2'b0;
					end
			end
	end
always @(posedge clk)
	begin
		wave_pulse = wave_now&wave_rev;
	end

endmodule

