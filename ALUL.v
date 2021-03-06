/*
Luis Dario Luis Felipe Arturo Sosa
Equipo 4
*/

module ALUL(
		input [7:0] A,
		input [7:0] B,
		input [1:0] S,
		output reg [7:0]OUT
		
);

always @(*)
	begin
		case(S)
			2'b00: OUT = A & B;
			2'b01: OUT = A | B;
			2'b10: OUT = A ^ B;
			2'b11: OUT = ~A;
		endcase
	end
	
	


endmodule