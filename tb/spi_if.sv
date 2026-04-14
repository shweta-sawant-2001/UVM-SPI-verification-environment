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