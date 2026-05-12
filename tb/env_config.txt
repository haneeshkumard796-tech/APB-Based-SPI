class env_config extends uvm_object;

	`uvm_object_utils(env_config)

	int no_of_duts = 1;

	virtual APB_interface apb_vif;
	virtual SPI_interface spi_vif;

	function new(string name="env_config");
		super.new(name);
	endfunction
endclass