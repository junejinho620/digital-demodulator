`timescale 1ns/1ps

module FIR_filter #(parameter order = 10)(
	input logic clk,
	input logic reset,
	input logic x_valid,
	input logic signed [23:0] x,//input signal x
	input logic signed [15:0] h [order - 1:0],//impulse response h
	output logic signed [39:0] y//output signal y
);
	
	//DELAY
	//unit delay registers
	logic signed [order - 1:0][23:0] delay;
	
	//unit delay next registers
	logic signed [order - 1:1][23:0] next_delay;
	
	
	//MULTIPLIER
	//multiplier unit outputs
	logic signed [order - 1:0][39:0] multOut;
	
	//multiplier ready/valid signals
	logic [order - 1:0] multInValid;
	logic [order - 1:0] multOutValid;
	logic [order - 1:0] multInReady;
	logic [order - 1:0] multOutReady;
	
	
	//ADDER
	//adder unit inputs
	logic signed [order - 1:1][39:0] addIn;
	
	//adder unit outputs
	logic signed [order - 1:1][40:0] addOut;
	
	//adder ready/valid signals
	logic [order - 1:1] addInValid;
	logic [order - 1:1] addOutValid;
	logic [order - 1:1] addInReady;
	logic [order - 1:1] addOutReady;
	
	//set up adder and multiplier modules
	mult #(16, 24) multiplierModule[order - 1:0] (clk, reset, multInValid, multInReady, h, delay, multOut, multOutValid, multOutReady);//clk, reset, i_valid, i_ready, i_a, i_b, o_c, o_valid, o_ready
	adder #(40) adderModule[order - 1:1] (clk, reset, addInValid, addInReady, multOut[order - 1:1], addIn, addOut, addOutValid, addOutReady);//clk, reset, i_valid, i_ready, i_a, i_b, o_c, o_valid, o_ready
	
	assign addIn[1] = multOut[0];
	
	genvar i;
	
	generate
	for (i = 2; i < order; i++)//instantiate adderModules| 2 to 9
	begin : generateBlockName0
		assign addIn[i] = addOut[i - 1][39:0];
	end
	endgenerate
	
	assign y[39:0] = addOut[order - 1][39:0];
	
	//set up adder ready/valid signals
	assign addInReady[order - 1] = 1;//last adder is always ready
	assign addInValid[1] = multOutValid[0] & multOutValid[1];//first adder input is valid if first 2 multipliers are outputting valid data
	
	generate
	for (i = 2; i < order; i++)// 2 to 9
	begin : generateBlockName1
		assign addInReady[i - 1] = addOutReady[i];//adder is ready for input if following adder is ready for input
		assign addInValid[i] = addOutValid[i - 1] & multOutValid[i];//adder input is valid if parallel multiplier and previous adder are outputting valid data
	end
	endgenerate
	
	//set up multiplier ready/valid signals
	assign multInReady[0] = addOutReady[1];//first multiplier is ready when first adder is ready
	
	generate
	for (i = 1; i < order; i++)// 1 to 9
	begin : generateBlockName2
		assign multInReady[i] = addOutReady[i];//multiplier is ready when parallel adder is also ready
	end
	endgenerate
	
	//multiplier valid signal stuff here
	
	always@(posedge clk)
	begin
		if (reset)
		begin
			delay <= 0;
			next_delay <= 0;
		end
		else if (x_valid)
		begin
			delay[0] <= x;
			for (int i = 1; i < order; i++)//delay[1] <= next_delay[1] ...
			begin
				delay[i] <= next_delay[i];
			end
			multInValid <= 0;//multiplier input is invalid when x_valid is high, as this is when signal values are changing
		end
		else
		begin
			delay <= delay;
			
			for (int i = 1; i < order; i++)// next_delay[1] <= delay[0] ...
			begin
				next_delay[i] <= delay[i - 1];
			end
			multInValid <= 4'b1111;//multiplier input is valid when x_valid is low, as this is when signal values are stable
		end
	end
	
endmodule
