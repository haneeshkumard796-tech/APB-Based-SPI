package test_pkg;
	
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	
	`include "apb_txn.sv"
	`include "apb_agent_config.sv"
	`include "apb_driver.sv"
	`include "apb_monitor.sv"
	`include "apb_sequencer.sv"
	`include "APB_agent.sv"
	`include "APB_agent_top.sv"

	`include "spi_txn.sv"
	`include "spi_agent_config.sv"
	`include "spi_driver.sv"
	`include "spi_monitor.sv"
	`include "spi_sequencer.sv"
	`include "SPI_agent.sv"
	`include "SPI_agent_top.sv"

	`include "scoreboard.sv"
	
	`include "env_config.sv"
	`include "env.sv"
	`include "apb_sequence.sv"
	`include "spi_sequence.sv"	
	`include "test.sv"

endpackage