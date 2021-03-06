/*
Luis Dario Luis Felipe Arturo Sosa
Equipo 4
*/



module ALUNEXT(
	input[7:0]A, // 8 BIT FIRDT INPUT
	input[7:0]B, // B BIT SECOND INPUT
	input[1:0]S, // SELECTOR
	input cin, // new carry in input
	output[7:0]OPA, // adder operand a
	output reg [7:0]OPB, // adderoperand b
	output reg c // CARRY

);

always @(*)
	begin
		case(S)
			2'b00: OPB = B;
			2'b01 : OPB = B;
			2'b10 : OPB = ~B;
			2'b11 : OPB = ~B;
			default: OPB = B;
		endcase
	end

// generate new carry logic according to the mux
always@(*)
	begin
		case(S)
			2'b00: c = 1'b0;
			2'b01 : c = cin;
			2'b10 : c = 1'b1;
			2'b11 : c = ~cin;
			default: c = cin;
		endcase
	end

assign OPA = A;



	
endmodule