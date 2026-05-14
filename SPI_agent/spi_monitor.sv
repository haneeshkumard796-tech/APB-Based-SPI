class spi_monitor extends uvm_monitor;
	`uvm_component_utils(spi_monitor)
	uvm_analysis_port #(spi_txn) spi_mon_port;
	
	virtual SPI_interface.SPI_MON_MP spi_vif;	
	spi_txn s_txn;

	bit [7:0]ctrl;
	bit cpol, cpha, lsbfe;

	spi_agent_config spi_cfgh;

	extern function new(string name="spi_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass
	function spi_monitor::new(string name="spi_monitor",uvm_component parent);
		super.new(name,parent);
		spi_mon_port = new("spi_mon_port",this);
	endfunction

	function void spi_monitor::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(spi_agent_config)::get(this,"","spi_config",spi_cfgh))
		`uvm_fatal(get_type_name(),"Getting SPI Config Failed")
	endfunction

	function void spi_monitor::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		spi_vif = spi_cfgh.spi_vif;
	endfunction
	
	task spi_monitor::run_phase(uvm_phase phase);
		super.run_phase(phase);
		if(!uvm_config_db #(bit [7:0])::get(this,"","CR1_value",ctrl))
			`uvm_fatal(get_type_name(),"Getting CR 1 value Failed")
		lsbfe = ctrl[0];
		cpha = ctrl[2];
		cpol = ctrl[3];
		wait(spi_vif.SPI_MON_CB.SS == 1'b0);
		s_txn = spi_txn::type_id::create("s_txn");
		s_txn.mosi = 8'd0;
		s_txn.miso = 8'd0;
		forever begin
			collect_data();
			s_txn.SS = spi_vif.SPI_MON_CB.SS;
			spi_mon_port.write(s_txn);	
		end
	endtask
	
	task spi_monitor::collect_data();
		if(lsbfe) begin
			if((!cpol && !cpha) || (cpol && cpha)) begin
				//@(posedge spi_vif.SCLK);	
				for(int i=0;i<=7;i++) begin
				@(posedge spi_vif.SPI_MON_CB.SCLK) fork 	
					s_txn.mosi[i] = spi_vif.SPI_MON_CB.mosi;
					s_txn.miso[i] = spi_vif.SPI_MON_CB.miso; 
				 join
				`uvm_info(get_type_name(),$sformatf("The sampled Txn is %s",s_txn.sprint()),UVM_LOW)
				end
			end
			else begin
				//@(posedge spi_vif.SCLK);
				for(int i=0;i<=7;i++) begin
				@(negedge spi_vif.SPI_MON_CB.SCLK) fork	
					s_txn.mosi[i] = spi_vif.SPI_MON_CB.mosi;
					s_txn.miso[i] = spi_vif.SPI_MON_CB.miso; join
				`uvm_info(get_type_name(),$sformatf("The sampled Txn is %s",s_txn.sprint()),UVM_LOW)
				end
			end
		end
		else begin
			if((!cpol && !cpha) || (cpol && cpha)) begin
				for(int i=7;i>=0;i--) begin
				@(posedge spi_vif.SPI_MON_CB.SCLK) fork 	
					s_txn.mosi[i] = spi_vif.SPI_MON_CB.mosi;
					s_txn.miso[i] = spi_vif.SPI_MON_CB.miso; join
				`uvm_info(get_type_name(),$sformatf("The sampled Txn is %s",s_txn.sprint()),UVM_LOW)
				end
			end
			else begin
				for(int i=7;i>=0;i--) begin
				@(negedge spi_vif.SPI_MON_CB.SCLK) fork	
					s_txn.mosi[i] = spi_vif.SPI_MON_CB.mosi;
					s_txn.miso[i] = spi_vif.SPI_MON_CB.miso; join
				`uvm_info(get_type_name(),$sformatf("The sampled Txn is %s",s_txn.sprint()),UVM_LOW)
				end
			end

		end
	endtask
