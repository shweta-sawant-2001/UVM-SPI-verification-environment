# SPI UVM Verification Environment

## 📌 Overview
This project implements a complete UVM-based verification environment for an SPI Master design using SystemVerilog.

It follows industry-standard UVM methodology with reusable components.

---

## 🧱 Project Structure

- design.sv → SPI Master RTL
- spi_transaction.sv → Transaction class
- spi_sequencer.sv → Sequence control
- spi_driver.sv → Drives DUT signals
- spi_agent.sv → Combines driver + sequencer
- spi_scoreboard.sv → Result checker
- spi_coverage.sv → Functional coverage model
- spi_env.sv → UVM environment
- tb_spi_uvm.sv → Top-level testbench

---

## ⚙️ Features

- Random stimulus generation
- UVM factory-based architecture
- Scoreboard for result checking
- Coverage-driven verification
- Modular and reusable components

---

## 🚀 How to Run

1. Compile all SystemVerilog files
2. Run tb_spi_uvm.sv as top module
3. Use any UVM-supported simulator (VCS / Questa / Xcelium)

---

## 🎯 Learning Outcome

- UVM architecture understanding
- Driver–sequencer communication
- Scoreboard implementation
- Coverage-driven verification flow

---

## 📈 Future Improvements

- Constrained random sequences
- Assertions (SVA)
- Advanced coverage bins
- Multiple SPI modes (CPOL/CPHA)