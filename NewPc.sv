// if it is jumo it takes jumo out, if it is branch it takes pc + offset 
//and otherwise it takes pc +1 
module NewPc(
    input logic [3:0]  PCoper_i,
    input logic        zero_i,
    input logic        carry_i,
    input logic [11:0] int_i, // viene con banderas de carry out y zero pero haro dice que se ignoran
    input logic [11:0] stk_i,
    input logic [7:0]  offset_i, //disp_o from IS and branch addition
    input logic [11:0] jump_i, // address from IS and jump selection
    input logic [11:0] PC_i, // current pc
    output logic [11:0] PC_o // output pc  
);


// bit extender 8-12
logic [11:0] offsetExpand,adderOutput;
logic [11:0] adderMux,jumpStackMux, mux3wire;


assign offsetExpand = {4'b0000,offset_i};

// usefull wires
logic taken, sel1, sel2,sel3;

assign sel2 = PCoper_i[1]; // jump/stack selector
assign sel3 = PCoper_i[0]; // selector interruption 1

// combinational logic for the taken
always_comb 
    begin
        case(PCoper_i[1:0])
            2'b00 : taken = zero_i;
            2'b01 : taken = ~zero_i; 
            2'b10 : taken = carry_i;
            2'b11 : taken = ~carry_i; 
        endcase   
    end


assign sel1 = taken & PC_i[2]; //this is the adder's mux's selector


// decides whether to sum one of the 12-bit offset
always_comb 
    begin
        case(sel1)
            1'd1 : adderMux = offsetExpand;
            1'b0 : adderMux = 1; 
        endcase   
    end


// decides wether to select the jump or the stack
always_comb 
    begin
        case(sel2)
            1'd1 : jumpStackMux = stk_i;
            1'b0 : jumpStackMux = jump_i; 
        endcase   
    end

assign adderOutput = adderMux + PC_i;

// mux interuption one

// decides wether to select the jump or the stack
always_comb 
    begin
        case(sel3)
            1'd1 :  mux3wire = 12'b1;
            1'b0 :  mux3wire = int_i;
        endcase   
    end

 // last mux for final uput
always_comb 
    begin
        case(PCoper_i[3:2])
            2'b00 : PC_o = adderOutput;
            2'b01 : PC_o = adderOutput;
            2'b10 : PC_o = jumpStackMux;
            2'b11 : PC_o = mux3wire;
        endcase   
    end

endmodule
