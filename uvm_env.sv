`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

class spi_env extends uvm_env;
  
  spi_agent agent;
  spi_scoreboard scoreboard;
  spi_coverage coverage;
  
  `uvm_component_utils(spi_env)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent = spi_agent::type_id::create("agent", this);
    scoreboard = spi_scoreboard::type_id::create("scoreboard", this);
    coverage = spi_coverage::type_id::create("coverage", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect agent monitor to scoreboard
    // agent.monitor.ap.connect(scoreboard.analysis_export);
    
    // Connect agent monitor to coverage
    // agent.monitor.ap.connect(coverage.analysis_export);
  endfunction
  
endclass