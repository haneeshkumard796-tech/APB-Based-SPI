class apb_base_seq extends uvm_sequence #(apb_txn);
	`uvm_object_utils(apb_base_seq)
	
	bit [7:0]ctrl;
	function new(string name = "apb_base_seq");
		super.new(name);
	endfunction
	
	task body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name,"CR1_value",ctrl))
			`uvm_fatal(get_type_name(),"Getting CR 1 Value unsuccesful")
	endtask
endclass : apb_base_seq

class seq_cpol_cpha_00 extends apb_base_seq;
	`uvm_object_utils(seq_cpol_cpha_00)

	function new(string name = "seq_cpol_cpha_00");
		super.new(name);
	endfunction

	task body();
		super.body();
		req = apb_txn::type_id::create("req");
		
		repeat(1) begin
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //dummy read onto Data Register
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == ctrl;}); //Writing CR1 value
		finish_item(req);
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == 8'b0001_1000;}); //Writing CR2 value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == 8'b0000_0001;}); //Writing Baud Rate value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;}); //Writing Data Register value
		finish_item(req);

	/*	start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b000;}); // read onto any Register
		finish_item(req);
		*/	
		end
	endtask

endclass : seq_cpol_cpha_00

class seq_cpol_cpha_01 extends apb_base_seq;
	`uvm_object_utils(seq_cpol_cpha_01)

	function new(string name = "seq_cpol_cpha_01");
		super.new(name);
	endfunction

	task body();
		super.body();
		req = apb_txn::type_id::create("req");
		
		repeat(1) begin
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //dummy read onto Data Register
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == ctrl;}); //Writing CR1 value
		finish_item(req);
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == 8'b0001_1000;}); //Writing CR2 value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == 8'b0000_0001;}); //Writing Baud Rate value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;}); //Writing Data Register value
		finish_item(req);

		
		end
	endtask

endclass : seq_cpol_cpha_01


class seq_cpol_cpha_10 extends apb_base_seq;
	`uvm_object_utils(seq_cpol_cpha_10)

	function new(string name = "seq_cpol_cpha_10");
		super.new(name);
	endfunction

	task body();
		super.body();
		req = apb_txn::type_id::create("req");
		
		repeat(1) begin
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //dummy read onto Data Register
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == ctrl;}); //Writing CR1 value
		finish_item(req);
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == 8'b0001_1000;}); //Writing CR2 value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == 8'b0000_0001;}); //Writing Baud Rate value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101; PWDATA inside {[8'd128:8'hff]}; }); //Writing Data Register value
		finish_item(req);

		
		end
	endtask

endclass : seq_cpol_cpha_10


class seq_cpol_cpha_11 extends apb_base_seq;
	`uvm_object_utils(seq_cpol_cpha_11)

	function new(string name = "seq_cpol_cpha_11");
		super.new(name);
	endfunction

	task body();
		super.body();
		req = apb_txn::type_id::create("req");
		
		repeat(1) begin
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;}); //dummy read onto Data Register
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b000; PWDATA == ctrl;}); //Writing CR1 value
		finish_item(req);
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == 8'b0001_1000;}); //Writing CR2 value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b010; PWDATA == 8'b0000_0001;}); //Writing Baud Rate value
		finish_item(req);

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101; PWDATA inside {[8'h00:8'd127]};}); //Writing Data Register value
		finish_item(req);

		
		end
	endtask

endclass : seq_cpol_cpha_11


class low_power_en_seq extends apb_base_seq;
	`uvm_object_utils(low_power_en_seq)

	bit spiswai;
	bit [7:0]ctrl2;
	function new(string name = "low_power_en_seq");
		super.new(name);
	endfunction

	task body();
		req = apb_txn::type_id::create("req");
	
		spiswai = 1'b1;
		ctrl2 = {6'b000110,spiswai,1'b0};
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == ctrl2;}); //Writing CR2 value
		finish_item(req);
		
	endtask
endclass

class low_power_dis_seq extends apb_base_seq;
	`uvm_object_utils(low_power_dis_seq)

	bit spiswai;
		
	function new(string name = "low_power_dis_seq");
		super.new(name);
	endfunction

	task body();
		req = apb_txn::type_id::create("req");
	
		spiswai = 1'b0;
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b001; PWDATA == {6'b000110,spiswai,1'b0};}); //Writing CR2 value
		finish_item(req);
		
	endtask
endclass

class data_seq extends apb_base_seq;
	`uvm_object_utils(data_seq)

	function new(string name = "data_seq");
		super.new(name);
	endfunction

	task body();
		req = apb_txn::type_id::create("req");
		
		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b1; PADDR == 3'b101; PWDATA inside {[8'h00:8'd127]};}); //Writing Data Register value
		finish_item(req);

	endtask
endclass


class read_seq extends apb_base_seq;
	`uvm_object_utils(read_seq)
	
	function new(string name = "read_seq");
		super.new(name);
	endfunction

	task body();
		req = apb_txn::type_id::create("req");
		

		start_item(req);
		assert(req.randomize() with {PRESETn == 1'b1; PWRITE == 1'b0; PADDR == 3'b101;}); // read Data Register
		finish_item(req);
	endtask
endclass