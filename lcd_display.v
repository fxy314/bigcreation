module lcd_display(
clk,  reset_n,  velo,  peri_num, rs, rw, en,dat,LCD_N,LCD_P);  
input clk;  
input reset_n;
output [7:0] dat; 
output  rs,rw,en,LCD_N,LCD_P; 
 //tri en; 
 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [15:0] counter; 
 reg [4:0] current,next; 
 reg clkr; 
 reg [1:0] cnt; 
 parameter  set0=4'h0; 
 parameter  set1=4'h1; 
 parameter  set2=4'h2; 
 parameter  set3=4'h3; 
 parameter  dat0=4'h4; 
 parameter  dat1=4'h5; 
 parameter  dat2=4'h6; 
 parameter  dat3=4'h7; 
 parameter  dat4=4'h8; 
 parameter  dat5=4'h9; 
 parameter  dat6=4'hA; 
 parameter  dat7=4'hB; 
 parameter  dat8=4'hC; 
 parameter  dat9=4'hD; 
 parameter  dat10=4'hE; 
 parameter  nul=4'hF; 
 parameter  dat11=5'h10; 
 parameter  dat12=5'h11;
 parameter  dat13=5'h12;
 parameter  dat14=5'h13;
 parameter  dat15=5'h14;
 parameter  dat16=5'h15;
 parameter  dat17=5'h16;
 parameter  dat18=5'h17;
 parameter  dat19=5'h18;
 parameter  dat20=5'h19;
 parameter  dat21=5'h1A;
 parameter  dat22=5'h1B;
 parameter  dat23=5'h1C;
 parameter  dat24=5'h1D;
 parameter  dat25=5'h1E;
 parameter  dat26=5'h1F;

parameter frequency = 32'd500000;

reg [31:0] length;

reg [7:0] velo2;
reg [7:0] velo1;
reg [7:0] velo0;

reg [7:0] len4;
reg [7:0] len3;
reg [7:0] len2;
reg [7:0] len1;
reg [7:0] len0;
assign LCD_N=0;
assign LCD_P=1;



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
always @(posedge clk)      
	begin 
	  counter=counter+1; 
	  if(counter==16'h000f)  
	  clkr=~clkr; 
	end 
always @(posedge clkr) 
begin 
 current=next; 
  case(current) 
    set0:   begin  rs<=0; dat<=8'h31; next<=set1; end  //*??8???,2?,5*7*
    set1:   begin  rs<=0; dat<=8'h0C; next<=set2; end  //*????,???,???*/  
    set2:   begin  rs<=0; dat<=8'h6; next<=set3; end   //*??????,?????*/  
    set3:   begin  rs<=0; dat<=8'h1; next<=dat0; end   //*????*/    

    //???LCD????
    dat0:   begin  rs<=1; dat<="v"; next<=dat1; end 
    dat1:   begin  rs<=1; dat<="e"; next<=dat2; end 
    dat2:   begin  rs<=1; dat<="l"; next<=dat3; end 
    dat3:   begin  rs<=1; dat<="o"; next<=dat4; end 
    dat4:   begin  rs<=1; dat<=":"; next<=dat5; end 
    dat5:   begin  rs<=1; dat<=velo2; next<=dat6; end 
    dat6:   begin  rs<=1; dat<=velo1; next<=dat7; end 
    dat7:   begin  rs<=1; dat<=velo0; next<=dat8; end 
    dat8:   begin  rs<=1; dat<="m"; next<=dat9; end 
    dat9:   begin  rs<=1; dat<="/"; next<=dat10; end 
    dat10:  begin  rs<=1; dat<="s"; next<=dat11; end 
    dat11:  begin  rs<=1; dat<=" "; next<=dat12; end 
	 dat12:  begin  rs<=1; dat<="l";next<=dat13;end
	 dat13:	begin  rs<=1; dat<="e";next<=dat14;end
	 dat14:	begin  rs<=1; dat<="n";next<=dat15;end
	 dat15:  begin  rs<=1; dat<="g";next<=dat16;end
	 dat16:	begin  rs<=1; dat<="t";next<=dat17;end
	 dat17:  begin  rs<=1; dat<="h";next<=dat18;end
	 dat18:  begin  rs<=1; dat<=":";next<=dat19;end
	 dat19:  begin  rs<=1; dat<=len4;next<=dat20;end
	 dat20:  begin  rs<=1; dat<=len3;next<=dat21;end
	 dat21:  begin  rs<=1; dat<=len2;next<=dat22;end
	 dat22:  begin  rs<=1; dat<=".";next<=dat23;end
	 dat23:  begin  rs<=1; dat<=len1;next<=dat24;end
	 dat24:  begin  rs<=1; dat<=len0;next<=dat25;end
	 dat25:  begin  rs<=1; dat<="m";next<=nul;end
    //?????12??????????
     nul:   begin rs<=0;  dat<=8'h00;                    //??? ?? ????E ? ?? 
              if(cnt!=2'h2)  
                  begin  
                       e<=0;next<=set0;cnt<=cnt+1;  
                  end  
                   else  
                     begin next<=nul; e<=1; 
                    end    
              end 
   default:   next=set0; 
    endcase 
 end 
assign en=clkr|e; 
assign rw=0; 
endmodule  