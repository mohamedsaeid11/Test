module arith_unit 
#(parameter width = 16  ,
 width2 = 32  ) 
 (

input wire signed [width -1 : 0] A  ,
input wire signed [width -1 : 0] B  , 
input wire [1:0]ALU_FUN  ,
input wire arith_enable ,
input wire clk  , 
input wire reset ,
output reg [width2 -1 : 0]arith_out ,
output reg arith_flag  

) ; 

reg [width2 -1 : 0] arith_comb ; 
reg arith_flag_comb ; 


always @(posedge clk or negedge reset) 
begin 
if (!reset)
   begin 
arith_out <= 32'b0 ;
arith_flag <= 1'b0 ; 
   end 
else 
    begin 
arith_out <= arith_comb ; 
arith_flag <= arith_flag_comb ; 
    end 
 end 
 
 always @(*) 
 
 begin 
 
    arith_comb =  32'd0 ; 
 	arith_flag_comb = 1'b0 ;
	
			if (arith_enable) 
				begin 
					arith_flag = 1'b1 ; 
					
					case (ALU_FUN) 
	                2'b00 : begin 
					arith_comb = A + B ; 
				
				
					        end
							
	                  2'b01 : begin 
					  arith_comb = A - B ; 
					
					         end
					  
                    	2'b10 : begin 
						arith_comb = A * B ;
					 
					          	end 


						
                        	2'b11 : begin  
							arith_comb = (B != 0)  ? (A/B) : 32'b0 ;
							         end
									
			    	endcase 
				end 	
	        else 
	           begin 
			   arith_comb = 32'd0 ; 
			   arith_flag_comb =1'b0 ;  
			   end 

 end 
 
 endmodule 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
