module ABAJO_UNIT(
    input logic clk_i,
    input logic rst_i,
    input logic RegWrt_c,
    input logic ClkEn_e,
    input logic data_dat_i, // FOR MUX
    input logic port_dat_i, // FOR MUX
    input logic [1:0] RegMux_c, // SELECTOR FOR FIRST MUX
    input logic [17:0] inst_dat_i, // this is the 18 bit data bus
    input logic inst_ack_i, // this is the register enable
    input logic op2_c, // REGISTERS-ALU INTERMEDIANTE MUX SELECTOR


    //output logic [2:0] op_e, // operation code
    output logic [6:0] op_e, // segun leonel esto es de 7 bits
    output logic [2:0] func_e, // function code
    output logic [11:0] addr_e, // wire to IS address outout
    output logic [7:0] disp_e, // wire to IS reset disp output
    output logic [7:0] offset_e, // wire to IS offset output
    output logic rs_o, // rs_i de DATEMEM
    output logic carry_e, // the borrow logic will be handled insside the ALU
    output logic zero_e
    //output logic rd_0 // OUTPUT PARA AFUERA 
);



// Wires section
logic [2:0]  funcWire;
logic [6:0] opWire;
logic [11:0] addressWire;
logic [7:0] dispWire,offstWire;



// IR - DATABANK WIRES
logic [2:0] rs_int, rs2_int,rd_int;

// Registers-ALU Wires
logic [7:0] rs_alu, rs2_alu, rd_alu, m, immed_alu;

// IS-ALU Wires
logic [2:0] count_int;
logic [7:0] res_int, m2, D_i;

IS is(.clk(clk_i),.enable(inst_ack_i),.inst_i(inst_dat_i),.ack_i(inst_ack_i) ,.op_o(opWire),.func_o(funcWire),.addr_o(addressWire),.disp_o(dispWire),.offset_o(offstWire),.rs_o(rs_int),.rs2_o(rs2_int),.rd_o(rd_int),.immed_o(immed_alu),.count_o(count_int));


DATA_BANK registers(.clk(clk_i),.rst(rst_i),.cen(ClkEn_e),.we(RegWrt_c),.rs_i(rs_int),.rs2_i(rs2_int),.rd_i(rd_int),.rs_o(rs_alu),.rs2_o(rs2_alu),.dat_i(m2));



// Wire REGISTERS-ALU MUX 2 TO 1
always_comb
    begin
        case(op2_c)
            1'b0: m = rs2_alu;
            1'b1: m = immed_alu;
            default: m = rs2_alu;
        endcase
    end


// flag wires
logic zf, cf;

ALU_GUMNUT alu (.rs_i(rs_alu),.op2_i(m),.count_i(count_int),.zero_o(zf),.carry_o(cf),.res_o(res_int),.carry_i(ff_cout));

// wire ALU-REGISTERS MUX 4 to 1
/*
always_comb
    begin
        case(RegMux_c)
            2'b00: m2 = res_int;
            2'b01: m2 = data_dat_i;
            2'b10: m2 = port_dat_i;
            2'b11: m2 = res_int;
            default : m2 = res_int;
        endcase
    end
*/


MUX_41 mux(.A(res_int),.B(data_dat_i),.C(port_dat_i),.S(RegMux_c),.M(m2));


logic ff_cout; 
FlipFlop ff(.clk(clk_i),.rst(rst_i),.clock_en(ClkEn_e),.cin(cf),.cout(ff_cout));


// Straightforwars outputs 

always_comb op_e = opWire;

always_comb func_e = funcWire;

always_comb addr_e = addressWire;

always_comb disp_e = dispWire;

always_comb offset_e = offstWire;

always_comb rs_o = rs_alu;

always_comb carry_e = cf;

always_comb zero_e = zf;

endmodule

