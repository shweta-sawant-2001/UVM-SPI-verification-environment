# UVM SPI Verification Environment

## Overview

This project implements a **complete UVM-based verification environment** for an SPI Master design using SystemVerilog.

It follows a **modular, reusable, and industry-standard UVM architecture**, including stimulus generation, driver logic, scoreboard checking, and functional coverage collection.

The environment is verified using **Aldec Riviera-PRO 2025.4**.

---

## Key Highlights

- Full UVM-based verification architecture
- Randomized transaction generation
- Driver–Sequencer communication via TLM
- Scoreboard for functional correctness checking
- Functional coverage model for verification completeness
- Reusable and scalable testbench structure
- Industry-style layered verification approach

---

## Verification Architecture

Sequence → Sequencer → Driver → DUT (SPI Master RTL)  
                             ↓  
                             Monitor → Scoreboard + Coverage


---

## Verification Features

### Stimulus Generation
- Randomized SPI transactions
- Directed + random test scenarios

### Driver Functionality
- Converts transactions into pin-level DUT activity
- Handles SPI timing and handshake

###  Scoreboard
- Compares expected vs actual DUT output
- Ensures data integrity

### Coverage
- Tracks functional scenarios
- Ensures verification completeness

---

## Tools & Technologies

- SystemVerilog
- UVM (Universal Verification Methodology)
- Aldec Riviera-PRO 2025.4
- Object-Oriented Verification (OOP)

---


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
