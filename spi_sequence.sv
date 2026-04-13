`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

// ========== SPI SEQUENCER ==========
// This decides WHICH transactions to send and in WHAT ORDER
// It's like a librarian handing books to a reader in sequence
class spi_sequencer extends uvm_sequencer #(spi_transaction);
  
  // ========== REGISTER WITH UVM ==========
  `uvm_component_utils(spi_sequencer)
  
  // ========== CONSTRUCTOR ==========
  // uvm_component needs (name, parent)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass