module cmp_unit 
#(parameter width = 16 ) 
( 
    input wire [width - 1 : 0] A,
    input wire [width - 1 : 0] B, 
    input wire [1:0] ALU_FUN,
    input wire cmp_enable,
    input wire clk, 
    input wire reset,
    output reg [1:0] cmp_out,        // Changed from [width-1:0] to [1:0]
    output reg cmp_flag 
);

reg [1:0] cmp_comb;                  // Changed from [width-1:0] to [1:0]
reg cmp_flag_comb;

always @(posedge clk or negedge reset) 
begin 
    if (!reset) 
    begin 
        cmp_out <= 2'd0;             // Changed from 'd0 to 2'd0 for clarity
        cmp_flag <= 1'b0; 
    end 
    else 
    begin 
        cmp_out <= cmp_comb; 
        cmp_flag <= cmp_flag_comb; 
    end  
end 

always @(*) 
begin 
    cmp_flag_comb = 1'b0; 
    cmp_comb = 2'd0;                 // Changed from 'd0 to 2'd0
    
    if (cmp_enable) 
    begin 
        cmp_flag_comb = 1;
        case (ALU_FUN) 
            2'b01: begin 
                if (A == B)
                    cmp_comb = 2'd1; // Equal comparison result  
                else 
                    cmp_comb = 2'd0; 
            end
            
            2'b10: begin 
                if (A > B)
                    cmp_comb = 2'd2; // Greater than comparison result  
                else 
                    cmp_comb = 2'd0; 
            end
            
            2'b11: begin 
                if (A < B)
                    cmp_comb = 2'd3; // Less than comparison result  
                else 
                    cmp_comb = 2'd0; 
            end
            
            default: begin 
                cmp_comb = 2'd0; 
                cmp_flag_comb = 1'b0;
            end 
        endcase 
    end 	
    else 
    begin 
        cmp_comb = 2'd0; 
        cmp_flag_comb = 1'b0; 
    end 
end 

endmodule