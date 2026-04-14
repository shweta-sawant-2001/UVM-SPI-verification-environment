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
      `uvm_fatal("NOVIF", "Monitor interface missing")
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
