module punitfsm_tb();

	logic			clk_i; // si esta
	logic         	ClkEn_i; // si esta
	logic			rst_i; // si esta
	logic [17:0] 	inst_dat_i; // si esta 
	logic 			inst_ack_i; // si esta
	logic [7:0] 	data_dat_i; // si esta
	logic [7:0] 	port_data_i;// si esta
	logic [1:0]		RegMux_c_i; // si esta
	logic			RegWrt_c_i; // si esta
	logic 			op2_c_i; // si esta
	logic [3:0]		ALUOp_c_i; // si esta
	logic [2:0]		op_o; // si esta
	logic [2:0]		func_o; // si esta
	logic [11:0]	addr_o; // si esta
	logic [7:0]		disp_o; // si esta
	logic [7:0]		offset_o; // si esta
	logic [7:0]		rs_o; // si esta
	logic			carry_o; // si esta
	logic			zero_o; // si esta


		ABAJO_UNIT processing_unit	(
									.clk_i(clk_i),
									.ClkEn_e(ClkEn_i),
									.rst_i(rst_i),
									.inst_dat_i(inst_dat_i),
									.inst_ack_i(inst_ack_i),
									.data_dat_i(data_dat_i),
									.port_dat_i(port_data_i),
									.RegMux_c(RegMux_c_i),
									.RegWrt_c(RegWrt_c_i),
									.op2_c(op2_c_i),
									.ALUOp_c(ALUOp_c_i),
									.op_e(op_o),
									.func_e(func_o),
									.addr_e(addr_o),
									.disp_e(disp_o),
									.offset_e(offset_o),
									.rs_o(rs_o),
									.carry_e(carry_o),
									.zero_e(zero_o)
								);
								
	enum logic [2:0] {
	FETCH	= 3'b000,
	DECODE	= 3'b001,
	EXECUTE	= 3'b010,
	WRITEBACK = 3'b100
	} state;

	task Initialvalues();
		clk_i 		= '0;
		ClkEn_i		= '1;
		rst_i		= '1;
		inst_dat_i	= '0;
		inst_ack_i	= '0;
		data_dat_i	= '0;
		port_data_i	= '0;
		RegMux_c_i	= '0;
		RegWrt_c_i	= '0;
		op2_c_i		= '0;
		ALUOp_c_i	= '0;
		state 		= FETCH;
	endtask



	task printRegistersBefore();
	integer  j;
		for (j = 0 ; j < 8 ;j = j + 1)
			$display(processing_unit.registers.mem[j]);
	endtask
	/*	

	task printRegistersAfter();
		$display("After:");
		integer  k;
		for (k = 0 ; k < 8 ;k = k + 1)
			$display(processing_unit.registers.mem[k]);
	endtask
*/

	task newALUInstruction(string op, logic [2:0] rd, logic [2:0] rs, logic [2:0] rs2, logic [7:0] immed);
		//printRegistersBefore(op);
		// te concatena los bits segun lo que esta en el excel. 
		case (op)
			"add" 	 : inst_dat_i <= {4'b1110, rd, rs, rs2, 2'bxx, 3'b000};
			"addi"   : inst_dat_i <= {4'b0000, rd, rs,    		  immed};
			"addc"	 : inst_dat_i <= {4'b1110, rd, rs, rs2, 2'bxx, 3'b001};
			"addci"  : inst_dat_i <= {4'b0001, rd, rs,    		  immed};
			"sub" 	 : inst_dat_i <= {4'b1110, rd, rs, rs2, 2'bxx, 3'b010};
			"subi"   : inst_dat_i <= {4'b0010, rd, rs,    		  immed};
			"subc"	 : inst_dat_i <= {4'b1110, rd, rs, rs2, 2'bxx, 3'b011};
			"subci"  : inst_dat_i <= {4'b0011, rd, rs,    		  immed};
		endcase
	
		@(posedge clk_i); // FETCH
		inst_ack_i <= 1;
		RegWrt_c_i <= 0;
		state <= FETCH;
		@(posedge clk_i); // DECODE
		inst_ack_i <= 0;
		op2_c_i	   <= inst_dat_i[17] ? 1 : 0;
		RegMux_c_i <= 0;
	
	// dependiendo de la operacion se genera el selector para la alu
		case (op)
			"add" 	 : ALUOp_c_i <= 4'b0000;
			"addi"   : ALUOp_c_i <= 4'b0000;
			"addc"	 : ALUOp_c_i <= 4'b0001;
			"addci"  : ALUOp_c_i <= 4'b0001;
			"sub" 	 : ALUOp_c_i <= 4'b0010;
			"subi"   : ALUOp_c_i <= 4'b0010;
			"subc"	 : ALUOp_c_i <= 4'b0011;
			"subci"  : ALUOp_c_i <= 4'b0011;
		endcase
		state	   <= DECODE;
		@(posedge clk_i); //EXECUTE
		state	   <= EXECUTE;
		@(posedge clk_i); //WRITEBACK
		RegWrt_c_i <= 1;
		state	   <= WRITEBACK;
		//printRegistersAfter();
	endtask


	initial begin
		integer i;
		Initialvalues();
		
		// 6 clocks for reset propagation
		repeat (6) @(posedge clk_i);
		rst_i = 0;
		
		// Initialize Register Bank with Random Data --
		for (i = 0 ; i < 8 ;i = i + 1)
			processing_unit.registers.mem[i] = {$random};
		


		newALUInstruction("add" , 0, 3, 4, 'x);

		newALUInstruction("addi", 3, 0,'x, 255);
		newALUInstruction("sub" , 7, 3, 3, 'x);
		newALUInstruction("subi", 0, 5, 'x, 255);	
		newALUInstruction("sub" , 0, 0, 0, 'x);   // sets Reg 0 to Zero   R0 - R0 == 0 
		newALUInstruction("sub" , 1, 1, 1, 'x);   // sets Reg 0 to Zero   R1 - R1 == 0
		newALUInstruction("sub" , 2, 2, 2, 'x);   // sets Reg 0 to Zero	  R2 - R2 == 0
		newALUInstruction("addi", 1, 0, 'x, 100);   // sets Reg 1 to 100d
		newALUInstruction("addi", 2, 0, 'x, 200);   // sets Reg 2 to 200d 
		newALUInstruction("add" , 3, 1, 2, 'x);   // sets Reg 3 to be addition Reg1+Reg2 (will generate Carry)
		newALUInstruction("addci" , 4, 0, 'x, 255);   // should give 0 as result (will generate Carry)
		newALUInstruction("subc" , 5, 0, 4, 'x);   // should give -1 as result (Reg0 - Reg4 - Cin)  0-0-1
		newALUInstruction("add"  , 0, 0, 0, 'x);   // 0+0  should clear the carry_o
		newALUInstruction("subc" , 5, 0, 4, 'x);   // should give 0 as result (Reg0 - Reg4 - Cin)  0-0-0
	
		@(posedge clk_i);
		ClkEn_i <= 0;
		
	
	end

    initial begin
        forever #10 clk_i = ~clk_i;
    end

endmodule
