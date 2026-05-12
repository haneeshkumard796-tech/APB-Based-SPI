class apb_driver extends uvm_driver #(apb_txn);
	`uvm_component_utils(apb_driver)
	
	virtual APB_interface.APB_DRV_MP apb_vif;

	apb_agent_config apb_cfgh;
	
	extern function new(string name="apb_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(apb_txn req);
	extern task reset_dut(); 
endclass

	function apb_driver::new(string name="apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void apb_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(apb_agent_config)::get(this,"","apb_config",apb_cfgh))
		`uvm_fatal(get_type_name(),"Getting APB Config Failed")
	endfunction

	function void apb_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_vif = apb_cfgh.apb_vif;
	endfunction
	
	task apb_driver::run_phase(uvm_phase phase);
		super.run_phase(phase);
		reset_dut();
		forever begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();	
		end
	endtask

	task apb_driver::send_to_dut(apb_txn req);
		@(apb_vif.APB_DRV_CB);
		apb_vif.APB_DRV_CB.PRESETn <= req.PRESETn;
		apb_vif.APB_DRV_CB.PADDR <= req.PADDR;
		apb_vif.APB_DRV_CB.PWRITE <= req.PWRITE;	
		apb_vif.APB_DRV_CB.PSEL <= 1'b1;
		apb_vif.APB_DRV_CB.PENABLE <= 1'b0; //Puts APB into setup state
		if(req.PWRITE)
			apb_vif.APB_DRV_CB.PWDATA <= req.PWDATA;

		@(apb_vif.APB_DRV_CB);
		apb_vif.APB_DRV_CB.PENABLE <= 1'b1; //Puts APB into enable state
							
		wait(apb_vif.APB_DRV_CB.PREADY);
		if(!req.PWRITE) begin	
			req.PRDATA = apb_vif.APB_DRV_CB.PRDATA;
		end
		`uvm_info(get_type_name(),$sformatf("The Transaction driven is %s",req.sprint),UVM_LOW)
		//req.print();
		apb_vif.APB_DRV_CB.PSEL <= 1'b0;
		apb_vif.APB_DRV_CB.PENABLE <= 1'b0; //Puts APB into IDLE state		
	endtask
	
	task apb_driver::reset_dut(); //puts APB into IDLE state
		@(apb_vif.APB_DRV_CB);
		apb_vif.APB_DRV_CB.PRESETn <= 1'b0;
		@(apb_vif.APB_DRV_CB);
		apb_vif.APB_DRV_CB.PRESETn <= 1'b1;
		apb_vif.APB_DRV_CB.PSEL <= 1'b0;
		apb_vif.APB_DRV_CB.PENABLE <= 1'b0; //Puts APB into IDLE state		
	endtask