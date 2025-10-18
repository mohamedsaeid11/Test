# Architecture — 4-bit ALU
**Author:** Saeed  
**Date:** 2025-10-18  

---

## System Overview
The 4-bit Arithmetic Logic Unit (ALU) performs basic arithmetic, logic, and shift operations.  
It takes two 4-bit inputs (`a`, `b`) and a 3-bit operation code (`op[2:0]`), then produces a 4-bit `result` along with two flags:
- **carry** — indicates carry/borrow or shift-out bit  
- **zero** — indicates when the output result equals zero  

The ALU is built using a **modular design**, where each functional unit performs a specific task, and a top-level module integrates them to produce the final output.

---

## Block Diagram

lua
Copy code
   +------------------------------------------+
   |                alu_4bit                  |
   |------------------------------------------|
   |                                          |
a[3:0] |--> adder_subtractor --->+ |
| | |
b[3:0] |--> logic_unit ----------+---> result[3:0] ---> Output
| | |
|--> shifter --------------+ |
| |
|------------------------------------------|
| carry, zero flags

ruby
Copy code

---

## Description of Modular Architecture

### 1. **adder_subtractor**
- Performs both addition and subtraction.
- Used when `op = 000` (ADD) or `op = 001` (SUB).
- Provides result and carry/borrow flag.

### 2. **logic_unit**
- Handles logical operations: AND, OR, XOR, NOT.
- Active for `op = 010`, `011`, `100`, `101`.
- Output affects only `result`; `carry` is forced to zero.

### 3. **shifter**
- Shifts operand `a` left or right by one bit.
- Active for `op = 110` (SHL) or `op = 111` (SHR).
- The shifted-out bit is used as the `carry` flag.

### 4. **alu_4bit (top-level)**
- Integrates all sub-modules.
- Uses a `case` statement to select which sub-module output drives `result` and `carry`.
- Computes `zero = (result == 4'b0000)`.

---

## Explanation of Integration
- Inputs `a` and `b` are connected to all submodules simultaneously.  
- Each submodule produces its own output (`result`) and flag (`carry` or `shift_out`).  
- A multiplexer or `case` logic in the top-level ALU selects one of these results based on `op[2:0]`.  
- The top-level module also computes the `zero` flag based on the final result.  

---

## Data Flow Description
1. Inputs `a`, `b`, and `op` enter the top-level ALU.
2. Based on `op`, the ALU determines which submodule to activate logically.
3. The corresponding submodule computes the 4-bit result.
4. The top-level selects that result and assigns the proper `carry` flag.
5. The `zero` flag is asserted if the result equals `4'b0000`.

---

## Interface Specification Table

| Signal | Width | Direction | Description |
|---------|--------|------------|-------------|
| a       | 4 bits | Input | First operand |
| b       | 4 bits | Input | Second operand |
| op      | 3 bits | Input | Operation select |
| result  | 4 bits | Output | Final ALU result |
| carry   | 1 bit  | Output | Carry/borrow or shift_out bit |
| zero    | 1 bit  | Output | High when result == 0 |

---

## Design Decisions and Rationale
- **Modular Architecture:** Simplifies debugging and testing each unit independently.  
- **Unified Carry Flag:** Reuses the same output for arithmetic carry, borrow, and shift-out.  
- **Combinational Design:** No clock signal; purely combinational for fast response.  
- **Zero Flag Computation:** Implemented in top-level to avoid duplication.  
- **Case-based Multiplexing:** Simplifies logic selection and ensures synthesis-friendly structure.  
- **Scalability:** The same approach can be extended to 8-bit or 16-bit ALUs easily.

---