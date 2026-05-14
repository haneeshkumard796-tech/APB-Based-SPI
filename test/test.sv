class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	
	env envh;	
	env_config env_cfgh;
	

	extern function new(string name="base_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);
endclass
	function base_test::new(string name="base_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void base_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_cfgh = env_config::type_id::create("env_cfgh");
		
		if(!uvm_config_db #(virtual APB_interface)::get(this,"","APB interface",env_cfgh.apb_vif))
		`uvm_fatal(get_type_name(),"Getting APB interface Failed")
		
		if(!uvm_config_db #(virtual SPI_interface)::get(this,"","SPI interface",env_cfgh.spi_vif))
		`uvm_fatal(get_type_name(),"Getting SPI interface Failed")	

		uvm_config_db #(env_config)::set(this,"*","env_config",env_cfgh);
		envh = env::type_id::create("envh",this);
	endfunction
	
	function void base_test::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction


class test_cpol_cpha_00 extends base_test;
	`uvm_component_utils(test_cpol_cpha_00)

	bit [7:0]ctrl;
	bit cpol,cpha,lsbfe;
	seq_cpol_cpha_00 seqh; //for configuring apb register
	spi_sequence spi_seqh;	//for peripheral miso
	read_seq read_seqh;	//for reading miso data from DR 

	extern function new(string name="test_cpol_cpha_00",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass
	function test_cpol_cpha_00::new(string name="test_cpol_cpha_00",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test_cpol_cpha_00::build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpol = 1'b0;
		cpha = 1'b0;
		lsbfe = 1'b0;
		ctrl = {4'b1111,cpol,cpha,1'b1,lsbfe};
		uvm_config_db #(bit[7:0])::set(this,"*","CR1_value",ctrl); //Setting Control Register 1 Value in test class
	endfunction

	function void test_cpol_cpha_00::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction

	task test_cpol_cpha_00::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
			seqh = seq_cpol_cpha_00::type_id::create("seqh");
			spi_seqh = spi_sequence::type_id::create("spi_seqh");
			read_seqh = read_seq::type_id::create("read_seqh");

			seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Configuring SPI core registers
			spi_seqh.start(envh.spi_agent_top_h.spi_agent_h[0].spi_seqrh); //SPI Agent seqr
			wait(env_cfgh.spi_vif.SS);
			
			read_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Performing APB read for Data register	
				
		phase.drop_objection(this);
	endtask












class test_cpol_cpha_01 extends base_test;
	`uvm_component_utils(test_cpol_cpha_01)

	bit [7:0]ctrl;
	bit cpol,cpha,lsbfe;
	seq_cpol_cpha_01 seqh;
	spi_sequence spi_seqh;	//for peripheral miso
	read_seq read_seqh;	//for reading miso data from DR 	

	extern function new(string name="test_cpol_cpha_01",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass
	function test_cpol_cpha_01::new(string name="test_cpol_cpha_01",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test_cpol_cpha_01::build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpol = 1'b0;
		cpha = 1'b1;
		lsbfe = 1'b0;
		ctrl = {4'b1111,cpol,cpha,1'b1,lsbfe};
		uvm_config_db #(bit[7:0])::set(this,"*","CR1_value",ctrl); //Setting Control Register 1 Value in test class

	endfunction

	function void test_cpol_cpha_01::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction

	task test_cpol_cpha_01::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
			seqh = seq_cpol_cpha_01::type_id::create("seqh");
			spi_seqh = spi_sequence::type_id::create("spi_seqh");
			read_seqh = read_seq::type_id::create("read_seqh");

			seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh);     //Sequence to configure SPI core
			spi_seqh.start(envh.spi_agent_top_h.spi_agent_h[0].spi_seqrh); //SPI Agent seqr
			wait(env_cfgh.spi_vif.SS);
			
			read_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Performing APB read for Data register			
		phase.drop_objection(this);

	endtask




class test_cpol_cpha_10 extends base_test;
	`uvm_component_utils(test_cpol_cpha_10)

	bit [7:0]ctrl;
	bit cpol,cpha,lsbfe;
	seq_cpol_cpha_10 seqh;
	spi_sequence spi_seqh;	//for peripheral miso
	read_seq read_seqh;	//for reading miso data from DR 	

	extern function new(string name="test_cpol_cpha_10",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass
	function test_cpol_cpha_10::new(string name="test_cpol_cpha_10",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test_cpol_cpha_10::build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpol = 1'b1;
		cpha = 1'b0;
		lsbfe = 1'b0;
		ctrl = {4'b1111,cpol,cpha,1'b1,lsbfe};
		uvm_config_db #(bit[7:0])::set(this,"*","CR1_value",ctrl); //Setting Control Register 1 Value in test class

	endfunction

	function void test_cpol_cpha_10::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction

	task test_cpol_cpha_10::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
			seqh = seq_cpol_cpha_10::type_id::create("seqh");
			spi_seqh = spi_sequence::type_id::create("spi_seqh");
			read_seqh = read_seq::type_id::create("read_seqh");

			seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh);     //Sequence to configure SPI core
			spi_seqh.start(envh.spi_agent_top_h.spi_agent_h[0].spi_seqrh); //SPI Agent seqr
			wait(env_cfgh.spi_vif.SS);
			
			read_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Performing APB read for Data register			
		phase.drop_objection(this);

	endtask

class test_cpol_cpha_11 extends base_test;
	`uvm_component_utils(test_cpol_cpha_11)

	bit [7:0]ctrl;
	bit cpol,cpha,lsbfe;
	seq_cpol_cpha_11 seqh;
	spi_sequence spi_seqh;	//for peripheral miso
	read_seq read_seqh;	//for reading miso data from DR 	

	extern function new(string name="test_cpol_cpha_11",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass
	function test_cpol_cpha_11::new(string name="test_cpol_cpha_11",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void test_cpol_cpha_11::build_phase(uvm_phase phase);
		super.build_phase(phase);
		cpol = 1'b1;
		cpha = 1'b1;
		lsbfe = 1'b0;
		ctrl = {4'b1111,cpol,cpha,1'b1,lsbfe};
//		ctrl = {4'b1111,cpol,cpha,2'b11};
		uvm_config_db #(bit[7:0])::set(this,"*","CR1_value",ctrl); //Setting Control Register 1 Value in test class

	endfunction

	function void test_cpol_cpha_11::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction

	task test_cpol_cpha_11::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
			seqh = seq_cpol_cpha_11::type_id::create("seqh");
			spi_seqh = spi_sequence::type_id::create("spi_seqh");
			read_seqh = read_seq::type_id::create("read_seqh");

			seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh);     //Sequence to configure SPI core
			spi_seqh.start(envh.spi_agent_top_h.spi_agent_h[0].spi_seqrh); //SPI Agent seqr
			wait(env_cfgh.spi_vif.SS);
			
			read_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Performing APB read for Data register			
		phase.drop_objection(this);

	endtask




class test_low_power_mode extends base_test;
	`uvm_component_utils(test_low_power_mode)

	bit [7:0]ctrl;
	bit spe,mstr,cpol,cpha,lsbfe;
	seq_cpol_cpha_00 seqh; //for configuring apb register
	spi_sequence spi_seqh;	//for peripheral miso
	read_seq read_seqh;	//for reading miso data from DR 
	low_power_en_seq lp_en_seqh;
	low_power_dis_seq lp_dis_seqh;

	extern function new(string name="test_low_power_mode",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

	function test_low_power_mode::new(string name="test_low_power_mode",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void test_low_power_mode::build_phase(uvm_phase phase);
		super.build_phase(phase);
		spe = 1'b0;
		mstr = 1'b1;
		cpol = 1'b0;
		cpha = 1'b0;
		lsbfe = 1'b0;
		ctrl = {1'b1,spe,1'b1,mstr,cpol,cpha,1'b1,lsbfe};
		uvm_config_db #(bit[7:0])::set(this,"*","CR1_value",ctrl); //Setting Control Register 1 Value in test class
	endfunction

	function void test_low_power_mode::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction

	task test_low_power_mode::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
			seqh = seq_cpol_cpha_00::type_id::create("seqh");
			spi_seqh = spi_sequence::type_id::create("spi_seqh");
			read_seqh = read_seq::type_id::create("read_seqh");
			lp_en_seqh = low_power_en_seq::type_id::create("lp_en_seqh");
			lp_dis_seqh = low_power_dis_seq::type_id::create("lp_dis_seqh");	
				
			seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Configuring SPI core registers			
			fork	
			spi_seqh.start(envh.spi_agent_top_h.spi_agent_h[0].spi_seqrh); //SPI Agent generates MISO to be driven 

			repeat(4) @(posedge env_cfgh.spi_vif.SCLK); //allow some bits to be sent and received
			join_any
			
			lp_en_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //enable low power mode
		
			repeat(20) @(env_cfgh.apb_vif.APB_DRV_CB);
			
			lp_dis_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh);			
			
			wait(env_cfgh.spi_vif.SS);

			read_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Performing APB read for Data register
		phase.drop_objection(this);
	endtask


class corner_test extends base_test;
	`uvm_component_utils(corner_test)
	
	bit [7:0]ctrl;
	bit spe,mstr,cpol,cpha,lsbfe;
	seq_cpol_cpha_00 seqh; //for configuring apb register
	spi_sequence spi_seqh;	//for peripheral miso
	read_seq read_seqh;	//for reading miso data from DR 
	data_seq data_reg_seq_h;

	extern function new(string name="corner_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass

	function corner_test::new(string name="corner_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void corner_test::build_phase(uvm_phase phase);
		super.build_phase(phase);
		spe = 1'b1;
		mstr = 1'b1;
		cpol = 1'b0;
		cpha = 1'b0;
		lsbfe = 1'b1;
		ctrl = {1'b1,spe,1'b1,mstr,cpol,cpha,1'b1,lsbfe};
		uvm_config_db #(bit[7:0])::set(this,"*","CR1_value",ctrl); //Setting Control Register 1 Value in test class
	endfunction

	function void corner_test::end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction

	task corner_test::run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
			seqh = seq_cpol_cpha_00::type_id::create("seqh");
			spi_seqh = spi_sequence::type_id::create("spi_seqh");
			read_seqh = read_seq::type_id::create("read_seqh");
			data_reg_seq_h = data_seq::type_id::create("data_reg_seq_h");
			seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Configuring SPI core registers			
		
				
			data_reg_seq_h.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //configuring Data register with second apb_data
			
			spi_seqh.start(envh.spi_agent_top_h.spi_agent_h[0].spi_seqrh); //SPI Agent seqr

			wait(env_cfgh.spi_vif.SS);
			//repeat(2)
			read_seqh.start(envh.apb_agent_top_h.apb_agent_h[0].apb_seqrh); //Performing APB read for Data register
				
		phase.drop_objection(this);		
	endtask