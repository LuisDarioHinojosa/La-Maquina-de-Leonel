`timescale 1ns/1ns
module FLILFLOPTB;

    logic clk;
    logic rst;
    logic clock_en;
    logic we; // write enable normal
    logic c_i; // input normal
    logic z_i; // input normal
    logic iwe; // write enable interrupcion
    logic intz_i; // input interrupion
    logic intc_i; // input interrupcion


    logic c_o;
    logic z_o;




FlipFlop fff(
    .clk(clk),
    .rst(rst),
    .clock_en(clock_en),
    .we(we), // write enable normal
    .c_i(c_i), // input normal
    .z_i(z_i), // input normal
    .iwe(iwe), // write enable interrupcion
    .intz_i(intz_i), // input interrupion
    .intc_i(intc_i), // input interrupcion


    .c_o(c_o),
    .z_o(z_o)

);


	task Initialvalues();
    clk = 0;
    rst = 0;
    clock_en = 1;
    we = 0; // write enable normal
    c_i = 0; // input normal
    z_i = 0; // input normal
    iwe = 0; // write enable interrupcion
    intz_i = 0; // input interrupion
    intc_i = 0;


    c_o = 0;
    z_o = 0;
	endtask


    initial begin
        Initialvalues();
        rst = 1;
        #10;
        rst = 0;
        #10;
        we = 1;
        c_i = 1;
        z_i = 1;
        #10;
        we = 0;
        c_i = 0;
        z_i = 0;
        #10;
        iwe = 1;
        intc_i = 1;
        intz_i = 1;
        #10;
        iwe = 0;
        intc_i = 0;
        intz_i = 0;






    end


	initial begin
		forever #2 clk = ~clk; 
	end




endmodule

