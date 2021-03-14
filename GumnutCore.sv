module GumnutCore(
    input logic clk,
    input logic rst,
    input logic int_req,
    input logic [7:0]port_dat_i,
    input logic port_ack_i,
    input logic clkEn_i,

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
logic PCEn_w; // este no es de la alu
logic PCopper_w; // este no es de la alu
logic ret_w; // este no es de la alu
logic jbs_w; // este no es de la alu
logic DPMux_w; 
logic reti_w;
logic int_w; // este no es de laalu


// Processing unit wires
logic c_w,z_w,restoreC_w,restoreZ_w;
logic [11:0] disp_w,updated_PC_w;
logic [7:0] adrr_w;

// IntRegister wires
logic [11:0] PCint_w;




ControlUnit controlUnit (.clk(clk),.rst(rst),.int_req(int_req),.inst_ack_i(ack_w),.stb_o(inst_stb_w),.cyc_o(inst_cyc_w),.data_we_o(date_we_w),.data_stb_o(data_stb_w),.data_cyc_o(data_cyc_w),.data_ack_i(data_ack_w),.int_ack_o(int_ack),.port_we_o(port_we_w),.op2_c(op2_w),.ALUOp_o(ALUOp_w),.ALUFR_o(ALUFR_w),.ALUEN_o(ALU_En_w),.RegWrt_o(RegWrt_w),.RegMux_c(RegMux_w),.PCEN_o(PCEn_w),.PCoper_o(PCopper_w),.ret_o(ret_w),.jbs_o(jbs_w),.DPMUX_o(DPMux_w),.reti_o(reti_w),.int_o(int_w));

ProgramCounter programCounter(.PC_o(inst_addr_w),.PC_i(updated_PC_w),.clk(clk),.rst(rst),.we(PCEn_w),.cen(clkEn_i));

ABAJO_UNIT pr_unit(.ClkEn_e(clkEn_i),.clk_i(clk),.rst_i(rst),.inst_ack_i(ack_w),.inst_dat_i(inst_dat_w),.rs_o(data_dati_w),.aluRes(data_addr_w),.data_dat_i(data_dato_w),.port_dat_i(port_dat_i),.port_data_o(port_dat_o),.port_addr_o(port_adr_o),.port_we_o(port_we_w),.op2_c(op2_w),.ALUOp_c(ALUOp_w),.ALUFR_c(ALUFR_w),.ALUEn_c(ALU_En_w),.RegWrt_c(RegWrt_w),.RegMux_c(RegMux_w),.DPMux_c(DPMux_w),.iwe(reti_w),.carry_e(c_w),.zero_e(z_w),.intc_i(restoreC_w),.intz_i(restoreZ_w),.addr_e(adrr_w),.disp_e(disp_w));

InstMemory intsmem (.clk_i(clk),.cyc_i(inst_cyc_w),.stb_i(inst_stb_w),.ack_o(ack_w),.adr_i(inst_addr_w),.dat_o(inst_dat_w));

DataMemory datamem(.clk_i(clk),.cyc_i(data_cyc_w),.stb_i(data_stb_w),.we_i(date_we_w),.ack_o(data_ack_w),.adr_i(data_addr_w),.dat_i(data_dati_w),.dat_o(data_dato_w));

IntReg intRegister(.pc_i(inst_addr_w),.c_i(c_w),.z_i(z_w),.clk(clk),.cen(),.rst(rst),.we(int_w),.pc_o(PCint_w),.intc_o(restoreC_w),.intz_o(restoreZ_w));

NewPc updatePC(.PCoper_i(PCopper_w),.zero_i(z_w),.carry_i(c_w),.int_i(PCint_w),.stk_i(),.offset_i(adrr_w),.jump_i(disp_w),.PC_i(inst_addr_w),.PC_o(updated_PC_w));





//port_we_o muxesillo
always_ff @( posedge clk )
    begin
        port_we_o = port_we_w;
    end



// Outputs
//assign port_we_o = port_we_w;



endmodule
