class APB_agent_top extends uvm_env;
	`uvm_component_utils(APB_agent_top)
	
	apb_agent_config apb_cfgh;
	apb_agent apb_agent_h[];
	
	extern function new(string name="APB_agent_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern function void connect_phase(uvm_phase phase);	
endclass
	
	function APB_agent_top::new(string name="APB_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void APB_agent_top::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_agent_config)::get(this,"","apb_config",apb_cfgh)) begin
		`uvm_fatal(get_type_name(),"Getting Failed") end
		apb_agent_h = new[apb_cfgh.no_of_agents];
		foreach(apb_agent_h[i])
			apb_agent_h[i] = apb_agent::type_id::create($sformatf("apb_agent_h[%0d]",i),this);	
	endfunction