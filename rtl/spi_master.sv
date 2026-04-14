`timescale 1ns/1ps

// ============================================================
// CLOCK DIVIDER
// ============================================================
module clk_divider #(parameter DIVIDER = 4)(
  input  logic clk,
  input  logic rst,
  output logic clk_o
);

  logic [31:0] counter;

  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      counter <= 0;
      clk_o   <= 0;
    end else begin
      if (counter == DIVIDER - 1) begin
        counter <= 0;
        clk_o   <= ~clk_o;
      end else begin
        counter <= counter + 1;
      end
    end
  end

endmodule


// ============================================================
// SPI MASTER (WITH DEBUG)
// ============================================================
module spi_master #(parameter CLK_DIV = 4)(
  input  logic clk,
  input  logic rst,
  input  logic start,
  input  logic [7:0] tx_data,
  input  logic miso,

  output logic [7:0] rx_data,
  output logic mosi,
  output logic sclk,
  output logic cs,
  output logic done
);

  logic sclk_div;
  logic [3:0] bit_count;
  logic [7:0] shift_tx, shift_rx;

  typedef enum logic [1:0] {S_IDLE, S_TRANSFER, S_DONE} state_t;
  state_t state;

  clk_divider #(CLK_DIV) div_inst (
    .clk(clk),
    .rst(rst),
    .clk_o(sclk_div)
  );

  assign sclk = sclk_div;

  // =========================================================
  // DEBUG: state + signals monitor
  // =========================================================
  always @(posedge clk) begin
    $display("[DUT] t=%0t state=%0d start=%0b done=%0b cs=%0b bit=%0d tx=%h rx=%h",
              $time, state, start, done, cs, bit_count, shift_tx, shift_rx);
  end

  // =========================================================
  // FSM
  // =========================================================
  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      state     <= S_IDLE;
      bit_count <= 0;
      shift_tx  <= 0;
      shift_rx  <= 0;
      rx_data   <= 0;
      done      <= 0;
      cs        <= 1;
      mosi      <= 0;
    end else begin

      case (state)

        S_IDLE: begin
          done <= 0;
          cs   <= 1;
          mosi <= 0;
          bit_count <= 0;

          if (start == 1) begin
            $display("[DUT] >>> START detected at time %0t tx_data=%h", $time, tx_data);

            shift_tx <= tx_data;
            shift_rx <= 0;
            state    <= S_TRANSFER;
          end
        end

        S_TRANSFER: begin
          cs   <= 0;
          mosi <= shift_tx[7];

          shift_tx <= {shift_tx[6:0], 1'b0};
          shift_rx <= {shift_rx[6:0], miso};

          bit_count <= bit_count + 1;

          $display("[DUT] TRANSFER bit=%0d mosi=%b miso=%b shift_tx=%h shift_rx=%h",
                    bit_count, shift_tx[7], miso, shift_tx, shift_rx);

          if (bit_count == 7) begin
            $display("[DUT] >>> DONE condition reached");
            state <= S_DONE;
          end
        end

        S_DONE: begin
          cs   <= 1;
          done <= 1;
          rx_data <= shift_rx;

          $display("[DUT] >>> DONE state reached rx_data=%h", shift_rx);

          state <= S_IDLE;
        end

      endcase
    end
  end

endmodule