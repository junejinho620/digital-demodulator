localparam bitWidth = 24;

//count to 512 for LRCLK
//count to 8 for SCLK
module clockdiv (
	input logic reset,
	input logic MCLK,
	output logic SCLK,
	output logic LRCLK,
	
	output logic next_sclk_rise,
	output logic next_sclk_fall,
	output logic next_lrclk_rise,
	output logic next_lrclk_fall
);

logic [bitWidth - 1:0] L_count;
logic [bitWidth - 1:0] S_count;

always@(posedge MCLK)
begin

	if (reset)
	begin
		S_count <= 0;
		L_count <= 0;
		SCLK = 1;
		LRCLK = 0;
	end
	else
	begin
		if (S_count == 0)
		begin
			if ((next_sclk_rise == 1) || (next_sclk_fall == 1))
			begin
				S_count <= 3;
				SCLK <= !SCLK;
				next_sclk_rise <= 0;
				next_sclk_fall <= 0;
			end
			else
			begin
				S_count <= 3;
				next_sclk_rise <= 0;
				next_sclk_fall <= 0;
			end
		end
		
		else if (S_count == 1)
		begin
			
			if (SCLK == 0)
			begin
				next_sclk_rise <= 1;
				next_sclk_fall <= 0;
			end
			else if (SCLK == 1)
			begin
				next_sclk_rise <= 0;
				next_sclk_fall <= 1;
			end
			else
			begin
				next_sclk_rise <= 0;
				next_sclk_fall <= 0;
			end
			S_count <= S_count - 1;
			
		end
		
		else
		begin
			S_count <= S_count - 1;
			next_sclk_rise <= 0;
			next_sclk_fall <= 0;
		end
		
		if (L_count == 0)
		begin
			if ((next_lrclk_rise == 1) || (next_lrclk_fall == 1))
			begin
				L_count <= 255;
				LRCLK <= !LRCLK;
				next_lrclk_rise <= 0;
				next_lrclk_fall <= 0;
			end
			else
			begin
				L_count <= 255;
				next_lrclk_rise <= 0;
				next_lrclk_fall <= 0;
			end
		end
		
		else if (L_count == 1)
		begin
		
			if (LRCLK == 0)
			begin
				next_lrclk_rise <= 1;
				next_lrclk_fall <= 0;
			end
			else if (LRCLK == 1)
			begin
				next_lrclk_rise <= 0;
				next_lrclk_fall <= 1;
			end
			else
			begin
				next_lrclk_rise <= 0;
				next_lrclk_fall <= 0;
			end
			L_count <= L_count - 1;
		end
		
		else
		begin
			L_count <= L_count - 1;
			next_lrclk_rise <= 0;
			next_lrclk_fall <= 0;
		end
	end
end

endmodule
