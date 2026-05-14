interface SPI_interface(input bit clock);

	logic SCLK,SS,mosi,miso,spi_interrupt_request;
	
/*	clocking SPI_DRV_CB_00_11@(negedge SCLK);
		output miso;
		input SS,spi_interrupt_request;
	endclocking
*/
	clocking SPI_DRV_CB@(posedge clock);
		output miso;
		input SS,SCLK,spi_interrupt_request;
	endclocking

	clocking SPI_MON_CB@(posedge clock);
		default input #1 output #0;
		input SS,SCLK,miso,mosi,spi_interrupt_request;
	endclocking	
/*
	clocking SPI_MON_CB_01_10@(negedge SCLK);
		input SS,miso,mosi,spi_interrupt_request;
	endclocking
*/
//	modport SPI_DRV_MP_00_11(clocking SPI_DRV_CB_00_11);
	modport SPI_DRV_MP(clocking SPI_DRV_CB);
	modport SPI_MON_MP(clocking SPI_MON_CB);
//	modport SPI_MON_MP_01_10(clocking SPI_MON_CB_01_10);

//	modport SPI_DUT_MP(output SCLK, SS, mosi, spi_interrupt_request, input miso);			
endinterface
