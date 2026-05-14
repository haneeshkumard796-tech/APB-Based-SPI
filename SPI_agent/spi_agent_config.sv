class spi_agent_config extends uvm_object;

	`uvm_object_utils(spi_agent_config)
	
	int no_of_agents=1;
	virtual SPI_interface spi_vif;
	
	function new(string name="spi_agent_config");
		super.new(name);
	endfunction
endclass