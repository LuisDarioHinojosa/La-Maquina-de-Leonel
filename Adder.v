/*
Luis Dario Luis Felipe Arturo Sosa
Equipo 4
*/

module Adder(
	input [7:0]IA,
	input [7:0]IB,
	input cin,
	output [7:0] IS,
	output cout

);


// los primeros 8 bits me los metes a IS y el ´+1 a cout
assign {cout,IS} = IA + IB + cin;



endmodule
