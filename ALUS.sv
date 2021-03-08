module ALUS(
	input logic [7:0] A,
	input logic [2:0] Cnt,
	input logic [1:0] sel,
	output logic [7:0] S,
	output logic Co
);


	always_comb begin 		
		case (sel)		// This implements a 4 to 1 Mux 
			2'b00: {Co,S} =  {1'b0,A} << Cnt;  // Shiftleft by Cnt times; last bit shifted past 8 bit boundary captured as Carry
			2'b01: {S,Co} =  {A,1'b0} >> Cnt;  // Shiftright by Cnt times; last bit shifted past 8 bit boundary captured as Carry
			2'b10: begin
						   S  = (A << Cnt) | (A >> (8 - Cnt));   // Rotate left by Cnt times by combining opposite parallel Shl Shr
							Co = S[0];
					end
			2'b11: begin 
							S  = (A >> Cnt) | (A << (8 - Cnt));  // Rotate right by Cnt times by combining opposite parallel Shl Shr
							Co = S[7];
					end
			default: {Co,S} =  {1'b0,A} << Cnt;
		endcase
	end






endmodule


