module Baud_rate_generator(PCLK,PRESET_n,cpol_i,spiswai_i,spi_mode_i,spr_i,sppr_i,ss_i,cphase_i, 
			sclk_o, BaudRateDivisor_o, miso_receive_sclk_posedge, miso_receive_sclk_negedge,
	       		mosi_send_sclk_posedge, mosi_send_sclk_negedge);

parameter RUN = 2'b00,
	  WAIT = 2'b01,
	  STOP = 2'b10; 
//input ports
input PCLK,PRESET_n,cpol_i,spiswai_i;
input [1:0]spi_mode_i;
input [2:0]spr_i,sppr_i;
input ss_i,cphase_i;

//output ports
output reg sclk_o;
output reg [11:0]BaudRateDivisor_o;
output reg miso_receive_sclk_posedge;
output reg miso_receive_sclk_negedge;
output reg mosi_send_sclk_posedge;
output reg mosi_send_sclk_negedge;

//internals signals for SCLK polarity and baud rate controller
wire pre_sclk_s;
reg [11:0]count_s;

//12 bit baud control computation
always@(sppr_i or spr_i)
	BaudRateDivisor_o = (sppr_i+3'd1)*(2**(spr_i+3'd1));

//internal SCLK signal assigned  
assign pre_sclk_s = cpol_i ? 1'b1 : 1'b0;

//seqential block
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		count_s <= 12'd0;
		sclk_o <= pre_sclk_s;
	end
	else if (!ss_i && !spiswai_i && (spi_mode_i == RUN || spi_mode_i == WAIT)) begin
		if(count_s == ((BaudRateDivisor_o/2) -1)) begin
			sclk_o <= ~sclk_o;
			count_s <= 12'd0;
		end
		else
			count_s <= count_s + 12'd1;
	end
	else begin
		sclk_o <= pre_sclk_s;
		count_s <= 12'd0;
	end
end

//MISO Flags
//always@(cpol_i or cphase_i or count_s or sclk_o or PRESET_n or spiswai_i) begin
always@(posedge PCLK or negedge PRESET_n) begin
if(!PRESET_n) begin
	miso_receive_sclk_posedge <= 1'b0;
	miso_receive_sclk_negedge <= 1'b0;
end 
else begin
	if ((!cphase_i && cpol_i) || (cphase_i && !cpol_i)) begin
		if(sclk_o && !ss_i) begin
			if(count_s == ((BaudRateDivisor_o/2) - 2'b01)) begin
				miso_receive_sclk_negedge <= 1'b1;
				miso_receive_sclk_posedge <= 1'b0;
			end
			else begin
				miso_receive_sclk_negedge <= 1'b0;
				miso_receive_sclk_posedge <= 1'b0;
			end
		end
		else begin
			miso_receive_sclk_negedge <= 1'b0;
			miso_receive_sclk_posedge <= 1'b0;
		end
	end
	else //((cphase_i && cpol_i) || (!cphase_i && !cpol_i)) 
	begin
		if(!sclk_o && !ss_i) begin
			if(count_s == ((BaudRateDivisor_o/2) - 2'b01)) begin
				miso_receive_sclk_posedge <= 1'b1;
				miso_receive_sclk_negedge <= 1'b0;
			end
			else begin
				miso_receive_sclk_posedge <= 1'b0;
				miso_receive_sclk_negedge <= 1'b0;
			end
		end
		else begin
			miso_receive_sclk_posedge <= 1'b0;
			miso_receive_sclk_negedge <= 1'b0;
		end
	end
end
end

//MOSI Flags
//always@(cpol_i or cphase_i or count_s or BaudRateDivisor_o or sclk_o or PRESET_n or spiswai_i) begin
always@(posedge PCLK or negedge PRESET_n) begin
if(!PRESET_n) begin
	mosi_send_sclk_posedge <= 1'b0;
	mosi_send_sclk_negedge <= 1'b0;
end
else begin
	if ((!cphase_i && cpol_i) || (cphase_i && !cpol_i)) begin
		if(sclk_o && !ss_i) begin
			if(count_s == ((BaudRateDivisor_o/2) -2'b10)) begin
				mosi_send_sclk_negedge <= 1'b1;
				mosi_send_sclk_posedge <= 1'b0;
				end
			else begin
				mosi_send_sclk_negedge <= 1'b0;
				mosi_send_sclk_posedge <= 1'b0;
				end
		end
		else begin
			mosi_send_sclk_negedge <= 1'b0;
			mosi_send_sclk_posedge <= 1'b0;
		end	
	end
	else //((cphase_i && cpol_i) || (!cphase_i && !cpol_i)) 
	begin
		if(!sclk_o && !ss_i) begin
			if(count_s == ((BaudRateDivisor_o/2) -2'b10)) begin
				mosi_send_sclk_posedge <= 1'b1;
				mosi_send_sclk_negedge <= 1'b0;
			end
			else begin
				mosi_send_sclk_posedge <= 1'b0;
				mosi_send_sclk_negedge <= 1'b0;
			end
		end
		else begin
			mosi_send_sclk_posedge <= 1'b0;
			mosi_send_sclk_negedge <= 1'b0;
		end
	end
end
end

endmodule
