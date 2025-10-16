module decoder (
    input  wire [3:2] ALU_FUN,
    input  wire       enable_dec,
    output reg        arith_enable,
    output reg        logic_enable,
    output reg        cmp_enable,
    output reg        shift_enable
);

always @(*) begin

    arith_enable = 0;
    logic_enable = 0;
    cmp_enable   = 0;
    shift_enable = 0;

    if (enable_dec) begin
        case (ALU_FUN)
            2'b00: arith_enable = 1;
            2'b01: logic_enable = 1;
            2'b10: cmp_enable   = 1;
            2'b11: shift_enable = 1;
            default: 
			begin
			 arith_enable = 0;
             logic_enable = 0;
             cmp_enable   = 0;
             shift_enable = 0;
			 end 
        endcase
    end
end

endmodule
