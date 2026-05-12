class SPI_agent extends uvm_agent;
	`uvm_component_utils(SPI_agent)
	
	spi_sequencer spi_seqrh;
	spi_driver spi_drvh;
	spi_monitor spi_monh;

	extern function new(string name="SPI_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

	function SPI_agent::new(string name="SPI_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void SPI_agent::build_phase(uvm_phase phase);
		spi_monh = spi_monitor::type_id::create("spi_monh",this);
		spi_seqrh = spi_sequencer::type_id::create("spi_seqrh",this);
		spi_drvh = spi_driver::type_id::create("spi_drvh",this);
	endfunction

	function void SPI_agent::connect_phase(uvm_phase phase);
		spi_drvh.seq_item_port.connect(spi_seqrh.seq_item_export);
	endfunction