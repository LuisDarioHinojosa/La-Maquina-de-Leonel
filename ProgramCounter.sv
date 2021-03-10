module ProgramCounter(
    input logic [11:0] PC_i,
    input logic        clk, 
    input logic        cen, // clock enable
    input logic        rst,
    output logic[11:0] PC_o
);

logic [11:0] backup;

logic gateClock = clk & cen;

always_ff @( posedge gateClock ) 
    begin
        if(rst) backup = 0;
        else backup = backup + PC_i;
    end

assign Pc_o = backup;


endmodule
