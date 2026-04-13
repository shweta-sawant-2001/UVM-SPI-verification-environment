`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_scoreboard extends uvm_scoreboard;
  
  uvm_analysis_export #(spi_transaction) analysis_export;
  uvm_tlm_analysis_fifo #(spi_transaction) fifo;
  
  int pass_count = 0;
  int fail_count = 0;
  
  `uvm_component_utils(spi_scoreboard)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    fifo = new("fifo", this);
    analysis_export = new("analysis_export", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    analysis_export.connect(fifo.analysis_export);
  endfunction
  
  task run_phase(uvm_phase phase);
    spi_transaction tx;
    
    forever begin
      fifo.get(tx);
      
      // For loopback test: rx_data should equal ~tx_data
      if (tx.rx_data == ~tx.tx_data) begin
        $display("[SCOREBOARD] PASS: TX=0x%h, RX=0x%h", 
                 tx.tx_data, tx.rx_data);
        pass_count++;
      end else begin
        $display("[SCOREBOARD] FAIL: TX=0x%h, Expected=0x%h, Got=0x%h", 
                 tx.tx_data, ~tx.tx_data, tx.rx_data);
        fail_count++;
      end
    end
  endtask
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("\n=============== SCOREBOARD REPORT ===============");
    $display("PASS: %d", pass_count);
    $display("FAIL: %d", fail_count);
    $display("TOTAL: %d", pass_count + fail_count);
    $display("===============================================\n");
  endfunction
  
endclass