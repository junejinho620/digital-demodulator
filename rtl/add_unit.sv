`timescale 1ns/1ps

module adder #(
    parameter DATA_W = 24
) 
(   
    /*
        This module contains signals used for pipelining (ready/valid),
        the only signal to worry about is o_valid which is set to the logic value
        of delayed_i_valid. delayed_i_valid should be asserted when the output of your 
        module is finished computing and is ready at the output.
    */
    input logic clk,
    input logic reset,
    //input is valid
    input logic i_valid,
    //consumer module (downstream module in which c is the input) is ready for new inputs
    input logic i_ready,
    input logic signed [DATA_W-1:0] i_a,
    input logic signed [DATA_W-1:0] i_b,
    // signed so output datawidth should be [DATA_WIDTH-1+1:0]
    output logic signed [DATA_W:0] o_c,
    //the output is valid
    output logic o_valid,
    //the module is ready to receive a new input
    output logic o_ready
);

	// This should be asserted when your modules output data is ready.
	// There is only a single delayed valid signal in this case as the computation is expected to
	// take a single cycle, for a multi cycle module which takes X cycles the o_valid needs to be delayed X cycles

	//logic delayed_i_valid;
    
    always@(posedge clk)
    begin
        
        if (reset)
        begin
            o_c <= 0;
            o_valid <= 0;
        end
        else if (i_valid && i_ready)
        begin
            o_c <= i_a + i_b;
            o_valid <= 1;
        end
        else if (!i_valid && i_ready)
        begin
            o_c <= o_c;
            o_valid <= o_valid;
        end
        else if (i_valid && !i_ready)
        begin
            o_c <= o_c;
            o_valid <= 0;
        end
        else
        begin
            o_c <= o_c;
            o_valid <= o_valid;
        end
        
    end
    
    //assign o_valid = delayed_i_valid;
    assign o_ready = i_ready;
	 
endmodule
