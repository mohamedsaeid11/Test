//==============================================================================
// Module : alu_4bit.v
// Author : Saeed
// Date   : 2025-10-18
// Desc   : Top-level 4-bit ALU. Instantiates adder_subtractor, logic_unit, shifter.
//          Selects sub-module outputs according to op[2:0] encoding provided in
//          system specifications. Produces result[3:0], carry and zero flags.
// Pin list:
//   input  [3:0] a    - first operand
//   input  [3:0] b    - second operand
//   input  [2:0] op   - operation select (000 ADD, 001 SUB, 010 AND, 011 OR,
//                       100 XOR, 101 NOT(a), 110 SHL, 111 SHR)
//   output reg [3:0] result
//   output reg carry
//   output reg zero
// Notes:
//   - For ADD/SUB carry comes from adder_subtractor carry output.
//   - For SHL/SHR carry = shifter.shift_out.
//   - For logical ops carry = 0.
//   - zero flag is asserted when result == 4'b0000.
//==============================================================================

module alu_4bit(
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [2:0] op,
    output reg  [3:0] result,
    output reg        carry,
    output reg        zero
);

    // Intermediate wires from submodules
    wire [3:0] addsub_result;
    wire       addsub_carry;
    wire [3:0] logic_result;
    wire [3:0] shifter_result;
    wire       shifter_shift_out;

    // Sub-module instantiations
    adder_subtractor u_adder_sub (
        .a(a),
        .b(b),
        .sub(op == 3'b001), // sub = 1 when op == SUB (001)
        .result(addsub_result),
        .carry(addsub_carry)
    );

    // logic_unit op mapping (2-bit op local)
    wire [1:0] logic_op = op[1:0];
    logic_unit u_logic (
        .a(a),
        .b(b),
        .op(logic_op),
        .result(logic_result)
    );

    // shifter dir: 0 = left, 1 = right
    wire shifter_dir = (op == 3'b111); // 111 => SHR, 110 => SHL
    shifter u_shifter (
        .a(a),
        .dir(shifter_dir),
        .result(shifter_result),
        .shift_out(shifter_shift_out)
    );

    // Combinational select logic
    always @(*) begin
        result = 4'b0000;
        carry  = 1'b0;

        case (op)
            3'b000: begin // ADD
                result = addsub_result;
                carry  = addsub_carry;
            end
            3'b001: begin // SUB
                result = addsub_result;
                carry  = addsub_carry;
            end
            3'b010: begin // AND
                result = logic_result;
            end
            3'b011: begin // OR
                result = logic_result;
            end
            3'b100: begin // XOR
                result = logic_result;
            end
            3'b101: begin // NOT (a)
                result = logic_result;
            end
            3'b110: begin // SHL
                result = shifter_result;
                carry  = shifter_shift_out;
            end
            3'b111: begin // SHR
                result = shifter_result;
                carry  = shifter_shift_out;
            end
            default: begin
                result = 4'b0000;
                carry  = 1'b0;
            end
        endcase
    end

    // Zero flag
    always @(*) begin
        zero = (result == 4'b0000);
    end

endmodule
