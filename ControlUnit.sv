  
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
    output logic [3:0] PCoper_o,
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


// functions essential for state transitions
always_comb vait = (func_i == 3'b100) & misc;
always_comb stby = (func_i == 3'b101)&misc;
always_comb ldm = (func_i[2:1] == 2'b00)&mem; // load memory operation
always_comb stm = (func_i[2:1] == 2'b01)&mem; // store memory operation
always_comb inp = (func_i[2:1] == 2'b10)&mem;
always_comb out = (func_i[2:1] == 2'b11)&mem;


// return from interripcion
logic reti_rec;
always_comb  reti_rec = (func_i == 3'b001) & misc;


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





// ALU SELECTOR SET UP

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
                    default: aluSelector = 4'b0000;
                endcase
            end
        else aluSelector = 4'b0000; // creo que aqui cubre que esta cosa tenga cero en el momento de operaciones de memoria para calcular la direccion
        
    end



logic op2_selector;
always_comb 
    begin
        if(alu_reg) op2_selector = 1; // solo uno cuando las cosas estas me prueba 
        else  op2_selector = 0;
    end



// PRE ALU MUX SELECTOR SET UP

logic [3:0] regMux_selector;
    always_comb 
	begin 
        if(alu_reg | alu_immed) regMux_selector = 4'b0000;
        else if(mem) regMux_selector = 4'b0001;
        else regMux_selector = 4'b0;
    end


// DP MUX
/*
logic dpMux_selector;
    always_comb begin 
        if(mem) regMux_selector = 1;
        else regMux_selector = 0;
    end
*/
//  selector assign
logic [3:0] pcOpper_selector;
always_comb 
    begin 
        if(branch)
            begin
                case(func_i[2:1])
                    2'b00 : PCoper_o = 4'b0100;
                    2'b01 : PCoper_o = 4'b0101;
                    2'b10 : PCoper_o = 4'b0110;
                    2'b11 : PCoper_o = 4'b0111;
                    default: PCoper_o = 4'b0000;
                endcase
            end
        else if(jump) PCoper_o = 4'b1000;
        else if(inter) PCoper_o = 4'b1100;
        else if (reti_rec) PCoper_o = 4'b1011;
        else PCoper_o = 4'b0000;
    end




// outputs
assign ALUOp_o =  ((STATE == DECODE_STATE)|(STATE == EXECUTE_STATE)|(STATE == WRITEBACK_STATE)) ? aluSelector : 4'b0000;
assign op2_c = ((STATE == DECODE_STATE)|(STATE == EXECUTE_STATE)|(STATE == WRITEBACK_STATE)) ? op2_selector : 0;
assign RegMux_c = ((STATE == DECODE_STATE)|(STATE == EXECUTE_STATE)|(STATE == WRITEBACK_STATE)) ? regMux_selector : 0;
assign DPMUX_o = ( (   (STATE == DECODE_STATE)|(STATE == EXECUTE_STATE)|(STATE == WRITEBACK_STATE)|(STATE == MEM_STATE)  ) & mem ) ? 1:0;
assign RegWrt_o = (STATE == WRITEBACK_STATE);
assign int_ack_o = (STATE == INT_STATE);
assign stb_o = (STATE == FETCH_STATE);
assign cyc_o = (STATE == FETCH_STATE);
assign PCEN_o = (STATE == FETCH_STATE);
assign data_stb_o = (STATE == MEM_STATE); 
assign data_cyc_o = (STATE === MEM_STATE); 
assign data_we_o = ((STATE == MEM_STATE)&stm); // only in memory state whe you want to write en memory
assign ALUFR_o = (((STATE == EXECUTE_STATE) | (STATE == WRITEBACK_STATE)) & !mem ); // this things dont have to active in memory instruccions
assign ALUEN_o = (((STATE == EXECUTE_STATE) | (STATE == WRITEBACK_STATE)) & !mem ); //chanve hay que merer un coso aqui
assign port_we_o = (((STATE == EXECUTE_STATE) | (STATE == MEM_STATE)) & out); // activate when out is receibes to enable data transmition
assign reti_o = ((STATE == DECODE_STATE) & reti_rec); // activate if we receibe a in decode the return from interrup to restore program counter
assign int_o = ( (   (STATE == DECODE_STATE)|(STATE == EXECUTE_STATE)|(STATE == WRITEBACK_STATE)|(STATE == MEM_STATE)  ) & inter );
assign ret_o = ((STATE == DECODE_STATE) & reti_rec);
assign jbs_o = ((STATE == DECODE_STATE) & inter);




endmodule
