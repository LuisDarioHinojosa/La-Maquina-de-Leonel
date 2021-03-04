/*
module DATA_BANK_TB;

	// Inputs
	logic clk;
	logic [7:0] W_data;
	logic [2:0] W_addr;
	logic 		W_en;
	logic [2:0] R_addr;
	logic [2:0] R2_addr;

	// Outputs
	logic [7:0] R_data;
	logic [7:0] R2_data;

	// Instantiate the Unit Under Test (UUT)
	regfileII uut (
		.clk(clk), 
		.W_data(W_data), 
		.W_addr(W_addr), 
		.W_en(W_en), 
		.R_addr(R_addr), 
		.R_en(R_en), 
		.R_data(R_data)
	);

*/


module DATA_BANK_TB;

	// Inputs
	logic clk, // clock
	logic cen, // clock enable
	logic rst, // reset
	logic [2:0] rs_i, // selector mux1
	logic [2:0] rs2_i, // selector mux2

	logic [2:0] rd_i, // 
	logic [7:0] dat_i,
	logic we, //



	logic [7:0] rs_o, // output 1
	logic [7:0] rs2_o // output 1  

	// Instantiate the Unit Under Test (UUT)
	DATA_BANK uut (
		.clk(clk),
		.cen(cen), 
		.rst(rst), 
		.rs_i(rs_i), 
		.rs2_i(rs2_i), 
		.dat_i(dat_i), 
		.we(we), 
		.rs_o(rs_o),
		.rs2_o(rs2_o)
	);



	initial begin
		// Initialize Inputs
		clk = 0;
		cen = 0;
		W_addr = 0;
		W_en = 0;
		R_addr = 0;
		R_en = 0;

		// Wait 100 ns for global reset to finish
		#20;

		W_data = 8'hFF;
		W_addr = 0;
		W_en = 1;
		R_addr = 0;
		R_en = 0;

		#10;
		W_data = 8'hFE;
		W_addr = 1;
		
		#10;
		W_data = 8'hAA;
		W_addr = 2;
		
		#5;
		R_addr = 1;
		R_en = 1;
		
		#5;
		W_data = 8'h5A;
		W_addr = 15;
		
		#10;
		R_addr = 15;
		R_en = 0;
		
		#10;
		R_addr = 15;
		R_en = 1;
		
		#5;
		W_en = 0;
		
	
		
		// Add stimulus here

	end
      
	initial begin
	
		forever #5 clk = ~clk;
	end

endmodule