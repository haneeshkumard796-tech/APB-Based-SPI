module SPI_core(
input PCLK,PRESET_n,
input [2:0]PADDR_i,
input PWRITE_i,PSEL_i,PENABLE_i,
input [7:0]PWDATA_i,
input miso_i,
output ss_o,sclk_o,spi_interrupt_request_o,mosi_o,
output [7:0]PRDATA_o,
output PREADY_o,
output PSLVERR_o
);

//wire for monitoring outputs
//wire sclk;
wire [11:0]BaudRateDivisor;
wire [7:0]data_mosi;
wire [7:0]data_miso;
wire [2:0]sppr,spr;
wire [1:0]spi_mode;
//wire miso_receive_sclk_posedge;
//wire miso_receive_sclk_negedge;
//wire mosi_send_sclk_posedge;
//wire mosi_send_sclk_negedge;
//wire receive_data_o,ss_o;
//wire tip_o;


//instantiation
Baud_rate_generator Baud_rate_generate(PCLK,PRESET_n,cpol,spiswai,spi_mode,spr,sppr,ss_o,cpha, 
			sclk_o, BaudRateDivisor, miso_receive_sclk_posedge, miso_receive_sclk_negedge,
	       		mosi_send_sclk_posedge, mosi_send_sclk_negedge);

slave_control_select slave_select(PCLK,PRESET_n,mstr,spiswai,spi_mode,send_data,
			BaudRateDivisor, receive_data, ss_o, tip);

shifter shifter_logic(PCLK,PRESET_n,ss_o,send_data,lsbfe,cpha,cpol,miso_receive_sclk_posedge, miso_receive_sclk_negedge,mosi_send_sclk_posedge, mosi_send_sclk_negedge,data_mosi, miso_i, receive_data,mosi_o,data_miso);

APB_slave_interface APB_slave_inter(PCLK,PRESET_n,PADDR_i,PWRITE_i,PSEL_i,PENABLE_i,PWDATA_i,ss_o,data_miso,
receive_data,tip,PRDATA_o,mstr,cpol,cpha,lsbfe,spiswai,sppr,spr, spi_interrupt_request_o, PREADY_o, PSLVERR_o, send_data,data_mosi,spi_mode);


endmodule