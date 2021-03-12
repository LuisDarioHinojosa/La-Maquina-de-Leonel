
// This module takes the gommut 18 bit bus and distributes it across all stuff
module IS(
    input logic clk,
    input logic enable,
    input logic  [17:0] inst_i,
    output logic [6:0]  op_o, // opcode siempre de 7 bits  
    output logic [2:0]  func_o,
    output logic [11:0] addr_o,
    output logic [7:0]  disp_o,
    output logic [7:0]  offset_o,
    output logic [2:0]  rs_o,
    output logic [2:0]  rs2_o,
    output logic [2:0]  rd_o,
    output logic [7:0]  immed_o,
    output logic [2:0]  count_o

);

// Register for storing data backup
logic [17:0]data_backup = 0;

always_ff @( posedge clk ) 
    begin
        if(enable) data_backup <= inst_i;
    end







// this are te inmediate outputs
always_comb op_o =     data_backup[17:11];
always_comb func_o =   data_backup[17] ? data_backup[2:0] : data_backup[16:14];
always_comb addr_o =   data_backup[11:0];
always_comb disp_o =   data_backup[7:0];
always_comb offset_o = data_backup [7:0];
always_comb rs_o =     data_backup[10:8];
always_comb rs2_o =    data_backup[7:5];
always_comb rd_o =     data_backup [13:11];
always_comb immed_o =  data_backup[7:0];
always_comb count_o =  data_backup [7:5];

// combinational assigments for function code
/*
always_comb 
    begin
        if(data_backup[17:14] == 4'b1110) func_o =  data_backup[2:0]; // ALU
        else if(!data_backup[17]) func_o = data_backup[16:14]; // ALU-IMMED
        else if(data_backup[17:15] == 3'b110) func_o = {1'bx,data_backup[1:0]} ; // SHIFT
        else if (data_backup[17:16] == 2'b10) func_o = {data_backup[15:14],1'bx}; // memory instructions 

        else if (data_backup[17:12] ==6'b111110) func_o = {data_backup[10:11],1'bx}; // branch 
        else if (data_backup[17:13] ==  5'b11110) func_o = {data_backup[12],2'bx}; // jump
        //else if (data_backup[17:11] == 7'b1111110) 
        else func_o = data_backup[10:8]; // miscelaneo
    end

	 
*/
/*
always_comb branch = (op_i[6:1] == 7'b111110);
always_comb jump = (op_i[6:2] == 5'b11110);
always_comb misc = (op_i == 7'b1111110);
always_comb mem = (op_i[6:5] == 2'b10);
always_comb shift = (op_i[6:4] == 3'b110);
always_comb alu_immed = (op_i[6] == 1'b0);
always_comb alu_reg = (op_i[6:3] == 6'b1110);

*/
/*

always_comb op_o =     inst_i[17:11];
always_comb func_o =   inst_i[17] ? inst_i[2:0] : inst_i[16:14];
always_comb addr_o =   inst_i[11:0];
always_comb disp_o =   inst_i[7:0];
always_comb offset_o = inst_i [7:0];
always_comb rs_o =     inst_i[10:8];
always_comb rs2_o =    inst_i[7:5];
always_comb rd_o =     inst_i [13:11];
always_comb immed_o =  inst_i[7:0];
always_comb count_o =  inst_i [7:5];


*/




endmodule
