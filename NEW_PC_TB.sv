module NEW_PC_TB();


logic [3:0]  PCoper_i;
    logic        zero_i;
    logic        carry_i;
    logic [11:0] int_i; // viene con banderas de carry out y zero pero haro dice que se ignoran
    logic [11:0] stk_i;
    logic [7:0]  offset_i; //disp_o from IS and branch addition
    logic [11:0] jump_i; // address from IS and jump selection
    logic [11:0] PC_i; // current pc
    logic [11:0] PC_o; // output pc


NewPc pcnew(
    .PCoper_i(PCoper_i),
    .zero_i(zero_i),
    .carry_i(carry_i),
    .int_i(int_i), 
    .stk_i(stk_i),
    .offset_i(offset_i), 
    .jump_i(jump_i), 
    .PC_i(PC_i), 
    .PC_o(PC_o)
);






	task Initialvalues();
    PCoper_i = 0;
    zero_i = 1;
    carry_i = 1;
    int_i = 12'b000000000010; 
    stk_i =  12'b000000000011; 
    offset_i = 8'b00001000; 
    jump_i = 12'b000000000111; 
    PC_i = 0; 
    PC_o = 0;
	endtask


    initial begin
        Initialvalues();
        #10;
        #10;
        PC_i = 0;
        PCoper_i = 4'b0000;
        #10;

        #10;
        PC_i = 0;
        PCoper_i = 4'b0100;
        #10;

        #10;
        PC_i = 0;
        PCoper_i = 4'b0101;
        #10;


        #10;
        PC_i = 0;
        PCoper_i = 4'b0110;
        #10;

        #10;
        PC_i = 0;
        PCoper_i = 4'b0111;
        #10;

        #10;
        PC_i = 0;
        PCoper_i = 4'b1000;
        #10;


        #10;
        PC_i = 0;
        PCoper_i = 4'b1100;
        #10;

        #10;
        PC_i = 0;
        PCoper_i = 4'b1010;
        #10;



        #10;
        PC_i = 0;
        PCoper_i = 4'b0000;
        #10;


        #10;
        PC_i = 0;
        PCoper_i = 4'b0000;
        #10;

        #10;
        PC_i = 0;
        PCoper_i = 4'b0000;
        #10;




    end





endmodule
