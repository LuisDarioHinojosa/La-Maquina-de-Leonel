module ControlUnit(
    input logic clk, // for clock signal 
    input logic rst, // upon reset transfer to fetch state
    input logic int_req, //interruption requirement (int quiero pensar)
    input logic inst_ack_i, // fetch to transfer state
    input logic [6:0] op_i, // opcode
    input logic [2:0] func_i, // function
    input logic data_ack_i,

    output logic op2_c, // sregister bank-alu mux selector
    output logic ALUOp_o, // ALU SELECTOR
    output logic ALUFR_o, // Para el write enable del nuevo registro
    output logic ALUEN_o, // Alu enable 
    output logic RegWrt_c, // reg 
    output logic [1:0] RegMux_c,
    output logic PCEN_o,
    output logic [4:0] PCoper_o,
    output logic ret_o,
    output logic jbs_o,
    output logic DPMUX_o,
    output logic reti_o,
    output logic int_o,
    output logic stb_o,
    output logic cyc_o,
    output logic port_we_o,
    output logic data_we_o,
    output logic data_stb_o,
    output logic data_cyc_o

);


// states encoding
parameter FETCH_STATE     = 3'b000;
parameter DECODE_STATE    = 3'b001;
parameter EXECUTE_STATE   = 3'b010;
parameter INT_STATE       = 3'b011;
parameter MEM_STATE       = 3'b100;
parameter WRITEBACK_STATE = 3'b101;


// OPCODE contitions
logic branch,jump,misc,mem,alu_immed,alu_reg,shift;

always_comb branch = (op_i[6:1] == 5'b111110);
always_comb jump = (op_i[6:2] == 5'b11110);
always_comb misc = (op_i == 7'b1111110);
always_comb mem = (op_i[6:5] == 2'b10);
always_comb shift = (op_i[6:4] == 3'b110);
always_comb alu_immed = (op_i[6] == 1'b0);
always_comb alu_reg = (op_i[6:3] == 4'b1110);

// Particular operations 
logic vait, stby,ldm,inp,out,stm;


always_comb vait = (func_i == 3'b100) & misc;
always_comb stby = (func_i == 3'b101) & misc;
always_comb ldm = (func_i == {2'b00,1'bx}) & mem;
always_comb stm = (func_i == {2'b01,1'bx}) & mem;
always_comb inp = (func_i == {2'b10,1'bx}) & mem;
always_comb out = (func_i == {2'b11,1'bx}) & mem;

// interruption
logic inter;
always_comb inter = int_req; 
// state transition

// for encoding state transition
logic [2:0] STATE, NEXT; 

// pus el clock ese
always_ff @( posedge clk ) 
    begin 
        if(rst) STATE <= FETCH_STATE;
        else STATE <= NEXT;
    end

// NEXT <= (misc & (vait | stby) & !inter) ? DECODE_STATE : ((branch & !inter)|(jump & !inter)|(misc & !(vait | stby) & !inter)) ? FETCH_STATE: (alu_immed | alu_reg | shift | mem) ? EXECUTE_STATE : INT_STATE;

always_comb 
    begin
        case(STATE)

            FETCH_STATE     : NEXT <= (inst_ack_i) ? DECODE_STATE : FETCH_STATE;

            DECODE_STATE    : 
                begin
                    if(misc & (vait | stby) & !inter) NEXT <= DECODE_STATE;
                    else if ((branch & !inter)|(jump & !inter)|(misc & !(vait | stby) & !inter)) NEXT <= FETCH_STATE;
                    else if( alu_immed | alu_reg | shift | mem) NEXT <= EXECUTE_STATE;
                    else NEXT <=INT_STATE; 
                end

            EXECUTE_STATE   :
                begin
                    if((mem & stm & data_ack_i & !inter) | (mem & out & !inter)) NEXT <= FETCH_STATE; // mem & out & !inter & port_ack_i
                    else if((mem & stm & data_ack_i & inter) | (mem & out & inter)) NEXT <= INT_STATE; //  mem & out & inter & port_ack_i
                    else if ((mem & (ldm | stm) & ! data_ack_i)|(mem & (inp | out))) NEXT <= MEM_STATE; // (mem & (inp | out) & port_ack_i)
                    else NEXT <= WRITEBACK_STATE;
                end

            INT_STATE       : NEXT <= FETCH_STATE;

            MEM_STATE       :
                begin
                    if((stm & data_ack_i & !inter)|(out & !inter))  NEXT <= FETCH_STATE; // out & port_ack_i &!inter
                    else if((stm & data_ack_i & inter)|(out & inter))  NEXT <= INT_STATE; // out & port_ack_i & inter  
                    else if((ldm & data_ack_i)|(inp))  NEXT <= WRITEBACK_STATE; // inp & port_ack_i
                    else NEXT <= MEM_STATE;
                end

            WRITEBACK_STATE : NEXT <= (inter) ? INT_STATE : FETCH_STATE;
        endcase
    end







endmodule
