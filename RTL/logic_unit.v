module logic_unit 

#(parameter width = 16  ) 
( 
input wire  [width - 1 : 0] A  ,
input wire  [width - 1 : 0] B  , 
input wire [1:0]ALU_FUN  ,
input wire logic_enable ,
input wire clk  , 
input wire reset ,
output reg [width - 1 : 0] logic_out  ,
output reg logic_flag  

) ; 

reg [width - 1 : 0 ]logic_comb , logic_flag_comb ; 

always @(posedge clk or negedge reset) 
begin 
if (!reset) 
   begin 
logic_out <= 'b0 ;
logic_flag <= 1'b0 ;
    end 
else 
     begin 
logic_out <= logic_comb ;
logic_flag<= logic_flag_comb ;  
     end 
 end 
 
 always @(*) 
 begin 
            // intiallized flag 1 and comb 0  				
				logic_flag_comb = 1 ; 
				logic_comb = 0 ; 
				
			if (logic_enable) 
				begin  
				
				logic_flag_comb = 1 ; 
					
					case (ALU_FUN) 
	                2'b00 : begin 
					logic_comb = A & B ; 
				
					        end
							
	                  2'b01 : begin 
					  logic_comb = A | B ; 
					 
					         end
					  
                    	2'b10 : begin 
						logic_comb = ~( A & B );
					          	end 


						
                        	2'b11 : begin  
							logic_comb = ~( A | B ) ; 
							  logic_flag_comb = 1 ; 
							        end
			    	endcase 
				end 	
	        else 
	           begin 
			   logic_comb = 'b0 ; 
		    	logic_flag_comb = 0 ; 			   
			   end 

 end 
 
 endmodule 
 