class spi_sequence extends uvm_sequence #(spi_txn);
	`uvm_object_utils(spi_sequence)
	
	extern function new(string name = "spi_sequence");
	extern task body();
endclass

	function spi_sequence::new(string name = "spi_sequence");
		super.new(name);
	endfunction
	
	task spi_sequence::body();
		req = spi_txn::type_id::create("req");

		start_item(req);
		assert(req.randomize());
		finish_item(req);
	endtask