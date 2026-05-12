module shifter(
	input PCLK,PRESET_n,ss_i,send_data_i,lsbfe_i,cpha_i,cpol_i,
	input miso_receive_sclk_posedge, miso_receive_sclk_negedge, mosi_send_sclk_posedge, mosi_send_sclk_negedge,
	input [7:0]data_mosi_i, 
	input miso_i, receive_data_i,
	output reg mosi_o,
	output [7:0]data_miso_o);


reg [7:0]shift_register, temp_reg;
reg [2:0]count, count1, count2, count3;

//8 bit MISO data, from SPI to APB slave interface 
assign data_miso_o = receive_data_i ? temp_reg : 8'h00;

//shift_register to store MOSI data to be transmitted, sent by APB slave interface to spi
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		shift_register <= 8'h00;
	else
		if(send_data_i)
			shift_register <= data_mosi_i;	
end

//miso counters count2/count3
always@(posedge PCLK, negedge PRESET_n) begin //1
	if(!PRESET_n) begin //2
		count2 <= 3'd0; //LSB first
		count3 <= 3'd7; //MSB first
	end //2 end
	else begin //3
		if(!ss_i)
			if(cpol_i^cpha_i)
				if(lsbfe_i)
					if(count2 <= 3'd7)
						if(miso_receive_sclk_negedge)
							count2 <= count2 + 1'b1;
						else begin //4
							count2 <= count2;
							count3 <= count3;
						end //4 end
					else
						count2 <= 3'd0;
				else begin // 5
					if(count3 >= 3'd0)
						if(miso_receive_sclk_negedge)
							count3 <= count3 - 1'b1;
						else begin //6
							count2 <= count2;
							count3 <= count3;
						end //6 end
					else
						count3 <= 3'd7;
				end //5 end
			else begin //7
				if(lsbfe_i)
					if(count2 <= 3'd7)
						if(miso_receive_sclk_posedge)
							count2 <= count2 + 1'b1;
						else begin //8
							count2 <= count2;
							count3 <= count3;
						end //8 end
					else
						count2 <= 3'd0;
				else begin //9
					if(count3 >= 3'd0)
						if(miso_receive_sclk_posedge)
							count3 <= count3 - 1'b1;
						else begin //10
							count2 <= count2;
							count3 <= count3;
						end //10 end
					else
						count3 <= 3'd7;
				end //9 end
				end // 7 end
		else begin //11
			count2 <= count2;
			count3 <= count3;
		end //11 end
	end //3 end
end //1 end

//temp_reg assignment for storing serial MISO data
always@(posedge PCLK, negedge PRESET_n) begin
	if(!PRESET_n)
		temp_reg <= 8'h00;
	else begin
		if(!ss_i)
			if(cpol_i^cpha_i)
				if(lsbfe_i)
					if(count2 <= 3'd7)
						if(miso_receive_sclk_negedge)
							temp_reg[count2] <= miso_i;
						else begin
							temp_reg <= temp_reg;
						end
					else
						temp_reg[count2] <= 1'd0;
				else begin
					if(count3 >= 3'd0)
						if(miso_receive_sclk_negedge)
							temp_reg[count3] <= miso_i;
						else begin
							temp_reg <= temp_reg;
						end
					else
						temp_reg[count3] <= 1'd0;
				end
			else begin
				if(lsbfe_i)
					if(count2 <= 3'd7)
						if(miso_receive_sclk_posedge)
							temp_reg[count2] <= miso_i;
						else begin
							temp_reg <= temp_reg;
						end
					else
						temp_reg[count2] <= 1'd0;
				else begin
					if(count3 >= 3'd0)
						if(miso_receive_sclk_posedge)
							temp_reg[count3] <= miso_i;
						else begin
							temp_reg <= temp_reg;
						end
					else
						temp_reg[count3] <= 1'd0;
				end
			end
		else begin
			temp_reg <= temp_reg;
		end
	end
end //always block end

//MOSI counters count and count1
always@(posedge PCLK, negedge PRESET_n) begin
	if(!PRESET_n) begin
		count <= 3'd0;
		count1 <= 3'd7;
	end
	else begin
		if(!ss_i)
			if(cpol_i^cpha_i)
				if(lsbfe_i)
					if(count <= 3'd7)
						if(mosi_send_sclk_negedge)
							count <= count + 1'b1;
						else begin
							count <= count;
							count1 <= count1;
						end
					else
						count <= 3'd0;
				else begin
					if(count1 >= 3'd0)
						if(mosi_send_sclk_negedge)
							count1 <= count1 - 1'b1;
						else begin
							count <= count;
							count1 <= count1;
						end
					else
						count1 <= 3'd7;
				end
			else begin
				if(lsbfe_i)
					if(count <= 3'd7)
						if(mosi_send_sclk_posedge)
							count <= count + 1'b1;
						else begin
							count <= count;
							count1 <= count1;
						end
					else
						count <= 3'd0;
				else begin
					if(count1 >= 3'd0)
						if(mosi_send_sclk_posedge)
							count1 <= count1 - 1'b1;
						else begin
							count <= count;
							count1 <= count1;
						end
					else
						count1 <= 3'd7;
				end
			end
		else begin
			count <= count;
			count1 <= count1;
		end
	end //PRESET_n == 1 block end
end //always block end

always@(posedge PCLK, negedge PRESET_n) begin
	if(!PRESET_n) begin
		mosi_o <= 1'b0;
	end
	else begin
		if(!ss_i)
			if(cpol_i^cpha_i)
				if(lsbfe_i)
					if(count <= 3'd7)
						if(mosi_send_sclk_negedge)
							mosi_o <= shift_register[count];
						else begin
							mosi_o <= mosi_o;
						end
					else
						mosi_o <= 1'd0;
				else begin
					if(count1 >= 3'd0)
						if(mosi_send_sclk_negedge)
							mosi_o <= shift_register[count1];
						else begin
							mosi_o <= mosi_o;
						end
					else
						mosi_o <= 1'd0;
				end
			else begin
				if(lsbfe_i)
					if(count <= 3'd7)
						if(mosi_send_sclk_posedge)
							mosi_o <= shift_register[count];
						else begin
							mosi_o <= mosi_o;
						end
					else
						mosi_o <= 1'd0;
				else begin
					if(count1 >= 3'd0)
						if(mosi_send_sclk_posedge)
							mosi_o <= shift_register[count1];
						else begin
							mosi_o <= mosi_o;
						end
					else
						mosi_o <= 1'd0;
				end
				end
		else begin
			mosi_o <= mosi_o;
		end
	end //PRESET_n == 1 block end
end //always block end
endmodule