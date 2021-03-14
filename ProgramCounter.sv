

/*
module ProgramCounter(
   input logic [11:0] PC_i,
   input logic        clk,
	input logic we,
    input logic        cen, // clock enable
    input logic        rst,
    output logic[11:0] PC_o
);



logic gateClock;
assign gateClock = clk & cen;


		wire [7:0]  nxt_count;
		//wire [7:0] dnxt_count;
		
		// Combinatorial Logic
		// This implements a simple incrementer and a 2 to 1 mux based on ld as the select bit
		assign nxt_count  =  PC_o + PC_i;
		
		
		// This implements a 2 to 1 mux
		//assign dnxt_count = ld ? din : nxt_count;
		

		// Sequential Logic 
		// This implements a register with clear & enable
		always @ (posedge gateClock) begin 
			if(rst)
				PC_o <= 0;
			else if(we)
					PC_o <= nxt_count;
		end








endmodule
*/



`timescale 1ns / 1ps

module ProgramCounter(
    input logic clk,
    input logic rst,
    input logic we,
	input logic   cen, // clock enable
	input logic  [11:0] PC_i,
    output logic [11:0] PC_o
    );

		wire [11:0]  nxt_count;
		

		assign nxt_count  = PC_o + PC_i;
		
		logic gateClock;
		assign gateClock = clk & cen;	

		always @ (posedge gateClock) begin 
			if(rst)
				PC_o <= 0;
			else if(we)
					PC_o <= nxt_count;
		end

endmodule
