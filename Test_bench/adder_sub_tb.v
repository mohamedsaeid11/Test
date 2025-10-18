//==============================================================================
// Testbench: adder_subtractor_tb
// Description: Self-checking testbench for adder_subtractor module
// Author: Salah
// Date: October 17, 2025
//==============================================================================

`timescale 1ns/1ps

module adder_subtractor_tb;
    // Declare testbench signals
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire [3:0] result;
    wire carry;
    
    // Expected values for checking
    reg [3:0] expected_result;
    reg expected_carry;
    
    // Instantiate module under test
    adder_subtractor uut (
        .a(a),
        .b(b),
        .sub(sub),
        .result(result),
        .carry(carry)
    );
    
    // Test variables
    integer passed = 0;
    integer failed = 0;
    integer test_num = 0;
    
    // Test procedure
    initial begin
        $display("========================================");
        $display("Testing adder_subtractor");
        $display("========================================");
        
        // Test 1: Add all zeros
        test_num = test_num + 1;
        a = 4'b0000; b = 4'b0000; sub = 0;
        expected_result = 4'b0000; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 0 + 0 = 0", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 2: Add all ones (overflow case)
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b1111; sub = 0;
        expected_result = 4'b1110; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 15 + 15 = 30 (overflow, result=14, carry=1)", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 3: Maximum positive values (4'hF + 4'hF)
        test_num = test_num + 1;
        a = 4'hF; b = 4'hF; sub = 0;
        expected_result = 4'hE; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 0xF + 0xF with carry", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%h carry=%b, Got result=%h carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 4: Simple addition 5 + 3
        test_num = test_num + 1;
        a = 4'b0101; b = 4'b0011; sub = 0;
        expected_result = 4'b1000; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 5 + 3 = 8", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 5: Addition with carry 8 + 8
        test_num = test_num + 1;
        a = 4'b1000; b = 4'b1000; sub = 0;
        expected_result = 4'b0000; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 8 + 8 = 16 (overflow)", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 6: Addition 7 + 7
        test_num = test_num + 1;
        a = 4'b0111; b = 4'b0111; sub = 0;
        expected_result = 4'b1110; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 7 + 7 = 14", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 7: Subtract all zeros
        test_num = test_num + 1;
        a = 4'b0000; b = 4'b0000; sub = 1;
        expected_result = 4'b0000; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 0 - 0 = 0", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 8: Subtract equal values (no borrow)
        test_num = test_num + 1;
        a = 4'b0101; b = 4'b0101; sub = 1;
        expected_result = 4'b0000; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 5 - 5 = 0 (no borrow)", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 9: Subtract 8 - 3
        test_num = test_num + 1;
        a = 4'b1000; b = 4'b0011; sub = 1;
        expected_result = 4'b0101; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 8 - 3 = 5", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 10: Subtract with borrow (underflow) 3 - 8
        test_num = test_num + 1;
        a = 4'b0011; b = 4'b1000; sub = 1;
        expected_result = 4'b1011; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 3 - 8 (underflow/borrow)", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 11: Subtract 15 - 1
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b0001; sub = 1;
        expected_result = 4'b1110; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 15 - 1 = 14", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 12: Subtract 15 - 15
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b1111; sub = 1;
        expected_result = 4'b0000; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 15 - 15 = 0", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 13: Add 1 + 1
        test_num = test_num + 1;
        a = 4'b0001; b = 4'b0001; sub = 0;
        expected_result = 4'b0010; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 1 + 1 = 2", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 14: Add 9 + 6 (overflow)
        test_num = test_num + 1;
        a = 4'b1001; b = 4'b0110; sub = 0;
        expected_result = 4'b1111; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 9 + 6 = 15", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 15: Subtract 10 - 5
        test_num = test_num + 1;
        a = 4'b1010; b = 4'b0101; sub = 1;
        expected_result = 4'b0101; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 10 - 5 = 5", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 16: Add 12 + 3
        test_num = test_num + 1;
        a = 4'b1100; b = 4'b0011; sub = 0;
        expected_result = 4'b1111; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 12 + 3 = 15", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 17: Subtract 7 - 9 (underflow)
        test_num = test_num + 1;
        a = 4'b0111; b = 4'b1001; sub = 1;
        expected_result = 4'b1110; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 7 - 9 (underflow/borrow)", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 18: Add 0 + 15
        test_num = test_num + 1;
        a = 4'b0000; b = 4'b1111; sub = 0;
        expected_result = 4'b1111; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 0 + 15 = 15", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 19: Subtract 15 - 0
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b0000; sub = 1;
        expected_result = 4'b1111; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 15 - 0 = 15", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 20: Random combination - Add 6 + 9
        test_num = test_num + 1;
        a = 4'b0110; b = 4'b1001; sub = 0;
        expected_result = 4'b1111; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 6 + 9 = 15", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 21: Random combination - Subtract 13 - 7
        test_num = test_num + 1;
        a = 4'b1101; b = 4'b0111; sub = 1;
        expected_result = 4'b0110; expected_carry = 1;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - SUB: 13 - 7 = 6", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Test 22: Edge case - Add 14 + 1
        test_num = test_num + 1;
        a = 4'b1110; b = 4'b0001; sub = 0;
        expected_result = 4'b1111; expected_carry = 0;
        #10;
        if (result == expected_result && carry == expected_carry) begin
            $display("PASS: Test %0d - ADD: 14 + 1 = 15", test_num);
            passed = passed + 1;
        end else begin
            $display("FAIL: Test %0d - Expected result=%b carry=%b, Got result=%b carry=%b", 
                     test_num, expected_result, expected_carry, result, carry);
            failed = failed + 1;
        end
        
        // Final summary
        $display("========================================");
        $display("Tests Passed: %0d/%0d", passed, passed+failed);
        $display("========================================");
        
        if (failed == 0) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("SOME TESTS FAILED - Review output above");
        end
        
        $finish;
    end
    
    // Optional: Waveform dump
    initial begin
        $dumpfile("sim/results/adder_subtractor.vcd");
        $dumpvars(0, adder_subtractor_tb);
    end
endmodule