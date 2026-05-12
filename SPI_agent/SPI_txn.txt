class spi_txn extends uvm_sequence_item;
	logic SS,spi_interrupt_request;
	logic [7:0]mosi;
	rand logic [7:0]miso;
	`uvm_object_utils_begin(spi_txn)
		`uvm_field_int(SS,UVM_ALL_ON)
		`uvm_field_int(mosi,UVM_ALL_ON)
		`uvm_field_int(miso,UVM_ALL_ON)
		`uvm_field_int(spi_interrupt_request,UVM_ALL_ON)
	`uvm_object_utils_end
	
	function new(string name="spi_txn");
		super.new(name);
	endfunction	
endclass