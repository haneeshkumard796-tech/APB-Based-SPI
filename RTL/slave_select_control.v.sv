module slave_control_select(
	input PCLK,PRESET_n,mstr_i,spiswai_i,
	input [1:0]spi_mode_i,
	input send_data_i,
	input [11:0]BaudRateDivisor_i,
	output receive_data_o,
	output reg ss_o,
	output tip_o);

wire [15:0]target_s;
reg [15:0]count_s;
reg rcv_s;

assign target_s = 16*(BaudRateDivisor_i/2);
assign tip_o = ~ss_o;
assign receive_data_o = rcv_s;

always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		ss_o <= 1'b1;
	else
		if(!spiswai_i && mstr_i && (spi_mode_i == 2'b00 || spi_mode_i == 2'b01))
			if(send_data_i)
				ss_o <=1'b0;
			else
				if(count_s >= (target_s))
				//if(count_s > (target_s - 1'b1))
					ss_o <= 1'b1;
				else
					ss_o <= 1'b0;
		else
			ss_o <= 1'b1;
end

always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		count_s <= 16'hffff;
	else
		if(!spiswai_i && mstr_i && (spi_mode_i == 2'b00 || spi_mode_i == 2'b01))
			if(send_data_i)
				count_s <= 16'h0;
			else
				if(count_s < (target_s)) //count_s < (target_s - 1'b1)
					count_s <= count_s + 1'b1;
				else
					count_s <= 16'hffff;
		else
			count_s <= 16'hffff;
end

always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		rcv_s <= 1'b0;
	else
		if(!spiswai_i && mstr_i && (spi_mode_i == 2'b00 || spi_mode_i == 2'b01))
			if(send_data_i)
				rcv_s <= 1'b0;
			else
				if(count_s == (target_s)) // count_s == (target_s - 1'b1)
					rcv_s <= 1'b1;
				else
					rcv_s <= 1'b0;
		else
			rcv_s <= 1'b0;	

end

endmodule

