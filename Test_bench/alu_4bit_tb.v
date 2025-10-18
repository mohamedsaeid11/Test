//==============================================================================
// Testbench : alu_4bit_tb.v
// Description: Self-checking testbench for top-level ALU (alu_4bit).
// Author : Saeed
// Date   : 2025-10-18
//==============================================================================

`timescale 1ns/1ps

module alu_4bit_tb;

    // DUT signals
    reg  [3:0] a;
    reg  [3:0] b;
    reg  [2:0] op;
    wire [3:0] result;
    wire       carry;
    wire       zero;

    // Instantiate DUT
    alu_4bit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry(carry),
        .zero(zero)
    );

    // Test bookkeeping
    integer total = 0;
    integer passed = 0;
    integer i;

    // Helper function to compute expected results in testbench
    // This is simulation-only logic.
    task expected_behavior(
        input [3:0] ta,
        input [3:0] tb,
        input [2:0] top,
        output [3:0] exp_res,
        output       exp_carry
    );
        reg [4:0] wide;
        begin
            case (top)
                3'b000: begin // ADD
                    wide = {1'b0, ta} + {1'b0, tb};
                    exp_res = wide[3:0];
                    exp_carry = wide[4];
                end
                3'b001: begin // SUB (a - b) via two's complement expectation
                    wide = {1'b0, ta} - {1'b0, tb};
                    exp_res = wide[3:0];
                    // For borrow detection: if a < b then wide[4] == 1 (in 5-bit signed subtraction sign),
                    // But the adder_subtractor in RTL reports carry as described in spec; here we emulate as:
                    exp_carry = (ta < tb) ? 1'b1 : 1'b0;
                end
                3'b010: begin // AND
                    exp_res = ta & tb;
                    exp_carry = 1'b0;
                end
                3'b011: begin // OR
                    exp_res = ta | tb;
                    exp_carry = 1'b0;
                end
                3'b100: begin // XOR
                    exp_res = ta ^ tb;
                    exp_carry = 1'b0;
                end
                3'b101: begin // NOT(a)
                    exp_res = ~ta;
                    exp_carry = 1'b0;
                end
                3'b110: begin // SHL (a << 1)
                    exp_res = {ta[2:0], 1'b0};
                    exp_carry = ta[3]; // shift_out = msb out
                end
                3'b111: begin // SHR (a >> 1)
                    exp_res = {1'b0, ta[3:1]};
                    exp_carry = ta[0]; // shift_out = lsb out
                end
                default: begin
                    exp_res = 4'b0000;
                    exp_carry = 1'b0;
                end
            endcase
        end
    endtask

    // Operation name helper
    function [64*1:1] opname;
        input [2:0] top;
        begin
            case (top)
                3'b000: opname = "ADD";
                3'b001: opname = "SUB";
                3'b010: opname = "AND";
                3'b011: opname = "OR";
                3'b100: opname = "XOR";
                3'b101: opname = "NOT";
                3'b110: opname = "SHL";
                3'b111: opname = "SHR";
                default: opname = "UNK";
            endcase
        end
    endfunction

    // Waveform dump
    initial begin
        $dumpfile("sim/results/alu_4bit.vcd");
        $dumpvars(0, alu_4bit_tb);
    end

    // Main test procedure
    initial begin
        $display("========================================");
        $display("Starting ALU 4-bit full-system tests");
        $display("========================================");

        // 1) Edge cases and specific checks (12 tests)
        // all zeros, all ones, max add overflow, max sub underflow, alternation patterns
        reg [3:0] test_a [0:11];
        reg [3:0] test_b [0:11];
        reg [2:0] test_op [0:11];

        test_a[0] = 4'b0000; test_b[0] = 4'b0000; test_op[0] = 3'b000; // ADD 0+0
        test_a[1] = 4'b0000; test_b[1] = 4'b0000; test_op[1] = 3'b010; // AND 0 & 0
        test_a[2] = 4'b1111; test_b[2] = 4'b1111; test_op[2] = 3'b000; // ADD F+F
        test_a[3] = 4'b1111; test_b[3] = 4'b0001; test_op[3] = 3'b001; // SUB F-1
        test_a[4] = 4'b1010; test_b[4] = 4'b0101; test_op[4] = 3'b010; // AND
        test_a[5] = 4'b1010; test_b[5] = 4'b0101; test_op[5] = 3'b011; // OR
        test_a[6] = 4'b1010; test_b[6] = 4'b0101; test_op[6] = 3'b100; // XOR
        test_a[7] = 4'b1010; test_b[7] = 4'b0000; test_op[7] = 3'b101; // NOT(a)
        test_a[8] = 4'b1000; test_b[8] = 4'b0000; test_op[8] = 3'b110; // SHL
        test_a[9] = 4'b0001; test_b[9] = 4'b0000; test_op[9] = 3'b111; // SHR
        test_a[10]= 4'b0011; test_b[10]= 4'b0011; test_op[10]= 3'b000; // ADD small
        test_a[11]= 4'b0001; test_b[11]= 4'b0010; test_op[11]= 3'b001; // SUB 1-2 (borrow)

        for (i = 0; i < 12; i = i + 1) begin
            a = test_a[i]; b = test_b[i]; op = test_op[i];
            #1; // allow propagation
            total = total + 1;
            reg [3:0] expected_r;
            reg expected_c;
            expected_behavior(a, b, op, expected_r, expected_c);

            $display("Test %0d: %s a=%b b=%b -> expect res=%b carry=%b ; got res=%b carry=%b zero=%b",
                     total, opname(op), a, b, expected_r, expected_c, result, carry, zero);

            if (result === expected_r && carry === expected_c && zero === (expected_r==4'b0000)) begin
                $display("  PASS");
                passed = passed + 1;
            end else begin
                $display("  FAIL");
            end
        end

        // 2) Exhaustive-ish coverage for each operation: at least 6 vectors per op (8 ops * 6 = 48 tests)
        // We'll generate a set of useful vectors per op including random-ish and boundary cases.
        reg [3:0] vecs [0:5];
        vecs[0] = 4'h0;
        vecs[1] = 4'h1;
        vecs[2] = 4'h7;
        vecs[3] = 4'h8;
        vecs[4] = 4'hF;
        vecs[5] = 4'hA;

        integer op_idx;
        for (op_idx = 0; op_idx < 8; op_idx = op_idx + 1) begin
            for (i = 0; i < 6; i = i + 1) begin
                // Construct tests: vary a,b depending on op
                a = vecs[i];
                if (op_idx == 5) begin
                    // NOT uses only a
                    b = 4'h0;
                end else begin
                    b = vecs[(i+2)%6];
                end
                op = op_idx[2:0];
                #1;
                total = total + 1;
                reg [3:0] expected_r2;
                reg expected_c2;
                expected_behavior(a, b, op, expected_r2, expected_c2);

                $display("Test %0d: %s a=%b b=%b -> expect res=%b carry=%b ; got res=%b carry=%b zero=%b",
                         total, opname(op), a, b, expected_r2, expected_c2, result, carry, zero);

                if (result === expected_r2 && carry === expected_c2 && zero === (expected_r2==4'b0000)) begin
                    passed = passed + 1;
                    $display("  PASS");
                end else begin
                    $display("  FAIL");
                end
            end
        end

        // At this point we should have >= 12 + (8*6)=60 tests; but spec asked minimum 50.
        // Print final summary
        $display("========================================");
        $display("Tests Passed: %0d/%0d", passed, total);
        $display("========================================");

        // Required final exact format
        $display("%0d/%0d tests passed", passed, total);

        $finish;
    end

endmodule
