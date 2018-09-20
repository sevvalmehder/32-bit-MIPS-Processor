//32 bit sayılarla Arithmetic işlemler yapan modül. 
//Tüm instructionların yapması gerekenler burada halledildi. 
module ALU32bit(ALU_result, sig_branch, opcode, rs_content, rt_content, shamt, ALU_control, immediate);
	
	input [5:0] ALU_control, opcode;
	input [4:0] shamt; // shamt
	input [15:0] immediate;
	input [31:0] rs_content, rt_content; //inputs
	
	output reg sig_branch;
	output reg [31:0] ALU_result; //output
	
	integer i; //for loop
	// temp for sra command
	reg signed [31:0] temp, signed_rs, signed_rt; 
	reg [31:0] signExtend, zeroExtend;

	always @ (ALU_control, rs_content, rt_content, shamt, immediate) begin
		
		
		// signed value assigment
		signed_rs = rs_content;
		signed_rt = rt_content;
			
			
		// R-type instruction
		if(opcode == 6'h0) begin
			
			case(ALU_control)
			
				6'h20 : //add
					ALU_result = signed_rs + signed_rt;
				
				6'h21 : //addu
					ALU_result = rs_content + rt_content;
					
				6'h22 : //sub
					ALU_result = signed_rs - signed_rt;
					
				6'h23 : //subu
					ALU_result = rs_content - rt_content;
					
				6'h24 : //and
					ALU_result = rs_content & rt_content;
					
				6'h25 : //or
					ALU_result = rs_content | rt_content;
					
				6'h27 : //nor
					ALU_result = ~(rs_content | rt_content);
					
				6'h03 : //sra
					begin
						temp = rt_content;
						for(i = 0; i < shamt; i = i + 1) begin
							temp = {temp[31],temp[31:1]}; //add the lsb for msb
						end
					
					ALU_result = temp;
					end
					
				6'h02 : //srl
					ALU_result = (rt_content >> shamt);
			
				6'h00 : //sll
					ALU_result = (rt_content << shamt);
				
				6'h2b : //sltu
					begin
						if(rs_content < rt_content) begin
							ALU_result = 1;
						end else begin
							ALU_result = 0;
						end
					end
					
				6'h2a : //slt
					begin
						if(signed_rs < signed_rt) begin
							ALU_result = 1;
						end else begin
							ALU_result = 0;
						end
					end
			
			endcase //case
			
		end // if
		
		
		
		// I type
		else begin
			
			signExtend = {{16{immediate[15]}}, immediate};
			zeroExtend = {{16{1'b0}}, immediate};
			
			case(opcode)
		
				6'h8 : // addi
					ALU_result = signed_rs + signExtend;
					
				6'h9 : // addiu
					ALU_result = rs_content + signExtend;
					
				6'b010010 : // andi
					ALU_result = rs_content & zeroExtend;
					
				6'h4 : // beq
					begin
						// if the result is zero, they are equal go branch!
						ALU_result = signed_rs - signed_rt;
						if(ALU_result == 0) begin
							sig_branch = 1'b1;
						end
						else begin
							sig_branch = 1'b0;
						end
					end
				
				6'h5 : // bne
					begin
						// if the result is not zero, they are not equal go branch!
						ALU_result = signed_rs - signed_rt;
						if(ALU_result != 0) begin
							sig_branch = 1'b1;
							ALU_result = 1'b0;
						end
						else begin
							sig_branch = 1'b0;
						end
					end
				
				6'b010101 : // lui
					ALU_result = {immediate, {16{1'b0}}};
				
				6'b010011 : // ori
					ALU_result = rs_content | zeroExtend;
				
				6'b001010 : // slti
					begin
						if(signed_rs < $signed(signExtend)) begin
							ALU_result = 1;
						end else begin
							ALU_result = 0;
						end
					end
				
				6'b001011 : // sltiu
					begin
						if(rs_content < signExtend) begin
							ALU_result = 1;
						end else begin
							ALU_result = 0;
						end
					end
				6'h28 : // sb
					ALU_result = signed_rs + signExtend;
				6'h29 : // sh
					ALU_result = signed_rs + signExtend;
				6'h2b : // sw
					ALU_result = signed_rs + signExtend;
				6'h23 : // lw
					ALU_result = signed_rs + signExtend;
				6'h24 : // lbu
					ALU_result = signed_rs + signExtend;
				6'h25 : // lhu
					ALU_result = signed_rs + signExtend;
				6'h30 : // ll
					ALU_result = signed_rs + signExtend;
				
			endcase
		
		end
		
	end
	
	
	initial begin
		$monitor("opcode: %6b, Rs content: %32b, rt content: %32b, signExtendImm = %32b, result: %32b\n",
		opcode, rs_content, rt_content, signExtend, ALU_result);
	end
	
endmodule