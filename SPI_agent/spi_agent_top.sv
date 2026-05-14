class SPI_agent_top extends uvm_env;
	`uvm_component_utils(SPI_agent_top)
	
	spi_agent_config spi_cfgh;
	SPI_agent spi_agent_h[];
	
	extern function new(string name="SPI_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern function void connect_phase(uvm_phase phase);	
endclass
	
	function SPI_agent_top::new(string name="SPI_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void SPI_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(spi_agent_config)::get(this,"","spi_config",spi_cfgh)) begin
		`uvm_fatal(get_type_name(),"Getting Failed") end
		spi_agent_h = new[spi_cfgh.no_of_agents];
		foreach(spi_agent_h[i])
			spi_agent_h[i] = SPI_agent::type_id::create($sformatf("spi_agent_h[%0d]",i),this);	
	endfunction