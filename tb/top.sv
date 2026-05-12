module top;

	import test_pkg::*;		
	import uvm_pkg::*;

	bit clock;
	initial begin
		clock = 1'b0;
		forever #10 clock = ~clock;
	end

	APB_interface apb_intrf(clock);
	SPI_interface spi_intrf(clock);
	
//	SPI DUV(apb_intrf,spi_intrf);
	
	SPI_core dut(
		.PCLK(apb_intrf.PCLK),
		.PRESET_n(apb_intrf.PRESETn),
		.PADDR_i(apb_intrf.PADDR),
		.PWRITE_i(apb_intrf.PWRITE),
		.PSEL_i(apb_intrf.PSEL),
		.PENABLE_i(apb_intrf.PENABLE),
		.PWDATA_i(apb_intrf.PWDATA),
		.PRDATA_o(apb_intrf.PRDATA),
		.PREADY_o(apb_intrf.PREADY),
		.PSLVERR_o(apb_intrf.PSLVERR),
		
		.ss_o(spi_intrf.SS),
		.sclk_o(spi_intrf.SCLK),
		.spi_interrupt_request_o(spi_intrf.spi_interrupt_request),
		.miso_i(spi_intrf.miso),
		.mosi_o(spi_intrf.mosi)
		);	


	initial begin
		uvm_config_db #(virtual APB_interface)::set(null,"*","APB interface",apb_intrf);
		uvm_config_db #(virtual SPI_interface)::set(null,"*","SPI interface",spi_intrf);
		
		run_test();	
	end
endmodule