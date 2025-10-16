module ALU_TOP 
#(parameter width = 16, 
  parameter width2 = 32)
(
    input wire [width-1 : 0] A,
    input wire [width-1 : 0] B,
    input wire clk,
    input wire reset,
    input wire [3:0] ALU_FUN,
    
    output wire [width2-1 : 0] arith_out,
    output wire arith_flag,
    
    output wire [width-1 : 0] logic_out,
    output wire logic_flag,
    
    output wire [width-1 : 0] cmp_out,
    output wire cmp_flag,
    
    output wire [width-1 : 0] shift_out,
    output wire shift_flag
);

  
    wire arith_enable, logic_enable, cmp_enable, shift_enable;

   
        Decoder dec_inst (
        .ALU_FUN(ALU_FUN[3:2]),
        .enable_dec(1'b1), // Always enable decoder
        .arith_enable(arith_enable),
        .logic_enable(logic_enable),
        .cmp_enable(cmp_enable),
        .shift_enable(shift_enable)
                         );

    arith_unit #(.width(width), .width2(width2)) arith_inst (
        .A(A),
        .B(B),
        .ALU_FUN(ALU_FUN[1:0]),
        .arith_enable(arith_enable),
        .clk(clk),
        .reset(reset),
        .arith_out(arith_out),
        .arith_flag(arith_flag)
                                                            );

   
    logic_unit #(.width(width)) logic_inst (
        .A(A),
        .B(B),
        .ALU_FUN(ALU_FUN[1:0]),
        .logic_enable(logic_enable),
        .clk(clk),
        .reset(reset),
        .logic_out(logic_out),
        .logic_flag(logic_flag)
                                 );

  
    cmp_unit #(.width(width)) cmp_inst (
        .A(A),
        .B(B),
        .ALU_FUN(ALU_FUN[1:0]),
        .cmp_enable(cmp_enable),
        .clk(clk),
        .reset(reset),
        .cmp_out(cmp_out),
        .cmp_flag(cmp_flag)
                                       );

   
    shift_unit #(.width(width)) shift_inst (
        .A(A),
        .B(B),
        .ALU_FUN(ALU_FUN[1:0]),
        .shift_enable(shift_enable),
        .clk(clk),
        .reset(reset),
        .shift_out(shift_out),
        .shift_flag(shift_flag)
                                            );

endmodule
