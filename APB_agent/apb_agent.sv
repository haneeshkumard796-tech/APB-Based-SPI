class apb_agent extends uvm_agent;

	`uvm_component_utils(apb_agent)

	apb_driver apb_drvh;
	apb_monitor apb_monh;
	apb_sequencer apb_seqrh;

	function new(string name = "apb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		apb_drvh = apb_driver::type_id::create("apb_drvh",this);
		apb_monh = apb_monitor::type_id::create("apb_monh",this);
		apb_seqrh = apb_sequencer::type_id::create("apb_seqrh",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_drvh.seq_item_port.connect(apb_seqrh.seq_item_export);
	endfunction



endclass