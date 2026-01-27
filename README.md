**Overview =>
This project implements a complete Universal Asynchronous Receiver–Transmitter (UART) protocol using Verilog HDL.
The design includes a fully functional UART Transmitter (TX), UART Receiver (RX), and a Baud Rate Generator, verified through simulation and implemented on an FPGA.
The UART supports 8-bit data transmission, 1 start bit, 1 stop bit, and uses 16× oversampling in the receiver for reliable data recovery.


**Features =>
UART Transmitter and Receiver implemented using FSM-based RTL design
Configurable Baud Rate Generator
16× oversampling receiver for accurate mid-bit sampling
Start and stop bit handling
TX–RX loopback verification
Self-checking testbench
Synthesizable and FPGA-ready design


**Tools Used=>
Verilog HDL
Xilinx Vivado (Simulation, Synthesis, Implementation)
FPGA Development Board (for hardware validation)
