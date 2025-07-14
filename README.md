# 🚀 RISC-V 32-bit Single-Cycle Processor Design (Verilog HDL)

> **"Built a CPU from scratch, and it still runs better than my group chats!"** 🤖💡  
> This project is a practical implementation of a **32-bit single-cycle RISC-V processor** using Verilog HDL, inspired by the structure and design documented in the *RISCV pipelined.pdf* reference.

---

## 📌 Overview

This project implements the **RV32I Base Integer Instruction Set** using a **single-cycle processor architecture**. Every instruction is completed in a single clock cycle. Though not performance-optimized, this design serves as an excellent foundational model for learning CPU internals and instruction-level execution.

---

## 🧠 What is a Single-Cycle Processor?

A single-cycle processor executes **one instruction per clock cycle**. All five classic stages—**Instruction Fetch**, **Decode**, **Execute**, **Memory Access**, and **Write Back**—are completed within a single clock edge. This simplifies control logic but limits frequency due to long combinational paths.

---

## ⚙️ Supported Instruction Set

The processor supports the **RV32I** instruction set:
- **R-type**: `ADD`, `SUB`, `AND`, `OR`
- **I-type**: `ADDI`, `LW`, `JALR`
- **S-type**: `SW`
- **B-type**: `BEQ`
- **J-type**: `JAL`

---

## 🧩 Processor Components & Block Functions

### 1️⃣ Program Counter (PC)
- Holds the address of the current instruction.
- Updated every cycle by either `PC+4` or `PC + offset`.

### 2️⃣ Instruction Memory
- A ROM holding 32-bit wide machine code.
- Addressed using the PC.

### 3️⃣ Register File
- Contains 32 registers (`x0` to `x31`).
- Supports dual-read and single-write.
- `x0` is hardwired to zero.

### 4️⃣ ALU (Arithmetic Logic Unit)
- Performs operations: `ADD`, `SUB`, `AND`, `OR`, `SLT`.
- Operands are selected from register or immediate sources.

### 5️⃣ Data Memory
- RAM for `lw` and `sw` instructions.
- Supports word-aligned access.

### 6️⃣ Control Unit
- Decodes instruction opcode and generates control signals like:
  - `RegWrite`, `MemWrite`, `ALUSrc`, `Branch`, `ResultSrc`, etc.

### 7️⃣ Immediate Generator
- Extracts and sign-extends immediate values based on instruction type.

### 8️⃣ ALU Control Unit
- Decides the ALU operation based on `funct3`, `funct7`, and ALUOp.

### 9️⃣ MUXes
- Used to select between register and immediate data, memory or ALU result, PC paths.

### 🔟 Adders
- Used to compute `PC+4` and branch target addresses.

---

## 🖼️ Architecture Diagram

> Check out [`docs/architecture_diagram.png`](docs/architecture_diagram.png)  
This shows the complete datapath and control signals for the processor.

---

## 🧪 Simulation

- **Tested using**: Verilog testbench and `dump.vcd` waveforms.
- Instructions tested: `addi`, `add`, `lw`, `sw`, `beq`.
- Used GTKWave to visualize PC, register write values, ALU outputs, and memory accesses.

```bash
iverilog -o sim.out src/*.v testbench/riscv_tb.v
vvp sim.out
gtkwave dump.vcd
```

📸 See simulation screenshots in `/waveform_screenshots/`.

---

## 📁 Repository Structure

```
riscv-single-cycle/
├── src/
│   ├── ALU.v
│   ├── control_unit.v
│   ├── data_memory.v
│   ├── instruction_memory.v
│   ├── immediate_generator.v
│   ├── muxes.v
│   ├── reg_file.v
│   ├── pc.v
│   └── top.v        # Top-level module
│
├── testbench/
│   └── top_tb.v
│
├── docs/
│   ├── architecture_diagram.png
│   └── riscv_report.pdf
│
├── waveform_screenshots/
│   ├── wave1.png
│   └── wave2.png
│
├── README.md
└── LICENSE
```

---

## 📊 Synthesis Summary

This project was synthesized using [Vivado] for resource utilization checks.  
- ✔️ RTL Elaboration  
- ✔️ Timing reports  
- ✔️ Schematic generation  
*Can be synthesized using open-source tools like Yosys in the future.*

---

## 🚀 Future Work

- [ ] Add full support for all `RV32I` instructions.
- [ ] Handle memory alignment and load/store variants.
- [ ] Modularize control path further for pipelining.
- [ ] Extend to **5-stage pipelined processor** with hazard detection.
- [ ] Perform **RTL-to-GDS** flow using OpenLane and Cadence tools.

---

## 👨‍💻 Author

**NITHISH REDDY KVS**  
📍 3rd Year ECE @ College of Engineering, Guindy  
💻 Passionate about **Digital Design**, **VLSI**, **RTL-GDS** flow.  
💬 Open to collaborate & build processors from scratch.

🧠 Partner on this project: **KAVYA** 

---

## 🤝 Let’s Collaborate!

I'm open to:
- Suggestions to improve the design
- Collaborations to build an open-source processor
- Exploring ASIC & FPGA implementation of this design

**📩 [Connect on LinkedIn](https://www.linkedin.com/in/nithishreddy)**

---

## 📘 References

1. *Digital Design and Computer Architecture* by Harris & Harris  
2. *The RISC-V Instruction Set Manual: Volume I (Unprivileged ISA)*  

---

## 🪪 License

This project is licensed under the **MIT License**.
```
