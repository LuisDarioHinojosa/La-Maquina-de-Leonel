module FlipFlop(
    input logic clk,
    input logic rst,
    input logic clock_en,
    input logic cin,
    output logic cout
);

logic clkg;

always_comb clkg = clk & clock_en;

always_ff @ (posedge clkg or posedge rst)
	begin
		if(rst) cout <= 0;
		else cout <= cin;
	end



endmodule
