/*
Luis Dario Luis Felipe Arturo Sosa
Equipo 4
*/

module ALUA(
	input [7:0]A,
	input [7:0]B,
	input [1:0]S,
	input cin,
	output [7:0] IS,
	output Cout, // Carry Out Flag
	output OV // Overload
);

wire [7:0]opa; 
wire [7:0]opb; 
wire c,cOut; 


ALUNEXT alu(.A(A),.B(B),.S(S),.cin(cin),.OPA(opa),.OPB(opb),.c(c));
Adder add(.IA(opa),.IB(opb),.cin(c),.IS(IS),.cout(cOut));


assign Cout = cOut;
assign OV = ( ~opa[7] & ~opb[7] & IS[7]) | (opa[7] & opb[7] & ~IS[7]);



endmodule