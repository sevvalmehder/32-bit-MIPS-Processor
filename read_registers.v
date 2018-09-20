//register contentlerinin okunması ya da registera yazılma işleminin yapılması için kullanıldı. 
//Program ilk başladığında initial değerleri dosyadan çeker.
module read_registers(
	output reg [31:0] read_data_1, read_data_2,
	input [31:0] write_data,
	input [4:0] read_reg_1, read_reg_2, write_reg, 
	input [5:0] opcode,
	input signal_regRead, signal_regWrite, signal_regDst, clk
);

	reg [31:0] registers [31:0];
	
	initial begin
		$readmemb("registers.mem", registers);
	end
	
	always @(write_data) begin
		// Write
		if(signal_regWrite) begin
			// write to rt if signal_regDst is 0, otherwise write to rd 
			if(signal_regDst) begin
				if(opcode == 6'h24)begin
					registers[write_reg][7:0] = write_data[7:0];
				end
				if(opcode == 6'h25)begin
					registers[write_reg][15:0] = write_data[15:0];
				end
				else begin
					registers[write_reg] = write_data;
				end
			end
			else begin
				if(opcode == 6'h24)begin
					registers[read_reg_2][7:0] = write_data[7:0];
				end
				if(opcode == 6'h25)begin
					registers[read_reg_2][15:0] = write_data[15:0];
				end
				else begin
					registers[read_reg_2] = write_data;
				end
			end
			// write to file
			$writememb("registers.mem",registers);
		end
	end
	
	always @(read_reg_1, read_reg_2) begin
		// Read
		if(signal_regRead) begin
			read_data_1 = registers[read_reg_1];
			read_data_2 = registers[read_reg_2];
		end
	end
	
	
	
	
//	initial begin
//		$monitor("31.content: %32b \n",
//		registers[31]);
//	end
endmodule