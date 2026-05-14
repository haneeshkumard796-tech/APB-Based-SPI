//`define SPI_APB_DATA_WIDTH=8
//`define SPI_REG_WIDTH=8
//`define SPI_APB_ADDR_WIDTH=3

module APB_slave_interface(
	input PCLK,PRESET_n,
	input [2:0]PADDR_i,
	input PWRITE_i,
	input PSEL_i,
	input PENABLE_i,
	input [7:0]PWDATA_i,
	input ss_i,
	input [7:0]miso_data_i,
	input receive_data_i,
	input tip_i,
	output reg [7:0]PRDATA_o,
	output mstr_o,cpol_o,cpha_o,lsbfe_o,spiswai_o,
	output [2:0]sppr_o,spr_o,
	output reg spi_interrupt_request_o, 
	output PREADY_o, PSLVERR_o, 
	output reg send_data_o,
	output reg [7:0]mosi_data_o,
	output reg [1:0]spi_mode_o);


reg [1:0]ps,ns; //APB states
reg [1:0]next_mode; //SPI modes

reg [7:0]spi_cr_1; //control register 1
reg [7:0]spi_cr_2; //control register 3
reg [7:0]spi_br;   //baud rate regsiter
reg [7:0]spi_sr;   //status register
reg [7:0]spi_dr;   //data register

wire spie,sptie,spif,sptef,modf,modfen,spe,ssoe;
wire wr_enb,rd_enb;

//assigning flags and wires from SPI registers
assign spe = spi_cr_1[6];
assign spie = spi_cr_1[7];
assign sptie = spi_cr_1[5];
assign mstr_o = spi_cr_1[4];
assign cpol_o = spi_cr_1[3];
assign cpha_o = spi_cr_1[2];
assign ssoe = spi_cr_1[1];
assign lsbfe_o = spi_cr_1[0];

assign spiswai_o = spi_cr_2[1];
assign modfen = spi_cr_2[4];

assign sppr_o = spi_br[6:4];
assign spr_o = spi_br[2:0];

assign modf = (!ss_i && mstr_o && modfen && !ssoe);

parameter IDLE = 2'b00,
	  SETUP = 2'b01,
	  ENABLE = 2'b10;

parameter spi_run = 2'b00,
	  spi_wait = 2'b01,
	  spi_stop = 2'b10;

parameter cr2_mask = 8'b00011011,
	  br_mask = 8'b01110111;

//present state sequential logic for APB
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		ps<=IDLE;
	else
		ps<=ns;
end

//next state logic(Combinational logic)
always@(ps or PSEL_i or PENABLE_i) begin
	case(ps)
		IDLE : if(PSEL_i && !PENABLE_i) ns = SETUP;
		       else ns = IDLE;
		SETUP : if(PSEL_i && !PENABLE_i) ns = SETUP;
       		  	else if (PSEL_i && PENABLE_i) ns = ENABLE;
			else ns = IDLE;
		ENABLE :if(PSEL_i) ns = SETUP;
			else ns = IDLE;	
		/*ENABLE : if(PSEL_i && PENABLE_i) ns = ENABLE; //psel == 1'b1 ns = setup else ns = idle
			 else if(PSEL_i && !PENABLE_i) ns = SETUP;
			 else ns = IDLE;*/
	default : ns = IDLE;
endcase
end

//present state sequential logic for spi modes
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		spi_mode_o <= spi_run;
	else
		spi_mode_o <= next_mode;	
end

//next state combo logic for spi modes
always@(spi_mode_o or spe or spiswai_o) begin
	case(spi_mode_o)
		spi_run : if(!spe) next_mode = spi_wait;
			  else next_mode = spi_run;
		spi_wait : if(spe) next_mode = spi_run;
			   else if(spiswai_o) next_mode = spi_stop;
			   else next_mode = spi_wait;
		spi_stop : if(spe) next_mode = spi_run;
			   else if (!spiswai_o) next_mode = spi_wait;
			   else next_mode = spi_stop;
	default : next_mode = spi_run;
	endcase
end

//PREADY and PSLERR_o
assign PREADY_o = (ps == ENABLE);
assign PSLVERR_o = (ps == ENABLE) ? ~tip_i : 1'b0;

//write and read enable
assign wr_enb = ((ps == ENABLE) && (PWRITE_i));
assign rd_enb = ((ps == ENABLE) && (!PWRITE_i));

//Write operation to SPI registers
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n) begin
		spi_cr_1 <= 8'd4;
		spi_cr_2 <= 8'd0;
		spi_br <= 8'd0;
	end
	else 
	begin
		if(wr_enb)
			case(PADDR_i)
				3'd0: spi_cr_1 <= PWDATA_i;
				3'd1: spi_cr_2 <= cr2_mask  & PWDATA_i;
				3'd2: spi_br <= br_mask & PWDATA_i;
			endcase
		/*else begin
		spi_cr_1 <= 8'd4;
		spi_cr_2 <= 8'd0;
		spi_br <= 8'd0;
		end*/
	end
end

//APB read
always@(*) begin
	if(rd_enb) begin
		case(PADDR_i)
			3'd0: PRDATA_o = spi_cr_1;
			3'd1: PRDATA_o = spi_cr_2;
			3'd2: PRDATA_o = spi_br;
			3'd3: PRDATA_o = spi_sr;
			3'd5: PRDATA_o = spi_dr;
		default PRDATA_o = 8'd0;
		endcase
	end
	else begin
		PRDATA_o = 8'd0;
	end
end

//spi_interrupt_request_o
always@(*) begin
if(!spie && !sptie)
	spi_interrupt_request_o = 1'b0;
else if(spie && !sptie)
	spi_interrupt_request_o = spif | modf;
else if(!spie && sptie)
	spi_interrupt_request_o = sptef;
else
	spi_interrupt_request_o = (spif | sptef | modf);
end

//Updating flags of Status register
assign sptef = (spi_dr == 8'd0);
assign spif = (spi_dr != 8'd0);

always@(*) begin
	if(!PRESET_n)
		spi_sr = 8'b0010_0000;
	else
		spi_sr = {spif,1'b0,sptef,modf,4'b0};
end


//send_data_o
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		send_data_o <= 1'b0;
	else
		if(wr_enb)
			send_data_o <= 1'b0;
		else
			if(spi_dr == PWDATA_i && spi_dr != miso_data_i && (spi_mode_o == spi_run || spi_mode_o == spi_wait))
				send_data_o <= 1'b1;
			else
				send_data_o <= 1'b0;
				/*if((spi_mode_o == spi_run || spi_mode_o == spi_wait) && receive_data_i)
					send_data_o <= 1'b0;
				else
					send_data_o <= 1'b0;*/
end

//mosi
always@(posedge PCLK or negedge PRESET_n) begin
	if(!PRESET_n)
		mosi_data_o <= 8'b0;
	else
		//if(wr_enb)
			if(spi_dr == PWDATA_i && spi_dr != miso_data_i && (spi_mode_o == spi_run || spi_mode_o == spi_wait))
				mosi_data_o <= spi_dr;
			else
				mosi_data_o <= mosi_data_o;
		//else
			//mosi_data_o <= mosi_data_o;
end

//spi_dr
always@(posedge PCLK or negedge PRESET_n) begin
if(!PRESET_n)
		spi_dr <= 8'b0;
else
	if(wr_enb)
		if(PADDR_i == 3'b101)
			spi_dr <= PWDATA_i;
		else
			spi_dr <= spi_dr;
	else
		if(spi_dr == PWDATA_i && spi_dr != miso_data_i && (spi_mode_o == spi_run || spi_mode_o == spi_wait))
			spi_dr <= 8'd0;
		else
			if((spi_mode_o == spi_run || spi_mode_o == spi_wait) && receive_data_i)
				spi_dr <= miso_data_i;
			else
				spi_dr <= spi_dr;
end
endmodule