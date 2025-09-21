module i2s_rx #(
	parameter DATA_RES = 24
) (
	input logic reset, mclk, sclk, lrclk, i_sdata, valid,
	output logic [DATA_RES-1:0] o_left, o_right
);
	
	logic [DATA_RES - 1:0] S_count;
	
	always@(posedge sclk)
	begin
		if (reset)
		begin
			S_count <= 24'd31;
		end
		else
		begin
			if (S_count == 0)
			begin
				S_count <= 24'd31;
			end
			else
			begin
				S_count <= S_count - 1;
			end
		end
	end
	
	always@(negedge sclk)
	begin
		if (reset)
		begin
			o_left <= 0;
			o_right <= 0;
		end
		
		else if ((S_count > 6) && (S_count < 31))//for S_counts between 6 and 31 (first 24 after first one)
		begin
		
			if(lrclk == 0)//lrclk == 0 ==> left channel
			begin
				o_left[S_count - 7] <= i_sdata;
			end
			
			else//if lrclk == 1 ==> right channel
			begin
				o_right[S_count - 7] <= i_sdata;
			end
			
		end
	end
	
endmodule
