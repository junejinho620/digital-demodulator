module i2s_tx #(
	parameter DATA_RES = 24
) (
	input logic reset, mclk, sclk, lrclk, valid,
	input logic [DATA_RES-1:0] i_ldin, i_rdin,
	output logic o_sdout
);
	
	logic [DATA_RES - 1:0] S_count;
	
	always@(posedge sclk)
	begin
	
		if (reset)
		begin
			S_count <= 24'd31;
			o_sdout <= 0;
		end
		
		else if(lrclk == 0)//lrclk == 0 ==> left channel
		begin
			
			if (S_count == 0)
			begin
				
				S_count <= 24'd31;
				
			end
			else if (S_count > 7)//for S_counts between 7 and 32 (first 24 after first one)
			begin
				
				o_sdout <= i_ldin[S_count - 8];
				S_count <= S_count - 1;
				
			end
			else
			begin
				
				S_count <= S_count - 1;
				
			end
			
		end
		else//if lrclk == 1 ==> right channel
		begin
			
			if (S_count == 0)
			begin
				
				S_count <= 24'd31;
				
			end
			else if (S_count > 7)//for S_counts between 7 and 32 (first 24 after first one)
			begin
				
				o_sdout <= i_rdin[S_count - 8];
				S_count <= S_count - 1;
				
			end
			else
			begin
				
				S_count <= S_count - 1;
				
			end
			
		end
		
	end
	
endmodule
