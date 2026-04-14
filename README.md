# UVM SPI Verification Environment

This project is a **SystemVerilog UVM-based verification environment** for testing an SPI (Serial Peripheral Interface) Master design.  
It demonstrates a complete UVM testbench with stimulus generation, monitoring, and result checking.

---

## 📌 Overview

The environment verifies SPI communication by sending random 8-bit data to the DUT and checking the received response.

Key components:
- UVM Driver → drives SPI signals
- UVM Monitor → captures DUT response
- UVM Sequencer/Sequence → generates transactions
- Scoreboard → checks results
- Interface → connects DUT and testbench

A simple loopback model is used for `MISO` in simulation.

---

## 🏗️ Testbench Structure
- tb/
    │
    ├── spi_if.sv
    ├── spi_transaction.sv
    ├── spi_sequencer.sv
    ├── spi_sequence.sv
    ├── spi_driver.sv
    ├── spi_monitor.sv
    ├── spi_scoreboard.sv
    ├── spi_agent.sv
    ├── spi_env.sv
    ├── spi_test.sv
    │
    rtl/
    └── spi_master.sv

    sim/
    └── tb_top.sv



---

## ⚙️ Working Flow

1. Sequence generates 10 random SPI transactions  
2. Driver sends `tx_data` to DUT and triggers `start`  
3. DUT performs SPI transfer  
4. Monitor captures `tx_data` and `rx_data`  
5. Scoreboard checks transaction validity  
6. Final pass/fail report is generated  

---

## ▶️ How to Run (QuestaSim)

```bash
vlog rtl/spi_master.sv tb/*.sv sim/tb_top.sv
vsim -uvm work.tb_spi_uvm
run -all
```
## Output
- At the end of simulation, scoreboard prints:
    PASS = 10 | FAIL = 0 | TOTAL = 10

- A waveform file is also generated:
    dump.vcd

## Purpose
- This project helps in learning:

1. UVM verification architecture
2. Transaction-based verification
3. Driver–Monitor–Scoreboard flow
4. Basic SPI protocol simulation
5. Testbench modularization

## Future Enhancements (Phase 2)

- AXI4-Lite register interface integration
- SPI configuration via memory-mapped registers
- SoC-style verification environment
- Advanced constrained-random test generation
- Assertion-based verification (SVA)

---

## Learning Outcomes

This project demonstrates:

- RTL design of SPI protocol
- UVM testbench architecture
- Transaction-level verification (TLM)
- Scoreboard-based checking methodology
- Functional coverage-driven verification
- Real-world simulation using Aldec Riviera-PRO


## Note

This project is built for **learning and portfolio demonstration purposes**, following **industry-standard UVM practices**.
