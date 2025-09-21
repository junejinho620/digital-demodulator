//PINOUT

//MCLK = Arduino_IO0
//LRCLK = Arduino_IO1
//SCLK = Arduino_IO2
//FPGA serial_out = Arduino_IO3
//FPGA serial_in = Arduino_IO4
//reset = KEY[0]

module topMod(
	input logic [1:0] KEY,//reset
	input logic MAX10_CLK1_50, Arduino_IO4,//MCLK, serial_in
	output logic Arduino_IO0, Arduino_IO1, Arduino_IO2, Arduino_IO3//MCLK(output), LRCLK, SCLK, serial_out
);
	
	localparam bitWidth = 24;
	
	logic CLOCK_24;
	
	pll CL(.inclk0(MAX10_CLK1_50), .c0(CLOCK_24));
	
	assign Arduino_IO0 = CLOCK_24;
	
	audio_passthrough AP(.reset(!KEY[0]), .MCLK(CLOCK_24), .serial_in(Arduino_IO4), .LRCLK(Arduino_IO1), .SCLK(Arduino_IO2), .serial_out(Arduino_IO3));
	
endmodule

module audio_passthrough(
	input logic  reset, MCLK, serial_in,
	output logic LRCLK, SCLK, serial_out
);
	
	localparam bitWidth = 24;
	
	logic next_sclk_rise, next_sclk_fall, next_lrclk_rise, next_lrclk_fall, valid;

	logic [bitWidth - 1:0] left_channel;
	logic [bitWidth - 1:0] right_channel;
	
	//assign serial_out = serial_in;
	
	clockdiv CD(.reset(reset), .MCLK(MCLK), .SCLK(SCLK), .LRCLK(LRCLK),
					.next_sclk_rise(next_sclk_rise), .next_sclk_fall(next_sclk_fall),
					.next_lrclk_rise(next_lrclk_rise), .next_lrclk_fall(next_lrclk_fall));
					
	assign valid = next_lrclk_rise | next_lrclk_fall;
	
	i2s_rx receiver(.reset(reset), .mclk(MCLK), .sclk(SCLK), .lrclk(LRCLK), .i_sdata(serial_in),
						 .valid(valid), .o_left(left_channel), .o_right(right_channel));

	i2s_tx transmitter(.reset(reset), .mclk(MCLK), .sclk(SCLK), .lrclk(LRCLK), .valid(valid),
							 .i_ldin(left_channel), .i_rdin(right_channel),
							 .o_sdout(serial_out));
	
endmodule

//module audio_passthrough(
//	input logic  MCLK, serial_in,
//	output logic LRCLK, SCLK, serial_out
//);
//	
//	localparam bitWidth = 24;
//	
//	initial
//	begin
//		LRCLK = 0;
//		SCLK = 0;
//		serial_out = 0;
//
//	end
//
//	logic next_sclk_rise, next_sclk_fall, next_lrclk_rise, valid;
//
//	logic [bitWidth - 1:0] left_channel;
//	logic [bitWidth - 1:0] right_channel;
//
//	clockdiv CD(.MCLK(MCLK), .SCLK(SCLK), .LRCLK(LRCLK),
//					.next_sclk_rise(next_sclk_rise), .next_sclk_fall(next_sclk_fall),
//					.next_lrclk_rise(next_lrclk_rise), .next_lrclk_fall(valid));
//
//	i2s_rx receiver(.mclk(MCLK), .sclk(SCLK), .lrclk(LRCLK), .i_sdata(serial_in),
//						 .valid(valid), .o_left(left_channel), .o_right(right_channel));
//
//	i2s_tx transmitter(.mclk(MCLK), .sclk(SCLK), .lrclk(LRCLK), .valid(valid),
//							 .i_ldin(left_channel), .i_rdin(right_channel),
//							 .o_sdout(serial_out));
//	
//endmodule
