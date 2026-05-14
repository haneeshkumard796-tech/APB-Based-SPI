class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)
	uvm_analysis_port #(apb_txn) apb_mon_port;
		
	virtual APB_interface.APB_MON_MP apb_vif;	

	apb_agent_config apb_cfgh;

	extern function new(string name="apb_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();

endclass
	function apb_monitor::new(string name="apb_monitor",uvm_component parent);
		super.new(name,parent);
		apb_mon_port = new("apb_mon_port",this);
	endfunction

		function void apb_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(apb_agent_config)::get(this,"","apb_config",apb_cfgh);
	endfunction

	function void apb_monitor::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_vif = apb_cfgh.apb_vif;
	endfunction

	task apb_monitor::run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			collect_data();
		end
	endtask

	task apb_monitor::collect_data();
		apb_txn txn;
		txn = apb_txn::type_id::create("txn");
		
		//Waiting till the core is set to Enable Phase
		wait(apb_vif.APB_MON_CB.PREADY) begin
		txn.PRESETn = apb_vif.APB_MON_CB.PRESETn;
		txn.PSEL = apb_vif.APB_MON_CB.PSEL;
		txn.PENABLE = apb_vif.APB_MON_CB.PENABLE;
		txn.PADDR = apb_vif.APB_MON_CB.PADDR;
		txn.PWRITE = apb_vif.APB_MON_CB.PWRITE;
		txn.PREADY = apb_vif.APB_MON_CB.PREADY; 
		txn.PSLVERR = apb_vif.APB_MON_CB.PSLVERR;
	
		//Checking for PWRITE
		if(txn.PWRITE)
			txn.PWDATA = apb_vif.APB_MON_CB.PWDATA;
		else
			txn.PRDATA = apb_vif.APB_MON_CB.PRDATA;

		apb_mon_port.write(txn);
		`uvm_info(get_type_name(),$sformatf("The Sampled Txn from Monitor: %s",txn.sprint),UVM_LOW)	
		end
		repeat(2) @(apb_vif.APB_MON_CB);
	endtask