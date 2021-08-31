 
// Company  : 
// Engineer : 
// -----------------------------------------------------------------------------
// https://blog.csdn.net/qq_33231534    PHF's CSDN blog
// -----------------------------------------------------------------------------
// Create Date    : 2020-09-07 15:48:40
// Revise Data    : 2020-09-08 09:53:32
// File Name      : lcd.v
// Target Devices : XC7Z015-CLG485-2
// Tool Versions  : Vivado 2019.2
// Revision       : V1.1
// Editor         : sublime text3, tab size (4)
// Description    : LCD1602 driver
 
module lcd_test(
	input				clk			,
	input				rst_n		,
	
	output	reg			lcd_rs		,
	output	wire		lcd_rw		,
	output	reg			lcd_en		,
	output	reg	[7:0]	lcd_data	,
	input    [7:0] velo,
	input 	[31:0] peri_num
	);
 
	reg	[17:0]	cnt				;
	reg	[3:0]	state_c			;
	reg	[3:0]	state_n			;
	reg	[4:0]	char_cnt		;
	reg	[7:0]	data_display	;

	parameter frequency = 32'd500000;
	localparam
		IDLE			= 4'd0	,
		INIT 			= 4'd1	,
		S0				= 4'd2	,
		S1				= 4'd3	,
		S2				= 4'd4	,
		S3				= 4'd5	,
		ROW1_ADDR		= 4'd6	,
		WRITE			= 4'd7	,
		ROW2_ADDR		= 4'd8	,
		stop			= 4'd9	;
 
 
	assign lcd_rw = 1'b0;
 
reg [31:0] length;

reg [7:0] velo2;
reg [7:0] velo1;
reg [7:0] velo0;

reg [7:0] len4;
reg [7:0] len3;
reg [7:0] len2;
reg [7:0] len1;
reg [7:0] len0;


always @(posedge clk)
	begin 
		length <= (velo * peri_num )/(2'd2*frequency);
	end

always @(posedge clk)
	begin
		velo0 <= (velo % 4'd10) + 8'h30;
		velo1 <= ((velo / 4'd10) % 4'd10) + 8'h30;
		velo2 <= ((velo / 8'd100) % 4'd10) + 8'h30;
	end

always @(posedge clk)
	begin
		len4 <= ((length) / 16'd10000) % 4'd10 + 8'h30;
		len3 <= ((length) / 10'd1000) % 4'd10 + 8'h30;
		len2 <= ((length) / 8'd100) % 4'd10 + 8'h30;
		len1 <= ((length) / 4'd10) % 4'd10 + 8'h30;
		len0 <= length % 4'd10 + 8'h30;
	end
	
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			cnt <= 17'd0;
		end
		else begin
			if (cnt==17'd100_000 - 1) begin
				cnt <= 17'd0;
			end
			else begin
				cnt <= cnt + 1'b1;
			end
		end
	end

	

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			lcd_en <= 0;
		end
		else if (cnt==17'd50_000 - 1) begin
			lcd_en <= 1;
		end
		else if (cnt==17'd100_000 - 1) begin
			lcd_en <= 0;
		end
	end
 
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			char_cnt <= 0;
		end
		else if (state_c==WRITE && cnt==17'd50_000 - 1) begin
			if (char_cnt==5'd24) begin
				char_cnt <= 5'd0;
			end
			else begin
				char_cnt <= char_cnt + 1'b1;
			end
		end
	end
 
	always @(*) begin
		case(char_cnt)
			5'd0: data_display   = "v";
			5'd1: data_display   = "e";
			5'd2: data_display   = "l";
			5'd3: data_display   = "o";
			5'd4: data_display   = ":";
			5'd5: data_display   = velo2;
			5'd6: data_display   = velo1;
			5'd7: data_display   = velo0;
			5'd8: data_display   = "m";
			5'd9: data_display   = "/";
			5'd10: data_display  = "s";
			5'd11: data_display  = "l";
			5'd12: data_display  = "e";
			5'd13: data_display  = "n";
			5'd14: data_display  = "g";
			5'd15: data_display  = "t";
			5'd16: data_display  = "h";
			5'd17: data_display  = ":";
			5'd18: data_display  = len4;
			5'd19: data_display  = len3;
			5'd20: data_display  = len2;
			5'd21: data_display  = ".";
			5'd22: data_display  = len1;
			5'd23: data_display  = len0;
			5'd24: data_display  = "m";
			default:data_display = "P";
		endcase
	end
 
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state_c <= IDLE;
		end
		else if(cnt==17'd50_000 - 1) begin
			state_c <= state_n;
		end
	end
 
	reg	[19:0]	cnt_15ms;
	reg		flag	;
	always@(posedge clk or negedge rst_n)begin
		if (!rst_n) begin
			cnt_15ms <= 0;
		end
		else if (state_c == IDLE) begin
			cnt_15ms <= cnt_15ms + 1'b1;
		end
	end
 
	always@(posedge clk or negedge rst_n)begin
		if (!rst_n) begin
			flag <= 0;
		end
		else if (state_c==IDLE && cnt_15ms==20'd750000) begin
			flag <= 1;
		end
	end
 
	always @(*) begin
		case(state_c)
			IDLE		:
				begin
					if (flag) begin
						state_n = INIT;
					end
					else begin
						state_n = state_c;
					end
				end
			INIT 	:
				begin
					state_n = S0;
				end
			S0  	:
				begin
					state_n = S1;
				end
			S1  	:
				begin
					state_n = S2;
				end
			S2  	:
				begin
					state_n = S3;
				end
			S3  	:
				begin
					state_n = ROW1_ADDR;
				end
			ROW1_ADDR:
				begin
					state_n = WRITE;
				end
			WRITE		:
				begin
					if (char_cnt==5'd10) begin
						state_n = ROW2_ADDR;
					end
					else if (char_cnt==5'd24) begin
						state_n = stop;
					end
					else begin
						state_n = state_c;
					end
				end
			ROW2_ADDR:
				begin
					state_n = WRITE;
				end
			stop		:
				begin
					state_n = stop;
				end
			default:state_n = IDLE;
		endcase
	end
 
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			lcd_data <= 8'd0;
		end
		else begin
			case(state_c)
				IDLE		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				INIT 		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				S0			:begin lcd_data <= 8'h08; lcd_rs <= 0;end
				S1			:begin lcd_data <= 8'h01; lcd_rs <= 0;end
				S2			:begin lcd_data <= 8'h06; lcd_rs <= 0;end
				S3			:begin lcd_data <= 8'h0c; lcd_rs <= 0;end
				ROW1_ADDR	:begin lcd_data <= 8'h80; lcd_rs <= 0;end
				WRITE		:begin lcd_data <= data_display; lcd_rs <= 1;end
				ROW2_ADDR	:begin lcd_data <= 8'hc0; lcd_rs <= 0;end
				stop		:begin lcd_data <= 8'h38; lcd_rs <= 0;end
				default:;
			endcase
		end
	end
endmodule