class spi_driver extends uvm_driver #(spi_txn);
	`uvm_component_utils(spi_driver)
	
	bit [7:0]ctrl;
	bit cpol, cpha, lsbfe;
	
	virtual SPI_interface.SPI_DRV_MP spi_vif;

	spi_agent_config spi_cfgh;
	
	extern function new(string name="spi_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(spi_txn req);

endclass

	function spi_driver::new(string name="spi_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void spi_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
//	uvm_config_db #(spi_agent_config)::set(this,"*","spi_config",spi_cfgh); in env

		if(!uvm_config_db #(spi_agent_config)::get(this,"","spi_config",spi_cfgh))
			`uvm_fatal(get_type_name(),"Getting Config Failed")
		else
			`uvm_info(get_type_name(),"Getting config successful",UVM_LOW)
	endfunction

	function void spi_driver::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		spi_vif = spi_cfgh.spi_vif;
	endfunction

	task spi_driver::run_phase(uvm_phase phase);
		super.run_phase(phase);
		if(!uvm_config_db #(bit [7:0])::get(this,"","CR1_value",ctrl))
			`uvm_fatal(get_type_name(),"Getting CR 1 value Failed")
		lsbfe = ctrl[0]; 
		cpol = ctrl[3];
		cpha = ctrl[2];

		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		
	endtask

	task spi_driver::send_to_dut(spi_txn req);
		wait(spi_vif.SPI_DRV_CB.SS == 1'b0);
		`uvm_info(get_type_name(),$sformatf("The Miso_value is %b",req.miso),UVM_LOW)
		if(lsbfe) begin
			if(!cpol && !cpha) begin
				
				spi_vif.SPI_DRV_CB.miso <= req.miso[0];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[0]),UVM_LOW)
				for(int i=1;i<=7;i++) begin
					@(negedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end
			end
			else if(!cpol && cpha) begin
				for(int i=0;i<=7;i++) begin
					@(posedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end

			end
			else if(cpol && !cpha) begin
				spi_vif.SPI_DRV_CB.miso <= req.miso[0];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[0]),UVM_LOW)
				for(int i=1;i<=7;i++) begin
					@(posedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end

			end
			else begin
				for(int i=0;i<=7;i++) begin
					@(negedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)

				end
			end
		end
		else begin
			if(!cpol && !cpha) begin
				spi_vif.SPI_DRV_CB.miso <= req.miso[7];
		`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[7]),UVM_LOW)
				for(int i=6;i>=0;i--) begin
					@(negedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
					`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end
			end
			else if(!cpol && cpha) begin
				for(int i=7;i>=0;i--) begin
					@(posedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
					`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end

			end
			else if(cpol && !cpha) begin
				spi_vif.SPI_DRV_CB.miso <= req.miso[7];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[7]),UVM_LOW)
				for(int i=6;i>=0;i--) begin
					@(posedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end

			end
			else begin
				for(int i=7;i>=0;i--) begin
					@(negedge spi_vif.SPI_DRV_CB.SCLK)
						spi_vif.SPI_DRV_CB.miso <= req.miso[i];
				`uvm_info(get_type_name(),$sformatf("The Driven Miso_value is %b",req.miso[i]),UVM_LOW)
				end
			end

		end
		
	endtask