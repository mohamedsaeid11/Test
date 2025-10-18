# Integration Guide — 4-bit ALU
**Author:** Saeed  
**Date:** 2025-10-18  

---

## How to Instantiate the ALU in Another Design
To use the ALU inside a larger system (like a CPU datapath or controller), instantiate it as shown:

```verilog
module top_system (
    input  wire [3:0] in_a,
    input  wire [3:0] in_b,
    input  wire [2:0] op_code,
    output wire [3:0] alu_out,
    output wire       alu_carry,
    output wire       alu_zero
);

    alu_4bit U_ALU (
        .a(in_a),
        .b(in_b),
        .op(op_code),
        .result(alu_out),
        .carry(alu_carry),
        .zero(alu_zero)
    );

endmodule
Port Connection Examples
Port	Example Connection	Description
a	Register or accumulator	Input operand
b	Register or memory bus	Second operand
op	Control unit output	Operation select signal
result	ALU output bus	Goes to data path or register
carry	Status flag	Used for branch or arithmetic flags
zero	Status flag	Indicates zero result

Timing Information
The entire ALU is purely combinational — no clock or sequential logic is used.

Output changes as soon as inputs (a, b, op) change.

Propagation delay depends on adder depth (typically nanoseconds).

If used in a clocked system, register the inputs or outputs to meet timing constraints.

Usage Examples with Code Snippets
Example 1 — Simple Test Integration
verilog
Copy code
always @(*) begin
    case (alu_op)
        3'b000: alu_out = A + B;   // ADD
        3'b001: alu_out = A - B;   // SUB
        default: alu_out = 4'b0000;
    endcase
end
Now replace the above logic with the actual ALU instance:

verilog
Copy code
alu_4bit U_ALU (.a(A), .b(B), .op(alu_op), .result(alu_out), .carry(c_out), .zero(z_out));
Example 2 — In CPU Datapath
verilog
Copy code
wire [3:0] acc, operand, alu_result;
wire [2:0] alu_ctrl;
wire c_flag, z_flag;

alu_4bit ALU (
    .a(acc),
    .b(operand),
    .op(alu_ctrl),
    .result(alu_result),
    .carry(c_flag),
    .zero(z_flag)
);

always @(posedge clk) begin
    if (load_acc)
        acc <= alu_result;
end
Common Pitfalls and Recommendations
Carry vs Borrow: Ensure consistent interpretation for SUB — some architectures invert borrow.

NOT Operation: Uses only input a; b is ignored.

Shift Direction: op = 110 = SHL, op = 111 = SHR — confirm with control logic.

Timing in Sequential Systems: Add output registers if connected to clocked stages.

Synthesis: Do not include $display or simulation-only constructs in RTL.

Verification: Always run the provided testbench (alu_4bit_tb.v) before integration.

yaml
Copy code

---

✅ Both files now:
- Follow your project format  
- Contain **all required sections**  
- Are **ready to push** into your `docs/` folder  

Would you like me to generate a short **commit message list** for these two docs so you can just copy them when committing (to meet the “5 commits” rule)?






