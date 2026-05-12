class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	
	uvm_tlm_analysis_fifo #(apb_txn) fifo_apb;
	uvm_tlm_analysis_fifo #(spi_txn) fifo_spi;

	apb_txn a_txn;
	spi_txn s_txn;
	
	apb_txn apb_cov;
	spi_txn spi_cov;		
	
	extern function new(string name="scoreboard",uvm_component parent);
	extern task run_phase(uvm_phase phase);
	extern task compare_for_transmission(apb_txn a_txn);
	extern task compare_for_reception(apb_txn a_txn);
	
	covergroup apb_covergroup;
		option.per_instance = 1;
		Reset : coverpoint apb_cov.PRESETn { bins rst = {0,1};}
		
		Addr : coverpoint apb_cov.PADDR { bins addr[] = {0,1,2,3,5};}
		
		Selx : coverpoint apb_cov.PSEL { bins sel = {0,1};}

		Enable : coverpoint apb_cov.PENABLE { bins en = {0,1};}

		Write : coverpoint apb_cov.PWRITE { bins wr[] = {0,1};}

		Ready : coverpoint apb_cov.PREADY { bins rdy = {0,1};}

		Error : coverpoint apb_cov.PSLVERR { bins err = {0,1};}
	
		Wdata : coverpoint apb_cov.PWDATA {
						bins wdata_low = {[8'h00:8'd127]};
						bins wdata_high = {[8'd128:8'hff]};
						}
		Rdata : coverpoint apb_cov.PRDATA {
						bins rdata_low = {[8'h00:8'd127]};
						bins rdata_high = {[8'd128:8'hff]};
						}

		//crosses
		Selx_Enable : cross Selx,Enable;
		Selx_Enable_Ready : cross Selx,Enable,Ready;
	endgroup
	covergroup spi_covergroup;
		option.per_instance = 1;
		Slave_select : coverpoint spi_cov.SS { bins ss = {0,1};}
		
		miso_data : coverpoint spi_cov.miso {
						bins miso_low = {[8'h00:8'd127]};
						bins miso_high = {[8'd128:8'hff]};
						}
		mosi_data : coverpoint spi_cov.mosi {
						bins mosi_low = {[8'h00:8'd127]};
						bins mosi_high = {[8'd128:8'hff]};
						}	
	endgroup
endclass

	function scoreboard::new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		fifo_apb = new("fifo_apb",this);
		fifo_spi = new("fifo_spi",this);
		apb_covergroup  = new;
		spi_covergroup  = new;
	endfunction
	
	task scoreboard::run_phase(uvm_phase phase);
		super.run_phase(phase);
			fork
				forever begin
				fifo_apb.get(a_txn);
				apb_cov = new a_txn;
				apb_covergroup.sample();
				if(a_txn.PWRITE && (a_txn.PADDR == 3'b101)) begin
					fifo_spi.get(s_txn);
					spi_cov = new s_txn;
					spi_covergroup.sample();
					compare_for_transmission(a_txn);
				end
										 
				if(!a_txn.PWRITE && (a_txn.PADDR == 3'b101)) 
					compare_for_reception(a_txn);
				end
			join
		endtask

	task scoreboard::compare_for_transmission(apb_txn a_txn);
		$display("%p",a_txn.sprint());
		  $display("%p",s_txn.sprint());

		if(a_txn.PWDATA == s_txn.mosi)
			`uvm_info(get_type_name(),"Transmission Succesfull",UVM_LOW)
	
		else 
			`uvm_info(get_type_name(),"Transmission Unsuccesfull",UVM_LOW)
				
	endtask
	
	task scoreboard::compare_for_reception(apb_txn a_txn);
	$display("%p",a_txn.sprint());

		if(a_txn.PRDATA == s_txn.miso)
				`uvm_info(get_type_name(),"Reception Succesfull",UVM_LOW)
		else
				`uvm_info(get_type_name(),"Reception Unsuccesfull",UVM_LOW)
			
	endtask

//1100_0001 == PWDATA 
//0111_0111 == MOSI

//1001_0000 == MISO
//1001_0001 == PRDATA