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

      if (t.rx_data !== 8'hxx)
        pass++;
      else
        fail++;
    end

  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD",
      $sformatf("PASS=%0d FAIL=%0d TOTAL=%0d",
      pass, fail, pass+fail), UVM_NONE)
  endfunction

endclass