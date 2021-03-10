module DATA_BANK(
	input logic clk, // clock
	input logic cen, // clock enable
	input logic rst, // reset
	input logic [2:0] rs_i, // selector mux1
	input logic [2:0] rs2_i, // selector mux2

	input logic [2:0] rd_i, // 
	input logic [7:0] dat_i,
	input logic we, //

	output logic [7:0] rs_o, // output 1
	output logic [7:0] rs2_o // output 1  

);

integer i;

logic [7:0] mem [7:0];

logic clkg;

logic [7:0] reg1, reg2;

always_comb clkg = clk & cen;




always_ff @ (posedge clkg or posedge rst)
	begin
		if(rst)
			for(i = 0; i <= 7; i = i +1)
				mem[i] <= 0;
			else if(we)
				mem[rd_i] <= dat_i;
	end

always_comb begin
	rs_o = mem[rs_i];
	rs2_o = mem[rs2_i];
end


always_ff @( posedge clkg ) 
	begin 
		reg1 <= rs_o;
		reg2 <= rs2_o;
	end




endmodule
