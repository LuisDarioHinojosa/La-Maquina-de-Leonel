// adapted from: http://www.dasconference.ro/papers/2004/58_D11_Patentariu.pdf

module Stack (DataIO, Reset, Push,
Pop, SP, Full, Empty, Err);
/* declare input, output and inout
ports */
inout [3:0] DataIO; 
input Push,Pop,Reset;
output Full, Empty,Err;
output [2:0] SP;
// declare registers
reg Full,Empty,Err;
reg [2:0] SP;
reg [3:0] Stack[7:0];
reg [3:0] DataR;
/* continuous assignment of DataIO to
DataR register, with delay 0 */
wire [3:0] #(0) DataIO = DataR;

always @ (posedge Push or posedge Pop or posedge Reset) begin

if (Push==1) begin
	 // when the stack is empty
    if (Empty==1) begin
        Stack[SP] = DataIO;
        Empty = 0;
		  if (Err==1)
			  Err=0;
    end
	 // when the stack is full
    else if (Full==1) begin
        Stack[SP] = DataIO;
         Err = 1;
    end
    else begin
        SP = SP +1;
        Stack [SP] = DataIO;
		 if (SP == 3'b111)
			  Full = 1;
    end
end

if(Pop==1) begin
/* if SP indicates the last location but the stack is not empty */
	if ((SP == 3'b000) && (Empty!=1)) begin
		 DataR = Stack[SP];
		 Empty = 1;
	end
	else if(Empty==1) begin// if the stack is emtpy
		 DataR = Stack[SP];
		 Err = 1;
	end
	else begin
		DataR = Stack[SP];
		if (SP != 3'b000)
			SP = SP-1;
	// if the stack is full
		if (Err==1) 
			Err = 0;
		if (Full==1) 
			Full = 0;
	end
end


if (Reset==1) begin
    DataR = 4'bzzzz;
    SP = 3'b0;
    Full = 0;
    Empty = 0;
    Err = 0;
end

end


always @ (negedge Pop) begin
    DataR = 4'bzzzz;
end

endmodule
