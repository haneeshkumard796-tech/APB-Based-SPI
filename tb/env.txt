class env extends uvm_env;
	`uvm_component_utils(env)
	
	env_config env_cfgh;
	apb_agent_config apb_cfgh;
	spi_agent_config spi_cfgh;	

	APB_agent_top apb_agent_top_h;
	SPI_agent_top spi_agent_top_h;
	scoreboard sb[];

	extern function new(string name="env",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass
	
	function env::new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void env::build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_agent_top_h = APB_agent_top::type_id::create("apb_agent_top_h",this);
		spi_agent_top_h = SPI_agent_top::type_id::create("spi_agent_top_h",this);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfgh)) begin
		`uvm_fatal(get_type_name(),"Getting Environment Config Failed")
	end
		apb_cfgh = apb_agent_config::type_id::create("apb_cfgh");
		spi_cfgh = spi_agent_config::type_id::create("spi_cfgh");
		
		apb_cfgh.apb_vif = env_cfgh.apb_vif;
		spi_cfgh.spi_vif = env_cfgh.spi_vif;

		uvm_config_db #(apb_agent_config)::set(this,"*","apb_config",apb_cfgh);
		uvm_config_db #(spi_agent_config)::set(this,"*","spi_config",spi_cfgh);
		
		sb = new[env_cfgh.no_of_duts];
	
		foreach(sb[i])
		sb[i] = scoreboard::type_id::create($sformatf("sb[%0d]",i),this);
	endfunction
	
	function void env::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_agent_top_h.apb_agent_h[0].apb_monh.apb_mon_port.connect(sb[0].fifo_apb.analysis_export);
		spi_agent_top_h.spi_agent_h[0].spi_monh.spi_mon_port.connect(sb[0].fifo_spi.analysis_export);
	endfunction