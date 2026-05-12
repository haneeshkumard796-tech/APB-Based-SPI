class spi_sequencer extends uvm_sequencer #(spi_txn);
	`uvm_component_utils(spi_sequencer)
	
	extern function new(string name="spi_sequencer",uvm_component parent);
endclass

	function spi_sequencer::new(string name="spi_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction
