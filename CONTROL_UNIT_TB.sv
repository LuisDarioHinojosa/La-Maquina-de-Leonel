`timescale 1ns / 1ps
module CONTROL_UNIT_TB();


    //inputs
    logic clk; // for clock signal 
    logic rst; // upon reset transfer to fetch state
    logic int_req; //interruption requirement (int quiero pensar)
    logic inst_ack_i; // fetch to transfer state
    logic [6:0] op_i; // opcode
    logic [2:0] func_i; // function
    logic data_ack_i;


    // outpues
    logic op2_c;
    logic [3:0] ALUOp_o; 
    logic ALUFR_o; 
    logic ALUEN_o; 
    logic RegWrt_o; 
    logic [1:0] RegMux_c;
    logic PCEN_o;
    logic [3:0] PCoper_o;
    logic ret_o;
    logic jbs_o;
    logic DPMUX_o;
    logic reti_o;
    logic int_o;
    logic stb_o; 
    logic cyc_o; 
    logic port_we_o;
    logic data_we_o;
    logic data_stb_o;
    logic data_cyc_o;
    logic int_ack_o;
    


    

    ControlUnit fsm(

        .clk(clk),  
        .rst(rst), 
        .int_req(int_req), 
        .inst_ack_i(inst_ack_i), 
        .op_i(op_i), 
        .func_i(func_i), 
        .data_ack_i(data_ack_i),
        .op2_c(op2_c),
        .ALUOp_o(ALUOp_o), 
        .ALUFR_o(ALUFR_o), 
        .ALUEN_o(ALUEN_o), 
        .RegWrt_o(RegWrt_o), 
        .RegMux_c(RegMux_c),
        .PCEN_o(PCEN_o),
        .PCoper_o(PCoper_o),
        .ret_o(ret_o),
        .jbs_o(jbs_o),
        .DPMUX_o(DPMUX_o),
        .reti_o(reti_o),
        .int_o(int_o),
        .stb_o(stb_o), 
        .cyc_o(cyc_o), 
        .port_we_o(port_we_o),
        .data_we_o(data_we_o),
        .data_stb_o(data_stb_o),
        .data_cyc_o(data_cyc_o),
        .int_ack_o(int_ack_o)
    );


	task Initialvalues();
        clk = 0; 
        rst = 0;
        int_req = 0; 
        inst_ack_i = 0; 
        op_i = 0; 
        func_i = 0; 
        data_ack_i = 0;

        op2_c = 0;
        ALUOp_o = 0;
        ALUFR_o = 0; 
        ALUEN_o = 0; 
        RegWrt_o = 0; 
        RegMux_c = 0;
        PCEN_o = 0;
        PCoper_o = 0;
        ret_o = 0;
        jbs_o = 0;
        DPMUX_o = 0;
        reti_o = 0;
        int_o = 0;
        stb_o = 0;
        cyc_o = 0; 
        port_we_o = 0;
        data_we_o = 0;
        data_stb_o = 0;
        data_cyc_o = 0;
        int_ack_o = 0;
	endtask



	initial begin
        Initialvalues();
        
        rst = 1;
        inst_ack_i = 1;
        #20;
        rst = 0;






        // airtmeticas y logicas
        #20;
        op_i = 7'b1110000; 
        func_i = 3'b000;

        #20;
        op_i = 7'b0001000; 
        func_i = 3'b000; 







        #20;
        op_i = 7'b1110000; 
        func_i = 3'b001;

        #20;
        op_i = 7'b0001000; 
        func_i = 3'b001; 








        #20;
        op_i = 7'b1110000; 
        func_i = 3'b010;

        #20;
        op_i = 7'b0010000; 
        func_i = 3'b010;         









    
        #20;
        op_i = 7'b1110000; 
        func_i = 3'b011;

        #20;
        op_i = 7'b0011000; 
        func_i = 3'b011; 






        #20;
        op_i = 7'b1110000; 
        func_i = 3'b100;

        #20;
        op_i = 7'b0100000; 
        func_i = 3'b100; 






        #20;
        op_i = 7'b1110000; 
        func_i = 3'b101;

        #20;
        op_i = 7'b0101000; 
        func_i = 3'b101; 











        #20;
        op_i = 7'b1110000; 
        func_i = 3'b110;

        #20;
        op_i = 7'b0100000; 
        func_i = 3'b110; 



        #20;
        op_i = 7'b1110000; 
        func_i = 3'b111;

        #20;
        op_i = 7'b0111000; 
        func_i = 3'b111; 














        // funciones de shift creo

        #20;
        op_i = 7'b1100000; 
        func_i = 3'b000;

        #20;
        op_i = 7'b1100000; 
        func_i = 3'b001; 



        #20;
        op_i = 7'b1100000; 
        func_i = 3'b010;

        #20;
        op_i = 7'b1100000; 
        func_i = 3'b011; 




    // funciones de memoria


        #20;
        op_i = 7'b1000000; 
        func_i = 3'b000;

        #20;
        op_i = 7'b1000000; 
        func_i = 3'b001; 



        #20;
        op_i = 7'b1000000; 
        func_i = 3'b010;

        #20;
        op_i = 7'b1000000; 
        func_i = 3'b011; 

        // Funciones de branch


        #20;
        op_i = 7'b1111100; 
        func_i = 3'b000;

        #20;
        op_i = 7'b1111100; 
        func_i = 3'b010; 



        #20;
        op_i = 7'b1111100; 
        func_i = 3'b100;

        #20;
        op_i = 7'b1111100; 
        func_i = 3'b110; 


        // funciones de jump

        #20;
        op_i = 7'b1111000; 
        func_i = 3'b000;

        #20;
        op_i = 7'b1111000; 
        func_i = 3'b100; 





        // Funciones de misnelanearfvkjlewa


        #20;
        op_i = 7'b1111110; 
        func_i = 3'b000;

        #20;
        op_i = 7'b1111110; 
        func_i = 3'b001; 



        #20;
        op_i = 7'b1111110; 
        func_i = 3'b010;

        #20;
        op_i = 7'b1111110; 
        func_i = 3'b011; 



        #20;
        op_i = 7'b1111110; 
        func_i = 3'b100;

        #20;
        op_i = 7'b1111110; 
        func_i = 3'b101; 




	end
	
	initial begin
		forever #2 clk = ~clk; 
	end


endmodule