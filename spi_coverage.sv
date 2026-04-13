`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_coverage extends uvm_subscriber #(spi_transaction);
  
  spi_transaction tx;
  
  covergroup cg_spi;
    tx_data: coverpoint tx.tx_data {
      bins low = {[0:63]};
      bins mid = {[64:127]};
      bins high = {[128:255]};
    }
    rx_data: coverpoint tx.rx_data {
      bins low = {[0:63]};
      bins mid = {[64:127]};
      bins high = {[128:255]};
    }
    cross tx_data, rx_data;
  endgroup
  
  `uvm_component_utils(spi_coverage)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_spi = new();
  endfunction
  
  function void write(spi_transaction t);
    tx = t;
    cg_spi.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("\n=============== COVERAGE REPORT ===============");
    $display("Coverage = %.2f %%", $get_coverage());
    $display("==============================================\n");
  endfunction
  
endfunction