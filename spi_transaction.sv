class spi_transaction extends uvm_sequence_item;

  rand logic [7:0] tx_data;
       logic [7:0] rx_data;

  `uvm_object_utils(spi_transaction)

  function new(string name = "spi_transaction");
    super.new(name);
  endfunction

endclass