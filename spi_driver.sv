`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

interface spi_if (input logic clk, reset);
    logic [7:0] tx_data;
    logic [7:0] rx_data;
    logic mosi;
    logic miso;
    logic sclk;
    logic cs;
    logic start;
    logic done;
endinterface

class spi_driver extends uvm_driver #(spi_transaction);

virtual spi_if vif;

`uvm_component_utils(spi_driver)

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db #(virtual spi_if):: get(
        this, "", "spi_if", vif))

        `uvm_fatal("DRIVER"; "Could not get virtual interface")
endfunction


task run_phase(uvm_phase phase);
    spi_transaction req, rsp;

    forever begin
        seq_item_port.get_next_item(req);

        drive_transaction(req);

        rsp = spi_transaction::type_id::create("rsp");
        rsp.copy(req);
        rsp.rx_data = vif.rx_data;

        seq_item_port.item_done(rsp);
    end
endtask

// ========== HELPER TASK: DRIVE TRANSACTION ==========
// Actually applies signals to DUT pins
  task drive_transaction(spi_transaction tx);
    $display("[DRIVER] Sending TX_DATA: 0x%h", tx.tx_data);
    
    // Wait for done to be low (DUT idle)
    @(negedge vif.done);
    
    // Set input data
    vif.tx_data = tx.tx_data;
    
    // Pulse start signal
    vif.start = 1'b1;
    @(posedge vif.clk);
    vif.start = 1'b0;
    
    // Wait for transfer to complete
    @(posedge vif.done);
    
    // Capture received data
    vif.rx_data = vif.rx_data;  // DUT outputs this
    
    $display("[DRIVER] Received RX_DATA: 0x%h", vif.rx_data);
  endtask
  
endclass
