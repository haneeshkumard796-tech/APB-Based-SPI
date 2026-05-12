interface APB_interface(input bit clock);

	bit PCLK;
	logic PSEL,PENABLE,PWRITE,PRESETn,PSLVERR,PREADY;
	
	logic [2:0]PADDR;
	logic [7:0]PWDATA,PRDATA;

	assign PCLK = clock;

	clocking APB_DRV_CB@(posedge PCLK);
		output PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRESETn;
		input PRDATA,PREADY,PSLVERR;
	endclocking

	clocking APB_MON_CB@(posedge PCLK);
		input PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRESETn,PRDATA,PREADY,PSLVERR;
	endclocking
	
	modport APB_DRV_MP(clocking APB_DRV_CB);
	modport APB_MON_MP(clocking APB_MON_CB);

//	modport APB_DUT_MP(input PCLK,PSEL,PENABLE,PRESETn,PWRITE,PADDR,PWDATA, output PRDATA, PREADY, PSLVERR);

	property p1;
		@(posedge PCLK) (PSEL && !PENABLE) |-> (##[1:2]PENABLE);
	endproperty
	
	property p2;
		@(posedge PCLK) (PSEL && !PENABLE) |-> PSEL until PENABLE;
	endproperty
	
	property p3;
		@(posedge PCLK) (PENABLE) |-> ##[1:2]PREADY;
	endproperty
	
	property p4;
		@(posedge PCLK) PREADY |=> (!PENABLE && !PREADY);
	endproperty

	prp1 : assert property (p1)
			$display("property p1","Penable went high");
	 	else
			$display("property p1","Penable did not go high within two cycles");
	
	prp2 : assert property (p2)
			$display("property p2","Psel stayed high");
	 	else
			$display("property p2","Psel did not stay high");

	prp3 : assert property (p3)
			$display("property p3","Pready went high");
	 	else
			$display("property p3","Pready did not go high within two cycles");

	prp4 : assert property (p4)
			$display("property p4","Pready and Penable went low together");
	 	else
			$display("property p4","Pready and Penable did not go low together");

	
endinterface