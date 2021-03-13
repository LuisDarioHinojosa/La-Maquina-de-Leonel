  
module ControlUnit(
    input logic clk, // for clock signal 
    input logic rst, // upon reset transfer to fetch state
    input logic int_req, //interruption requirement (int quiero pensar)
    input logic inst_ack_i, // fetch to transfer state
    input logic [6:0] op_i, // opcode
    input logic [2:0] func_i, // function
    input logic data_ack_i,

    output logic op2_c, // sregister bank-alu mux selector
    output logic [3:0] ALUOp_o, // ALU SELECTOR
    output logic ALUFR_o, // Para el write enable del nuevo registro
    output logic ALUEN_o, // Alu enable 
    output logic RegWrt_o, // reg 
    output logic [1:0] RegMux_c,
    output logic PCEN_o,
    output logic [4:0] PCoper_o,
    output logic ret_o,
    output logic jbs_o,
    output logic DPMUX_o,
    output logic reti_o,
    output logic int_o,
    output logic stb_o, // generate aknowledge so IR saves instruction
    output logic cyc_o, // generate aknowledge so IR stuff saves instruction
    output logic port_we_o,
    output logic data_we_o,
    output logic data_stb_o,
    output logic data_cyc_o,
    output logic int_ack_o

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

always_comb branch = (op_i[6:1] == 6'b111110);
always_comb jump = (op_i[6:2] == 5'b11110);
always_comb misc = (op_i == 7'b1111110);
always_comb mem = (op_i[6:5] == 2'b10);
always_comb shift = (op_i[6:4] == 3'b110);
always_comb alu_immed = (op_i[6] == 1'b0);
always_comb alu_reg = (op_i[6:3] == 4'b1110);

// Particular operations 
logic vait, stby,ldm,inp,out,stm;
logic port_ack_i = 1'b1;



always_comb vait = (func_i == 3'b100);
always_comb stby = (func_i == 3'b101);
always_comb ldm = (func_i[2:1] == 2'b00);
always_comb stm = (func_i[2:1] == 2'b01);
always_comb inp = (func_i[2:1] == 2'b10);
always_comb out = (func_i[2:1] == 2'b11);
/*
always_comb ldm = (func_i == {2'b00,1'bx});
always_comb stm = (func_i == {2'b01,1'bx});
always_comb inp = (func_i == {2'b10,1'bx});
always_comb out = (func_i == {2'b11,1'bx});
*/

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
                    else if (((branch | jump) & !inter) |(misc & !(vait | stby) & !inter)) NEXT <= FETCH_STATE;
                    else if( alu_immed | alu_reg | shift | mem) NEXT <= EXECUTE_STATE;
                    else NEXT <=INT_STATE; 
                end


            EXECUTE_STATE: // INT,FETCH,MEM,WRITEBACK
                begin
                    if( (mem & stm & data_ack_i & inter) | (mem & out & port_ack_i & inter) ) NEXT <= INT_STATE;
                    else if (!mem | (mem & ldm & data_ack_i) |(mem & inp & port_ack_i) ) NEXT <= WRITEBACK_STATE;
                    else if ( (mem & (ldm | stm) & !data_ack_i) | (mem & (inp | out) & !port_ack_i) ) NEXT <= MEM_STATE;
                    else NEXT <= FETCH_STATE;
                end

            MEM_STATE: // WRITEBACK, FETCH, MEM, INT
                begin
                    if((stm & data_ack_i & !inter)|(out & port_ack_i & !inter)) NEXT <= FETCH_STATE;
                    else if((stm & data_ack_i & inter)|(out & port_ack_i & inter)) NEXT <= INT_STATE;
                    else if((ldm & data_ack_i)|(inp & port_ack_i)) NEXT <= WRITEBACK_STATE;
                    else NEXT <= MEM_STATE;
                end

            INT_STATE       : NEXT <= FETCH_STATE;

            WRITEBACK_STATE : NEXT <= (inter) ? INT_STATE : FETCH_STATE;
        endcase
    end







logic [3:0] aluSelector;

always_comb 
    begin
        if(alu_immed | alu_reg)
            begin
                case(func_i)
                    3'b000 : aluSelector = 4'b0000;
                    3'b001 : aluSelector = 4'b0001;
                    3'b010 : aluSelector = 4'b0010;
                    3'b101 : aluSelector = 4'b0101;
                    3'b110 : aluSelector = 4'b0110;
                    3'b111 : aluSelector = 4'b0111;
                    default: aluSelector = 4'b0000;
                endcase
            end
        else if(shift)
            begin
                case(func_i[1:0])
                    2'b00 : aluSelector = 4'b1000;
                    2'b01 : aluSelector = 4'b1001;
                    2'b10 : aluSelector = 4'b1010;
                    2'b11 : aluSelector = 4'b1011;
                    default: aluSelector = 4'b1000;
                endcase
            end
        else aluSelector = 4'b0000;
        
    end






/*
                    if() NEXT <= FETCH_STATE;
                    else if() NEXT <= INT_STATE;
                    else if() NEXT <= WRITEBACK_STATE;
                    else NEXT <= MEM_STATE;
*/

assign ALUOp_o =  (DECODE_STATE | EXECUTE_STATE | WRITEBACK_STATE) ? aluSelector : 4'bxxxx;
assign RegWrt_o = (STATE == WRITEBACK_STATE);
assign int_ack_o = (STATE == INT_STATE);
assign stb_o = (STATE == FETCH_STATE);
assign cyc_o = (STATE == FETCH_STATE);



endmodule
