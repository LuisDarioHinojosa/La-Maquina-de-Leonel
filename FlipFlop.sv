


module FlipFlop(
    input logic clk,
    input logic rst,
    input logic clock_en,
    input logic we,
    input logic c_i,
    input logic z_i,
    input logic iwe,
    input logic intz_i,
    input logic intc_i,
    output logic c_o,
    output logic z_o
);

logic clkg;

always_comb clkg = clk & clock_en;

always_ff @ (posedge clkg or posedge rst)
	begin
		if(rst)
            begin
                z_o = 0;
                c_o = 0;
            end
        else if (we) // de lo que entendi si es enable normal pues storea los normales
            begin
                c_o = c_i;
                z_o = z_i;
            end
        else if(iwe) // si es de interrupcion storea los bits de interrupcion o algo ya ni se ni me importa
            begin
                c_o = intc_i;
                z_o = intz_i;
            end
	end



endmodule


/*
// Haro´s testbench adapted version

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

*/