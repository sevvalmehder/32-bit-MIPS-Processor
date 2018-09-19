# 32-bit MIPS Processor

32-bit MIPS processor fully supporting all core instructions on [green card at MIPS book](https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_Green_Sheet.pdf).

## Introduction


### Big Picture
![Big Picture](https://github.com/sevvalmehder/32-bit-MIPS-Processor/blob/master/Report/theBigPicture.jpg)

### Lifecycle
(a) When clock trigger the program counter(PC), help to get the next instruction from module read_instruction.
(b) The inst_parser module realizes the instruction type(R type, I type, J type) then parses the instruction as an opcode, rs, rt, rd, shift amount, function, address and immediate.
(c) When opcode and function code change, all the signals that controlled by control_unit will be reset.
(d) If rs or rt registers change and there is read signal read_registers module will trigger.
(e) Signals about registers such as "read the register" or "write to register" signals.
(f) If the operation is an arithmetic operation, the content of rs and rt registers and shift amount value will send de ALU(Arithmetic Logical Unit)
(g) The result sended to register if the (e) signal is "write to register" signal.
(h) The resut sended to memory if the signal is about memory such as "write to memory" or "read from memory"
(i) Control the memory signals
(j) If signal is "read from memory" and the result must write to register(lw command), the result sended to read_register module

## Method
![Single Cycle Datapath]https://github.com/sevvalmehder/32-bit-MIPS-Processor/blob/master/Report/singleCycleDatapath.jpg)

There are 7 module:
  - Mips_core, as like a main.
  - read_instructions, to read the next instruction
  - inst_parser, instruction parser
  - control_unit, a control unit of processor
  - ALU32bit, 32 bit arithmetic logical unit.
  - read_data_memory, data memory of datapath
  - read_registers: control the register operations
