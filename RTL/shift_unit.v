module shift_unit 

#(parameter width = 16 ) 
(
input wire [width - 1 : 0] A  ,
input wire [width - 1 : 0] B  , 
input wire [1:0]ALU_FUN  ,
input wire shift_enable ,
input wire clk  , 
input wire reset ,
output reg [width - 1 : 0] shift_out  ,
output reg shift_flag 

) ; 

reg [width - 1 : 0 ]shift_comb ; 
reg shift_flag_comb ; 

always @(posedge clk or negedge reset) 
begin 
if (!reset) 
   begin 
shift_out <= 'd0 ; 
//we can make it shift_out <= 16'b0 but we made it parametrized 
// secondly if we make width'b0 would be wrong sytnax  
shift_flag <= 1'b0 ; 
   end 
else 
    begin
  shift_out <= shift_comb ;
  shift_flag <= shift_flag_comb ; 
    end 
 end 
 
 
 always @(*) 
 begin 
 
 shift_comb = 'd0 ; 
 shift_flag_comb = 1'b0 ; 
			if (shift_enable) 
				begin 
				shift_flag_comb = 1 ;
					case (ALU_FUN) 
	                2'b00 : begin 
					shift_comb = A >> 1 ; 
				
					        end
							
	                  2'b01 : begin 
					  shift_comb = A << 1 ; 
					   
					         end
					  
                    	2'b10 : begin 
						shift_comb = B >> 1;
						
					          	end 


						
                        	2'b11 : begin  
							shift_comb = B << 1 ; 
							
							        end
			    	endcase 
				end 	
	        else 
	           begin 
			   shift_comb = 'd0 ; 
			   shift_flag_comb = 1'b0 ; 
			   end 

 end 
 
 endmodule 
 