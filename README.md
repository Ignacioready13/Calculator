# Four-operation calculator for FPGA (SystemVerilog)

There are five main modules: 
* Controller (controller.sv)
* 7-segment display output (OutputBlock.sv)
* Keypad input (keypad.sv)
* Memory (Memory.sv)
* ALU (ALU.sv)

Additionally there is the toplevel module: calculator.sv.

I've successfully synthesized this project in Vivado and used it on an actual FPGA (the Boolean Board). I haven't committed the testbenches here yet.

