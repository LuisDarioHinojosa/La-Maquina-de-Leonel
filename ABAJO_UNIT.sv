module ABAJO_UNIT(
    input logic clk_i,
    input logic rst_i,
    input logic RegWrt_c,
    input logic ClkEn_e,
    input logic data_dat_i,
    input logic port_data_i, 
    input logic [17:0] inst_dat_i, // this is the 18 bit data bus
    input logic inst_ack_i, // this is come useless input
    input logic op2_c, // REGISTERS-ALU INTERMEDIANTE MUX SELECTOR


    output logic [2:0] op_e, // operation code
    output logic [2:0] func_e, // function code
    output logic [11:0] addr_e, // wire to IS address outout
    output logic [7:0] disp_e, // wire to IS reset disp output
    output logic [7:0] offset_e, // wire to IS offset output
    output logic rs_o, // rs_i de DATEMEM
    output logic carry_e,
    output logic zero_e,
    output logic rd_0 // OUTPUT PARA AFUERA 
);



// Wires section
logic [2:0] opWire, funcWire;
logic [11:0] addressWire;
logic [7:0] dispWire,offstWire;



// IR - DATABANK WIRES
logic [2:0] rs_int, rs2_int,rd_int;

// Registers-ALU Wires
logic [7:0] rs_alu, rs2_alu, rd_alu, m, immed_alu;

// IS-ALU Wires
logic [2:0] count_int;

IS is(.inst_i(inst_dat_i),.ack_i(inst_ack_i) ,.op_o(opWire),.func_o(funcWire),.addr_o(addressWire),.disp_o(dispWire),.offset_o(offstWire),.rs_o(rs_int),.rs2_o(rs2_int),.rd_o(rd_int),.immed_o(immed_alu),.count_o(count_int));


DATA_BANK registers(.clk(clk_i),.rst(rst_i),.cen(ClkEn_e),.we(RegWrt_c),.rs_i(rs_int),.rs2_i(rs2_int),.rd_i(rd_int),.rs_o(rs_alu),.rs2_o(rs2_alu));



// Wire REGISTERS-ALU MUX 2 TO 1
always_comb
    begin
        case(op2_c)
            1'b0: m = rs2_alu;
            1'b1: m = immed_alu;
        endcase
    end



ALU_GUMNUT alu (.rs_i(rs_alu),.op2_i(m),.count_i(count_int));


// Straightforwars outputs 

always_comb op_e = opWire;

always_comb func_e = funcWire;

always_comb addr_e = addressWire;

always_comb disp_e = dispWire;

always_comb offset_e = offstWire;

always_comb rs_o = rs_alu;



endmodule

