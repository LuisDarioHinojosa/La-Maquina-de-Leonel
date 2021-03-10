
// This module takes the gommut 18 bit bus and distributes it across all stuff
module IS(
    input logic clk,
    input logic enable,
    input logic  [17:0] inst_i,
    output logic [2:0]  op_o,
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
always_comb op_o =     data_backup[17:15];
always_comb func_o =   data_backup[17] ? data_backup[2:0] : data_backup[16:14];
always_comb addr_o =   data_backup[11:0];
always_comb disp_o =   data_backup[7:0];
always_comb offset_o = data_backup [7:0];
always_comb rs_o =     data_backup[10:8];
always_comb rs2_o =    data_backup[7:5];
always_comb rd_o =     data_backup [13:11];
always_comb immed_o =  data_backup[7:0];
always_comb count_o =  data_backup [7:5];

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
