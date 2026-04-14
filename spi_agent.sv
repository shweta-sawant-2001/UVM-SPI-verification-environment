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