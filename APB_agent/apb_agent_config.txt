class apb_agent_config extends uvm_object;

	`uvm_object_utils(apb_agent_config)
	
	int no_of_agents=1;
	virtual APB_interface apb_vif;

	function new(string name="apb_agent_config");
		super.new(name);
	endfunction
endclass