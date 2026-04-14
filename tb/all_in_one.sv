// ============================================================
// UVM TESTBENCH (FIXED)
// ============================================================

`include "uvm_macros.svh"
import uvm_pkg::*;

// ============================================================
// INTERFACE
// ============================================================
interface spi_if(input logic clk, rst);
  logic [7:0] tx_data;
  logic [7:0] rx_data;
  logic mosi;
  logic miso;
  logic sclk;
  logic cs;
  logic start;
  logic done;
endinterface

// ============================================================
// TRANSACTION
// ============================================================
class spi_transaction extends uvm_sequence_item;

  rand logic [7:0] tx_data;
       logic [7:0] rx_data;

  `uvm_object_utils(spi_transaction)

  function new(string name = "spi_transaction");
    super.new(name);
  endfunction

endclass

// ============================================================
// SEQUENCER
// ============================================================
class spi_sequencer extends uvm_sequencer #(spi_transaction);

  `uvm_component_utils(spi_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

// ============================================================
// DRIVER
// ============================================================
class spi_driver extends uvm_driver #(spi_transaction);

  virtual spi_if vif;

  `uvm_component_utils(spi_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_if", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set in driver")
  endfunction

  task run_phase(uvm_phase phase);
    spi_transaction tr;

    vif.start = 0;

    forever begin
      seq_item_port.get_next_item(tr);

      // drive data
      vif.tx_data = tr.tx_data;

      // assert start for AT LEAST 1 full clock cycle safely
      @(posedge vif.clk);
      vif.start = 1;
      
      repeat(2)
      @(posedge vif.clk);
      vif.start = 0;

      // wait for DUT completion
      wait (vif.done == 1);

      // capture result
      tr.rx_data = vif.rx_data;

      // wait done to drop (avoid sticky issue)
      @(posedge vif.clk);
      wait (vif.done == 0);

      seq_item_port.item_done();
    end
  endtask

endclass

// ============================================================
// MONITOR
// ============================================================
class spi_monitor extends uvm_monitor;

  virtual spi_if vif;
  uvm_analysis_port #(spi_transaction) ap;

  `uvm_component_utils(spi_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_if", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set in monitor")
  endfunction

  task run_phase(uvm_phase phase);
    spi_transaction t;

    forever begin
      @(posedge vif.done);

      t = spi_transaction::type_id::create("t");
      t.tx_data = vif.tx_data;
      t.rx_data = vif.rx_data;

      ap.write(t);
    end
  endtask

endclass

// ============================================================
// SCOREBOARD
// ============================================================
class spi_scoreboard extends uvm_scoreboard;

  uvm_analysis_export #(spi_transaction) analysis_export;
  uvm_tlm_analysis_fifo #(spi_transaction) fifo;

  int pass = 0;
  int fail = 0;

  `uvm_component_utils(spi_scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    fifo = new("fifo", this);
    analysis_export = new("analysis_export", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    analysis_export.connect(fifo.analysis_export);
  endfunction

  task run_phase(uvm_phase phase);
    spi_transaction t;

    forever begin
      fifo.get(t);

      if (t.rx_data == ~t.tx_data)
        pass++;
      else
        fail++;
    end
  endtask

endclass

// ============================================================
// AGENT
// ============================================================
class spi_agent extends uvm_agent;

  spi_sequencer seqr;
  spi_driver    drv;
  spi_monitor   mon;

  `uvm_component_utils(spi_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seqr = spi_sequencer::type_id::create("seqr", this);
    drv  = spi_driver::type_id::create("drv", this);
    mon  = spi_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass

// ============================================================
// ENVIRONMENT
// ============================================================
class spi_env extends uvm_env;

  spi_agent     agent;
  spi_scoreboard sb;

  `uvm_component_utils(spi_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = spi_agent::type_id::create("agent", this);
    sb    = spi_scoreboard::type_id::create("sb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.mon.ap.connect(sb.analysis_export);
  endfunction

endclass

// ============================================================
// SEQUENCE
// ============================================================
class spi_sequence extends uvm_sequence #(spi_transaction);

  `uvm_object_utils(spi_sequence)

  function new(string name = "spi_sequence");
    super.new(name);
  endfunction

  task body();
    spi_transaction tr;

    repeat (10) begin
      tr = spi_transaction::type_id::create("tr");
      start_item(tr);

      assert(tr.randomize());

      finish_item(tr);
    end
  endtask

endclass

// ============================================================
// TEST
// ============================================================
class test_spi_basic extends uvm_test;

  spi_env env;

  `uvm_component_utils(test_spi_basic)

  function new(string name = "test_spi_basic", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = spi_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);

    spi_sequence seq;

    phase.raise_objection(this);

    seq = spi_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);

    #500;

    phase.drop_objection(this);

  endtask

endclass

// ============================================================
// TOP MODULE
// ============================================================
module tb_spi_uvm;

  logic clk, rst;
  spi_if vif(clk, rst);

  // DUT (assumed existing in your project)
  spi_master dut (
    .clk(clk),
    .rst(rst),
    .start(vif.start),
    .tx_data(vif.tx_data),
    .miso(vif.miso),
    .rx_data(vif.rx_data),
    .mosi(vif.mosi),
    .sclk(vif.sclk),
    .cs(vif.cs),
    .done(vif.done)
  );
  
  initial begin
    $dumpfile("dump.vcd");   // 👈 creates waveform file
    $dumpvars(0, tb_spi_uvm); // 👈 dumps EVERYTHING under top
  end
  
  // Clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset
  initial begin
    rst = 0;
    #20 rst = 1;
  end

  // Simple SPI slave model
  assign vif.miso = ~vif.mosi;

  initial begin
    uvm_config_db#(virtual spi_if)::set(null, "*", "spi_if", vif);
    run_test("test_spi_basic");
  end

endmodule