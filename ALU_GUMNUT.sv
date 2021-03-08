module ALU_GUMNUT(
    input logic [7:0] rs_i,
    input logic [7:0] op2_i,
    input logic [2:0] count_i,
    input logic carry_i,
    input logic [3:0]s_i, // action selector
    output logic zero_o,
    output logic carry_o,
    output logic [7:0] res_o,
    output logic OVF,
    output logic NF
);





wire w,x,y,z;

wire [1:0] S = {y,z};

assign {w,x,y,z} = s_i;


wire [7:0]SA;
wire [7:0]SL;
wire [7:0]SS;
wire co_a,co_s,of;


ALUA ari(.A(rs_i),.B(op2_i),.cin(carry_i),.S(S),.IS(SA),.Cout(co_a),.OV(of));
ALUL lol(.A(rs_i),.B(op2_i),.S(S),.OUT(SL));
ALUS shift(.A(rs_i),.Cnt(count_i),.sel(S),.Co(co_s),.S(SS));


assign res_o = w ? SS : x ? SL : SA;



assign carry_o = (w ?  co_s : co_a) & ~ x;
assign OVF = of & ~(x|w);
assign zero_o = ~|res_o;
assign NF = res_o[7];


endmodule



