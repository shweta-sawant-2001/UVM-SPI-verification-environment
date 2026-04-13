/**👉 Agent = container

Holds sequencer + driver
Makes your SPI block reusable

Agent = Sequencer + Driver (working together)

**/

`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"


class spi_agent extends uvm_agent;

    spi_sequencer sequencer;        //gives transactions
    spi_driver driver;              //sends them to DUT

`uvm_component_utils(spi_agent)

//It initializes the component and connects it to the UVM hierarchy.
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 

  // ========== BUILD PHASE ==========
  // Create sequencer and driver

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    sequencer = spi_sequencer::type_id::create("sequencer", this);
    driver = spi_driver::type_id::create("driver", this);
  endfunction

  // ========== CONNECT PHASE ==========
  // Connect driver to sequencer
  /**
  👉 This is VERY important 👇

Sequencer → gives transactions
Driver → receives transactions
  **/

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
  
endclass

