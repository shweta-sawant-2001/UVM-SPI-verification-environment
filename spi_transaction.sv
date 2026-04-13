`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

// ========== SPI TRANSACTION ==========
// This is the DATA PACKET that flows through the testbench
class spi_transaction extends uvm_sequence_item;
  
  // ========== PROPERTIES ==========
  rand logic [7:0] tx_data;          // Random data to transmit
  logic [7:0] rx_data;               // Data received (observed)
  rand bit delay_enable;             // Optional: add delays
  
  // ========== REGISTER WITH UVM ==========
  // This macro tells UVM about this class
  // It enables: copy(), compare(), print(), randomize()
  `uvm_object_utils(spi_transaction)
  
  // ========== CONSTRUCTOR ==========
  // Called when you do: spi_transaction tx = new("my_tx");
  function new(string name = "spi_transaction");
    super.new(name);  // Call parent constructor
  endfunction
  
  // ========== TO_STRING (for printing) ==========
  // Makes it easy to print: $display(tx.to_string());
  function string to_string();
    return $sformatf("TX_DATA: 0x%h | RX_DATA: 0x%h", 
                     tx_data, rx_data);
  endfunction
  
  // ========== CONSTRAINTS (Optional) ==========
  // Constrain randomization if needed
  constraint tx_data_constraint {
    tx_data != 8'h00;  // Don't send all zeros
  }
  
endclass