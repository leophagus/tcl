# Vivado - Game of Life

Conway's classic [Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) on [Xilinx](www.xilinx.com) [Vivado](https://www.xilinx.com/products/design-tools/vivado.html) !

Vivado is the
[FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array) design
software from Xilinx. Its intended purpose is to map your RTL/HL design to
Xilinx FPGAs. Vivado uses Tcl as its internal scripting language and features a
powerful GUI to visualize the FPGA device internals. FPGA devices are made up of a
regular 2-D array of tiles, sites and bels. Vivado TCL API allows these to be
highlighted with various colors, which is all we need for Game of Life :)

Xilinx Vivado toolset is available for free at xilinx.com (even
if you dont intend to buy an FPGA).

For best visuals,
1. Turn off Routing view
2. In the Device-Options menu, disable Tiles, Sites, Bels.
3. Minimize Tcl console. 

![Screenshot](../master/docs/VivadoLife_Large1.png)

![Screengrab](../master/docs/2018-11-05-2132-15.m4v)

Relatively low load. On my old i3 laptop, barely tops 20%. Theres room
for more optimization.

