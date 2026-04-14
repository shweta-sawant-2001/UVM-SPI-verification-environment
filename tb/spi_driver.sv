class spi_driver extends uvm_driver #(spi_transaction);

  virtual spi_if vif;

  `uvm_component_utils(spi_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_if", vif))
      `uvm_fatal("NOVIF", "Driver interface missing")
  endfunction

  task run_phase(uvm_phase phase);

    spi_transaction tr;
    vif.start = 0;

    forever begin
      seq_item_port.get_next_item(tr);

      vif.tx_data = tr.tx_data;

      @(posedge vif.clk);
      vif.start = 1;

      @(posedge vif.clk);
      vif.start = 0;

      wait(vif.done == 1);

      tr.rx_data = vif.rx_data;

      seq_item_port.item_done();
    end

  endtask

endclass