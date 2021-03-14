module GumnutCore(
    input logic clk,
    input logic rst,
    input logic int_req,
    input logic [7:0]port_dat_i,
    input logic port_ack_i,

    output logic int_ack,
    output logic [7:0] port_adr_o,
    output logic port_cyc_o,
    output logic [7:0 ]port_dat_o,
    output logic port_stb_o,
    output logic port_we_o

);


// wires

// INST_MEMORY 
logic inst_cyc_w;
logic inst_stb_w;
logic ack_w; // inst_ack_i
logic [17:0] inst_dat_w;
logic [11:0] inst_addr_w;


// data memory
logic data_cyc_w;
logic data_stb_w;
logic date_we_w;
logic data_ack_w;
logic [7:0] data_addr_w;
logic [7:0] data_dati_w;
logic [7:0] data_dato_w;


// Control unit
logic port_we_w;
logic op2_w;
logic [3:0] ALUOp_w;
logic ALUFR_w;
logic ALU_En_w;
logic RegWrt_w;
logic [1:0] RegMux_w;
logic PCEn_w;
logic PCopper_w;
logic ret_w;
logic jbs_w;
logic DPMux_w;
logic reti_w;
logic int_w;




ControlUnit controlUnit (.clk(clk),.rst(rst),.int_req(int_req),.inst_ack_i(ack_w),.stb_o(inst_stb_w),.cyc_o(inst_cyc_w),.data_we_o(date_we_w),.data_stb_o(data_stb_w),.data_cyc_o(data_cyc_w),.data_ack_i(data_ack_w),.int_ack_o(int_ack),.port_we_o(port_we_w));

ProgramCounter programCounter(.PC_o(inst_addr_w));

ABAJO_UNIT pr_unit(.clk_i(clk),.rst_i(rst),.inst_ack_i(ack_w),.inst_dat_i(inst_dat_w),.rs_o(data_dati_w),.aluRes(data_addr_w),.data_dat_i(data_dato_w),.port_dat_i(port_dat_i),.port_data_o(port_dat_o),.port_addr_o(port_adr_o),.port_we_o(port_we_w));

InstMemory intsmem (.clk_i(clk),.cyc_i(inst_cyc_w),.stb_i(inst_stb_w),.ack_o(ack_w),.adr_i(inst_addr_w),.dat_o(inst_dat_w));

DataMemory datamem(.clk_i(clk),.cyc_i(data_cyc_w),.stb_i(data_stb_w),.we_i(date_we_w),.ack_o(data_ack_w),.adr_i(data_addr_w),.dat_i(data_dati_w),.dat_o(data_dato_w));



//port_we_o muxesillo
always_ff @( posedge clk )
    begin
        port_we_o = port_we_w;
    end



// Outputs
//assign port_we_o = port_we_w;



endmodule
