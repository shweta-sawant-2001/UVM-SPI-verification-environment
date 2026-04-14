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