class apb_txn extends uvm_sequence_item;
	rand bit PRESETn;
	bit PSEL,PENABLE;
	rand bit PWRITE;
	rand bit [2:0]PADDR;
	rand bit [7:0]PWDATA;
	bit [7:0]PRDATA;
	bit PREADY,PSLVERR;
	
	`uvm_object_utils_begin(apb_txn)
		`uvm_field_int(PRESETn,UVM_ALL_ON)
		`uvm_field_int(PSEL,UVM_ALL_ON)
		`uvm_field_int(PENABLE,UVM_ALL_ON)
		`uvm_field_int(PWRITE,UVM_ALL_ON)
		`uvm_field_int(PADDR,UVM_ALL_ON)
		`uvm_field_int(PWDATA,UVM_ALL_ON)
		`uvm_field_int(PRDATA,UVM_ALL_ON)
		`uvm_field_int(PREADY,UVM_ALL_ON)
		`uvm_field_int(PSLVERR,UVM_ALL_ON)
	`uvm_object_utils_end
	
	constraint valid_addr {	if(PWRITE)
					PADDR inside {[0:2],5};
				else
					PADDR inside {[0:3],5};
	}

	function new(string name="apb_txn");
		super.new(name);
	endfunction

	extern function void post_randomize();	
endclass

	function void apb_txn::post_randomize();
		bit [7:0] CR1_mask = 8'b1111_1111;
		bit [7:0] CR2_mask = 8'b0001_1011;
		bit [7:0] BR_mask = 8'b0111_0111;
		//bit [7:0] Status_mask = 8'b1011_0000;

		case(PADDR)
			3'b000 : PWDATA = CR1_mask & PWDATA;
			3'b001 : PWDATA = CR2_mask & PWDATA;
			3'b010 : PWDATA = BR_mask & PWDATA;
		endcase
	endfunction