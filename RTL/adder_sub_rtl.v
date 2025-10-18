//==============================================================================
// Module: adder_subtractor
// Description: 4-bit adder/subtractor using ripple-carry architecture with
//              2's complement subtraction method
// Author: Salah
// Date: October 17, 2025
//==============================================================================
// Inputs:
//   a[3:0]   - First 4-bit operand
//   b[3:0]   - Second 4-bit operand
//   sub      - Operation select (0 = addition, 1 = subtraction)
// Outputs:
//   result[3:0] - 4-bit result of addition or subtraction
//   carry       - Carry out for addition, borrow indicator for subtraction
//==============================================================================

module adder_subtractor(
    input [3:0] a,
    input [3:0] b,
    input sub,              // 0=add, 1=subtract
    output [3:0] result,
    output carry
);

    // Internal signals
    wire [3:0] b_modified;  // b or ~b depending on sub signal
    wire [3:0] sum;         // Result from addition
    wire [4:0] carry_chain; // Carry chain for ripple-carry adder
    
    // For subtraction: modify b to ~b and add 1 via carry_in (2's complement)
    // For addition: b remains unchanged
    assign b_modified = sub ? ~b : b;
    
    // Initial carry is 1 for subtraction (to complete 2's complement), 0 for addition
    assign carry_chain[0] = sub;
    
    // Ripple-carry adder implementation (4 full adders)
    // Bit 0
    assign sum[0] = a[0] ^ b_modified[0] ^ carry_chain[0];
    assign carry_chain[1] = (a[0] & b_modified[0]) | (carry_chain[0] & (a[0] ^ b_modified[0]));
    
    // Bit 1
    assign sum[1] = a[1] ^ b_modified[1] ^ carry_chain[1];
    assign carry_chain[2] = (a[1] & b_modified[1]) | (carry_chain[1] & (a[1] ^ b_modified[1]));
    
    // Bit 2
    assign sum[2] = a[2] ^ b_modified[2] ^ carry_chain[2];
    assign carry_chain[3] = (a[2] & b_modified[2]) | (carry_chain[2] & (a[2] ^ b_modified[2]));
    
    // Bit 3
    assign sum[3] = a[3] ^ b_modified[3] ^ carry_chain[3];
    assign carry_chain[4] = (a[3] & b_modified[3]) | (carry_chain[3] & (a[3] ^ b_modified[3]));
    
    // Output assignments
    assign result = sum;
    assign carry = carry_chain[4];  // Carry out indicates overflow (ADD) or borrow (SUB)

endmodule