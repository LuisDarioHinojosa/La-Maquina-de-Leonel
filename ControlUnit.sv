module ControlUnit(
    input logic clk, // estos no lo se, pero pues estan chidos y toda maquina de estados los tiene
    input logic rst,
    input logic  [2:0] op_i,
    input logic  [2:0] func_i,
    input logic inst_ack_i, // es como una instruccion
    output logic       op2_o,
    output logic [3:0] ALUOp_o, // cero que esto es el selector del alu
    output logic       RegWrt_o, // el write enable de los registros
    output logic [1:0] RegMux_o, // el selector de un mux de esos
    output logic [3:0] pCooper_o, // ni idea
    output logic       pop_0,
    output logic       int_o,
    output logic [1:0] ques_mark, /// ???
    output logic       we_data,
    output logic       we_port
);


// states encoding
parameter FETCH_STATE     = 3'b000;
parameter DECODE_STATE    = 3'b000;
parameter EXECUTE_STATE   = 3'b000;
parameter INT_STATE       = 3'b000;
parameter MEM_STATE       = 3'b000;
parameter WRITEBACK_STATE = 3'b000;

// for encoding state transition
logic [2:0] STATE, NEXT; 

// pus el clock ese
always_ff @( posedge clk ) 
    begin 
        if(rst) STATE <= FETCH_STATE;
        else STATE <= NEXT;
    end



// next state transition encoding
always_comb 
    begin
        case(STATE)
            FETCH_STATE: NEXT <= (inst_ack_i) ? DECODE_STATE : FETCH_STATE;
            
        endcase
    end


endmodule
