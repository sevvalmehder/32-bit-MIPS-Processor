//Instruction okumaya yardımcı modül, program counter değiştikçe okuma yapar. 
//Program ilk başladığında initial değerleri dosyadan çeker.
module read_instructions(instruction, program_counter);

	input [31:0] program_counter;
	output reg [31:0] instruction;
	
	reg [31:0] instructions [255:0];
	
	initial begin 
		$readmemb("instruction.mem", instructions);
	end
	
	always @ (program_counter) begin
		instruction = instructions[program_counter];
	end

endmodule